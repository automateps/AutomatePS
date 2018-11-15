function Get-AMWorkflow {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise workflows.

        .DESCRIPTION
            Get-AMWorkflow gets workflow objects from AutoMate Enterprise.  Get-AMWorkflow can receive items on the pipeline and return related objects.

        .PARAMETER InputObject
            The object(s) use in search for workflows.

        .PARAMETER Name
            The name of the workflow (case sensitive).  Wildcard characters can be escaped using the ` character.  If using escaped wildcards, the string
            must be wrapped in single quotes.  For example: Get-AMWorkflow -Name '`[Test`]'

        .PARAMETER ID
            The ID of the workflow.

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Operator, Value.
            Valid values for the Operator are: =, !=, <, >, contains (default - no need to supply Operator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .PARAMETER Parent
            Get workflows that contain the specified workflow.  This parameter is only used when a workflow is piped in.

        .PARAMETER SortProperty
            The object property to sort results on.  Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

        .PARAMETER SortDescending
            If specified, this will sort the output on the specified SortProperty in descending order.  Otherwise, ascending order is assumed.

        .PARAMETER Connection
            The AutoMate Enterprise management server.

        .INPUTS
            Workflows related to the following objects can be retrieved by this function:
            Workflow
            Task
            Process
            Condition
            Folder
            Agent
            AgentGroup

        .OUTPUTS
            Workflow

        .EXAMPLE
            # Get workflow "My Workflow"
            Get-AMWorkflow "My Workflow"

        .EXAMPLE
            # Get sub-workflows in workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Get-AMWorkflow

        .EXAMPLE
            # Get workflows in folder "My Folder"
            Get-AMFolder "My Folder" -Type TASKS | Get-AMWorkflow

        .EXAMPLE
            # Get workflows using a filter set
            Get-AMWorkflow -FilterSet @{ Property = "Name"; Value = "FTP"}

        .EXAMPLE
            # Get workflows that have started in the last hour
            Get-AMWorkflow -FilterSet @{Property = "StartedOn"; Operator = ">"; Value = (Get-Date).AddHours(-1)}

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

        [Parameter(ParameterSetName = "ByPipeline")]
        [switch]$Parent = $false,

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
        $workflowCache = @{}
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
                $splat += @{ Resource = Format-AMUri -Path "workflows/list" -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                $result = Invoke-AMRestMethod @splat
            }
            "ByID" {
                $splat += @{ Resource = "workflows/$ID/get" }
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
                    if (-not $workflowCache.ContainsKey($obj.ConnectionAlias)) {
                        Write-Verbose "Caching workflow objects for server $($obj.ConnectionAlias) for better performance"
                        $workflowCache.Add($obj.ConnectionAlias, (Get-AMWorkflow -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() -Connection $obj.ConnectionAlias))
                    }
                    Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
                    switch ($obj.Type) {
                        "Workflow" {
                            if ($Parent) {
                                $result += $workflowCache[$obj.ConnectionAlias] | Where-Object {$_.Items.ConstructID -contains $obj.ID}
                            } else {
                                # Get workflows contained within the provided workflow(s)
                                foreach ($item in $obj.Items) {
                                    switch ($item.ConstructType) {
                                        "Workflow"   {
                                            if ($item.ConstructID -ne "") {
                                                $result += Get-AMWorkflow -ID $item.ConstructID -Connection $obj.ConnectionAlias
                                            } else {
                                                Write-Warning "Workflow '$($obj.Name)' contains an unbuilt workflow!"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        {($_ -in @("Task","Process"))} {
                            $result += $workflowCache[$obj.ConnectionAlias] | Where-Object {$_.Items.ConstructID -contains $obj.ID}
                        }
                        "Condition" {
                            $result += $workflowCache[$obj.ConnectionAlias] | Where-Object {($_.Items.ConstructID -contains $obj.ID) -or ($_.Triggers.ConstructID -contains $obj.ID)}
                        }
                        "Folder" {
                            # Get workflows located within the provided folder(s)
                            $result += $workflowCache[$obj.ConnectionAlias] | Where-Object {$_.ParentID -eq $obj.ID}
                        }
                        {($_ -in @("Agent","AgentGroup","SystemAgent"))} {
                            # Get workflows configured to run on the provided agent(s) or agent group(s)
                            :workflowloop foreach ($workflow in $workflowCache[$obj.ConnectionAlias]) {
                                foreach ($item in $workflow.Items) {
                                    if (($item.AgentID -eq $obj.ID) -and ($item.ConstructType -in @("Condition","Process","Task")) -and ($item.TriggerType -ne [AMTriggerType]::Schedule)) {
                                        $result += $workflow
                                        break workflowloop
                                    }
                                }
                                foreach ($trigger in $workflow.Triggers) {
                                    if (($trigger.AgentID -eq $obj.ID) -and ($trigger.TriggerType -ne [AMTriggerType]::Schedule)) {
                                        $result += $workflow
                                        break workflowloop
                                    }
                                }
                            }
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
