function Get-AMFolder {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise folders.

        .DESCRIPTION
            Get-AMFolder gets folders objects from AutoMate Enterprise.  Get-AMFolder can receive items on the pipeline and return related objects.

        .PARAMETER InputObject
            The object(s) to use in search for folders.

        .PARAMETER Name
            The name of the folder (case sensitive).  Wildcard characters can be escaped using the ` character.  If using escaped wildcards, the string
            must be wrapped in single quotes.  For example: Get-AMFolder -Name '`[Test`]'

        .PARAMETER ID
            The ID of the folder.

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Operator, Value.
            Valid values for the Operator are: =, !=, <, >, contains (default - no need to supply Operator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .PARAMETER Path
            The path containing the folder.

        .PARAMETER Parent
            Get folders that contain the specified folders.  This parameter is only used when a folder is piped in.

        .PARAMETER Recurse
            If specified, searches recursively for subfolders.

        .PARAMETER Type
            The folder type: AGENTGROUPS, CONDITIONS, PROCESSAGENTS, PROCESSES, TASKAGENTS, TASKS, USERGROUPS, USERS, WORKFLOWS

        .PARAMETER SortProperty
            The object property to sort results on.  Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

        .PARAMETER SortDescending
            If specified, this will sort the output on the specified SortProperty in descending order.  Otherwise, ascending order is assumed.

        .PARAMETER Connection
            The AutoMate Enterprise management server.

        .INPUTS
            Agents related to the following objects can be retrieved by this function:
            Folder
            Workflow
            Task
            Process
            Condition
            Agent
            AgentGroup
            User
            UserGroup

        .OUTPUTS
            Folder

        .EXAMPLE
            # Get folder "My Folder"
            Get-AMFolder "My Folder"

        .EXAMPLE
            # Get folder containing workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Get-AMFolder

        .EXAMPLE
            # Get workflows in "My Folder"
            Get-AMFolder "My Folder" -Type WORKFLOWS | Get-AMWorkflow

        .EXAMPLE
            # Get folder "My Folder" by path
            Get-AMFolder -Path "\PROCESSES" -Name "My Folder"

        .EXAMPLE
            # Get subfolders of "My Folder"
            Get-AMFolder "My Folder" -Type PROCESSES | Get-AMFolder

        .EXAMPLE
            # Get folders using filter sets
            Get-AMFolder -FilterSet @{ Property = "Path"; Operator = "contains"; Value = "WORKFLOWS"}

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 01/28/2019

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

        [ValidateNotNull()]
        [Hashtable[]]$FilterSet = @(),

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And",

        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(ParameterSetName = "ByPipeline")]
        [ValidateNotNullOrEmpty()]
        [switch]$Parent = $false,

        [ValidateNotNullOrEmpty()]
        [switch]$Recurse = $false,

        # -RecurseCache is a private parameter used only within this function, and should not be used externally.
        #  This parameter allows the folder cache to be based to subsequent, recursive calls
        [Parameter(DontShow = $true)]
        [Hashtable]$RecurseCache = @{},

        [ValidateSet("AGENTGROUPS","CONDITIONS","PROCESSAGENTS","PROCESSES","TASKAGENTS","TASKS","USERGROUPS","USERS","WORKFLOWS")]
        [ValidateNotNullOrEmpty()]
        [string]$Type,

        [ValidateNotNullOrEmpty()]
        [string[]]$SortProperty = @("Path","Name"),

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
        } else {
            $Connection = Get-AMConnection
        }
        $result = @()
        $folderCache = @{}
        if ($RecurseCache.Keys.Count -gt 0) {
            $folderCache = $RecurseCache
        }
        $sortOptions = "sort_field=$($SortProperty[0])"
        if ($SortDescending.ToBool()) { $sortOptions += "&sort_order=DSC" }
        if ($Path -like "*?\") { $Path = $Path.TrimEnd("\") }
    }

    PROCESS {
        switch($PSCmdlet.ParameterSetName) {
            "All" {
                # Add -Path parameter to filter set
                if ($PSBoundParameters.ContainsKey("Path")) {
                    $FilterSet += @{Property = "Path"; Operator = "="; Value = $Path}
                }
                # Add -Name parameter to filter set, ignore if wildcards used (will be filtered after results are retrieved)
                if ($PSBoundParameters.ContainsKey("Name") -and -not [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)) {
                    $FilterSet += @{Property = "Name"; Operator = "="; Value = $Name}
                }
                # Call API
                $splat += @{ Resource = Format-AMUri -Path "folders/list" -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                $result += Invoke-AMRestMethod @splat
                # Add system folders (not supported by API)
                $result += Get-AMFolderRoot -FilterSet $FilterSet -FilterSetMode $FilterSetMode -Connection $Connection
            }
            "ByID" {
                # Check system folders first (no API call)
                $tempResult = Get-AMFolderRoot -Connection $Connection | Where-Object {$_.ID -eq $ID}
                # If nothing returned, call API
                if (-not $tempResult) {
                    $splat += @{ Resource = "folders/$ID/get" }
                    $result += Invoke-AMRestMethod @splat
                } else {
                    $result += $tempResult
                }
            }
            "ByPipeline" {
                foreach ($obj in $InputObject) {
                    $tempSplat = $splat
                    if (-not $tempSplat.ContainsKey("Connection")) {
                        $tempSplat += @{ Connection = $obj.ConnectionAlias }
                    } else {
                        $tempSplat["Connection"] = $obj.ConnectionAlias
                    }
                    if (-not $folderCache.ContainsKey($obj.ConnectionAlias)) {
                        Write-Verbose "Caching folder objects for server $($obj.ConnectionAlias) for better performance"
                        $tempCache = @()
                        $tempCache += Get-AMFolderRoot -FilterSet $FilterSet -FilterSetMode $FilterSetMode -Connection $obj.ConnectionAlias
                        $tempCache += Get-AMFolder -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() -Connection $obj.ConnectionAlias
                        $folderCache.Add($obj.ConnectionAlias, $tempCache)
                    }
                    Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
                    switch ($obj.Type) {
                        {($_ -in @("Workflow","Task","Process","Condition","Agent","AgentGroup","UserGroup"))} {
                            # Get folders containing the provided object(s)
                            $result += $folderCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $obj.ParentID}
                        }
                        "User" {
                            # Get the folder containing the user by default
                            if (-not $Type) { $Type = "USERS" }
                            switch ($Type) {
                                "USERS" {
                                    # Get folder containing the provided user(s)
                                    $result += $folderCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $obj.ParentID}
                                }
                                "WORKFLOWS" {
                                    # Get the workflow folder for the specified user ID
                                    $result += $folderCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $obj.WorkflowFolderID}
                                }
                                "TASKS" {
                                    # Get the task folder for the specified user ID
                                    $result += $folderCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $obj.TaskFolderID}
                                }
                                "PROCESSES" {
                                    # Get the process folder for the specified user ID
                                    $result += $folderCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $obj.ProcessFolderID}
                                }
                                "CONDITIONS" {
                                    # Get the condition folder for the specified user ID
                                    $result += $folderCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $obj.ConditionFolderID}
                                }
                            }
                        }
                        "Folder" {
                            if ($Parent) {
                                # Get folders that contain the provided folders(s)
                                $result += $folderCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $obj.ParentID}
                            } else {
                                # Get folders contained within the provided folder(s)
                                $result += $folderCache[$obj.ConnectionAlias] | Where-Object {$_.ParentID -eq $obj.ID}
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
        if ($Type) {
            # Filter folders to only the specified type
            $result = $result | Where-Object {($_.Path -like "\$Type*") -or ($_.Path -eq "\" -and $_.Name -eq $Type)}
        }
        if ($PSBoundParameters.ContainsKey("Name") -and [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)) {
            try   { "" -like $Name | Out-Null } # Test wildcard string
            catch { throw }                     # Throw error if wildcard invalid
            $result = $result | Where-Object {$_.Name -like $Name}
        }

        # Workaround for bug 23381 - the API returns PROCESSS as the path instead of PROCESSES
        foreach ($r in $result) {
            if ($r.Path -like "\PROCESSS*") {
                $r.Path = $r.Path.Replace("PROCESSS","PROCESSES")
            }
        }
        # End workaround

        if (($result.Count -gt 0) -and $Recurse) {
            $result += $result | Get-AMFolder -Recurse -RecurseCache $folderCache
        }

        $SortProperty += "ConnectionAlias","ID"
        return $result | Sort-Object $SortProperty -Unique -Descending:$SortDescending.ToBool()
    }
}