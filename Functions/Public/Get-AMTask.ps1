function Get-AMTask {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise tasks.

        .DESCRIPTION
            Get-AMTask gets task objects from AutoMate Enterprise.  Get-AMTask can receive items on the pipeline and return related objects.

        .PARAMETER InputObject
            The object(s) use in search for tasks.

        .PARAMETER Name
            The name of the task (case sensitive).  Wildcard characters can be escaped using the ` character.  If using escaped wildcards, the string
            must be wrapped in single quotes.  For example: Get-AMTask -Name '`[Test`]'

        .PARAMETER ID
            The ID of the task.

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Operator, Value.
            Valid values for the Operator are: =, !=, <, >, contains (default - no need to supply Operator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .PARAMETER SortProperty
            The object property to sort results on.  Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

        .PARAMETER SortDescending
            If specified, this will sort the output on the specified SortProperty in descending order.  Otherwise, ascending order is assumed.

        .PARAMETER Connection
            The AutoMate Enterprise management server.

        .INPUTS
            Tasks related to the following objects can be retrieved by this function:
            Workflow
            Folder

        .OUTPUTS
            Task

        .EXAMPLE
            # Get task "My Task"
            Get-AMTask "My Task"

        .EXAMPLE
            # Get tasks in workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Get-AMTask

        .EXAMPLE
            # Get tasks in folder "My Folder"
            Get-AMFolder "My Folder" -Type TASKS | Get-AMTask

        .EXAMPLE
            # Get tasks using multiple filter sets
            Get-AMTask -FilterSet @{ Property = "Name"; Operator = "contains"; Value = "Files"},@{ Property = "AML"; Operator = "contains"; Value = "FTP"}

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param (
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "ByPipeline")]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(ParameterSetName = "ByID")]
        [ValidateNotNullOrEmpty()]
        [string]$ID,

        [ValidateNotNullOrEmpty()]
        [Hashtable[]]$FilterSet,

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And",

        [ValidateNotNullOrEmpty()]
        [string[]]$SortProperty = "Name",

        [ValidateNotNullOrEmpty()]
        [switch]$SortDescending = $false,

        [ValidateNotNullOrEmpty()]
        $Connection
    )

    BEGIN {
        # If the server is specified, or only 1 server is connected, don't show it.  Otherwise, show the server.
        if ($PSCmdlet.ParameterSetName -eq "ByID" -and (-not $PSBoundParameters.ContainsKey("Connection")) -and ((Get-AMConnection).Count -gt 1)) {
            throw "When searching by ID: 1) Connection must be specified, OR 2) only one server can be connected."
        }
        $splat = @{
            RestMethod = "Get"
        }
        if ($PSBoundParameters.ContainsKey("Connection")) {
            $Connection = Get-AMConnection -Connection $Connection
            $splat.Add("Connection",$Connection)
        }
        $result = @()
        $taskCache = @{}
        if ($PSBoundParameters.ContainsKey("Name") -and (-not [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name))) {
            $FilterSet += @{Property = "Name"; Operator = "="; Value = [System.Management.Automation.WildcardPattern]::Unescape($Name)}
        } elseif ($PSBoundParameters.ContainsKey("Name") -and [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)) {
            try   { "" -like $Name | Out-Null } # Test wildcard string
            catch { throw }                     # Throw error if wildcard invalid
            $splat += @{ FilterScript = {$_.Name -like $Name} }
        }
    }

    PROCESS {
        switch($PSCmdlet.ParameterSetName) {
            "All" {
                $splat += @{ Resource = Format-AMUri -Path "tasks/list" -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                $result = Invoke-AMRestMethod @splat
            }
            "ByID" {
                $splat += @{ Resource = "tasks/$ID/get" }
                $result = Invoke-AMRestMethod @splat
            }
            "ByPipeline" {
                foreach ($obj in $InputObject) {
                    $tempSplat = $splat
                    if (-not $tempSplat.ContainsKey("Connection")) {
                        $tempSplat += @{ Connection = $obj.ConnectionAlias }
                    } else {
                        $tempSplat["Connection"] = $obj.ConnectionAlias
                    }
                    if (-not $taskCache.ContainsKey($obj.ConnectionAlias)) {
                        Write-Verbose "Caching task objects for server $($obj.ConnectionAlias) for better performance"
                        $taskCache.Add($obj.ConnectionAlias, (Get-AMTask -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() -Connection $obj.ConnectionAlias))
                    }
                    Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
                    switch ($obj.Type) {
                        "Workflow" {
                            # Get tasks contained within the provided workflow(s)
                            foreach ($item in $obj.Items) {
                                switch ($item.ConstructType) {
                                    "Task" {
                                        if ($item.ConstructID -ne "") {
                                            $result += $taskCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.ConstructID}
                                        } else {
                                            Write-Warning "Workflow '$($obj.Name)' contains an unbuilt task!"
                                        }
                                    }
                                }
                            }
                        }
                        "Folder" {
                            # Get tasks contained within the provided folder(s)
                            $result += $taskCache[$obj.ConnectionAlias] | Where-Object {$_.ParentID -eq $obj.ID}
                        }
                        default {
                            $unsupportedType = $obj.GetType().FullName
                            if ($_) {
                                $unsupportedType = $_
                            } elseif (-not [string]::IsNullOrEmpty($obj.Type)) {
                                $unsupportedType = $obj.Type
                            }
                            Write-Error -Message "Unsupported input type '$unsupportedType' encountered!" -TargetObject $obj
                        }
                    }
                }
            }
        }
    }

    END {
        $SortProperty += "ConnectionAlias", "ID"
        return $result | Sort-Object $SortProperty -Unique -Descending:$SortDescending.ToBool()
    }
}
