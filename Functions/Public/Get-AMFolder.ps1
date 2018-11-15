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
        [string]$Path,

        [Parameter(ParameterSetName = "ByPipeline")]
        [ValidateNotNullOrEmpty()]
        [switch]$Parent = $false,

        [ValidateNotNullOrEmpty()]
        [switch]$Recurse = $false,

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
        $sortOptions = "sort_field=$($SortProperty[0])"
        if ($SortDescending.ToBool()) { $sortOptions += "&sort_order=DSC" }
        if ($Path -like "*?\") { $Path = $Path.TrimEnd("\") }
    }

    PROCESS {
        switch($PSCmdlet.ParameterSetName) {
            "All" {
                if ($PSBoundParameters.ContainsKey("Path") -and $PSBoundParameters.ContainsKey("Name")) {
                    # If both Path and Name are provided
                    if (-not [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)) {
                        if ($Path -ne "\") { # The API doesn't return root folders
                            $FilterSet += @{Property = "Path"; Operator = "="; Value = $Path}
                            $FilterSet += @{Property = "Name"; Operator = "="; Value = $Name}
                        } elseif (-not $PSBoundParameters.ContainsKey("FilterSet")) {
                            $result += Get-AMFolderRoot -Connection $Connection | Where-Object {$_.Path -eq $Path -and $_.Name -eq $Name}
                        } else {
                            Write-Warning "Root folders are not returned when using -FilterSet!"
                        }
                    } else {
                        if ($Path -ne "\") { # The API doesn't return root folders
                            $FilterSet += @{Property = "Path"; Operator = "="; Value = $Path}
                        } elseif (-not $PSBoundParameters.ContainsKey("FilterSet")) {
                            $result += Get-AMFolderRoot -Connection $Connection | Where-Object {$_.Path -eq $Path -and $_.Name -like $Name}
                        } else {
                            Write-Warning "Root folders are not returned when using -FilterSet!"
                        }
                    }
                } elseif ($PSBoundParameters.ContainsKey("Path")) {
                    # If just path is provided
                    if ($Path -ne "\") { # The API doesn't return root folders
                        $FilterSet += @{Property = "Path"; Operator = "="; Value = $Path}
                    } elseif (-not $PSBoundParameters.ContainsKey("FilterSet")) {
                        $result += Get-AMFolderRoot -Connection $Connection | Where-Object {$_.Path -eq $Path}
                    } else {
                        Write-Warning "Root folders are not returned when using -FilterSet!"
                    }
                } elseif ($PSBoundParameters.ContainsKey("Name")) {
                    # If just name is provided
                    if (-not [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)) {
                        $FilterSet += @{Property = "Name"; Operator = "="; Value = $Name}
                        if (-not $PSBoundParameters.ContainsKey("FilterSet")) {
                            $result += Get-AMFolderRoot -Connection $Connection | Where-Object {$_.Name -eq $Name}
                        } else {
                            Write-Warning "Root folders are not returned when using -FilterSet!"
                        }
                    } elseif (-not $PSBoundParameters.ContainsKey("FilterSet")) {
                        $result += Get-AMFolderRoot -Connection $Connection | Where-Object {$_.Name -like $Name}
                    } else {
                        Write-Warning "Root folders are not returned when using -FilterSet!"
                    }
                } elseif (-not $PSBoundParameters.ContainsKey("FilterSet")) {
                    # If neither are provided
                    $result += Get-AMFolderRoot -Connection $Connection
                }
                if ($Path -ne "\") { # The API doesn't return root folders
                    $splat += @{ Resource = Format-AMUri -Path "folders/list" -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                    $result += Invoke-AMRestMethod @splat
                }
            }
            "ByID" {
                $tempResult = Get-AMFolderRoot -Connection $Connection | Where-Object {$_.ID -eq $ID}
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
                    Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
                    switch ($obj.Type) {
                        {($_ -in @("Workflow","Task","Process","Condition","Agent","AgentGroup","UserGroup"))} {
                            # Get folders containing the provided object(s)
                            $tempResult = Get-AMFolderRoot | Where-Object {$_.ID -eq $obj.ParentID}
                            if (-not $tempResult) {
                                $tempFilterSet = $FilterSet + @{Property = "ID"; Operator = "="; Value = $obj.ParentID}
                                $tempSplat += @{ Resource = Format-AMUri -Path "folders/list" -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                                $result += Invoke-AMRestMethod @tempSplat
                            } else {
                                $result += $tempResult
                            }
                        }
                        "User" {
                            # Get the folder containing the user by default
                            if (-not $Type) { $Type = "USERS" }
                            switch ($Type) {
                                "USERS" {
                                    # Get folder containing the provided user(s)
                                    $tempFilterSet = $FilterSet + @{Property = "ID"; Operator = "="; Value = $obj.ParentID}
                                    $tempSplat += @{ Resource = Format-AMUri -Path "folders/list" -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                                    $result += Invoke-AMRestMethod @tempSplat
                                }
                                "WORKFLOWS" {
                                    # Get the workflow folder for the specified user ID
                                    $tempResult = Get-AMFolderRoot -Connection $obj.ConnectionAlias | Where-Object {$_.ID -eq $obj.WorkflowFolderID}
                                    if (-not $tempResult) {
                                        $result += Get-AMFolder -ID $obj.WorkflowFolderID -Connection $obj.ConnectionAlias
                                    } else {
                                        $result += $tempResult
                                    }
                                }
                                "TASKS" {
                                    # Get the task folder for the specified user ID
                                    $tempResult = Get-AMFolderRoot -Connection $obj.ConnectionAlias | Where-Object {$_.ID -eq $obj.TaskFolderID}
                                    if (-not $tempResult) {
                                        $result += Get-AMFolder -ID $obj.TaskFolderID -Connection $obj.ConnectionAlias
                                    } else {
                                        $result += $tempResult
                                    }
                                }
                                "PROCESSES" {
                                    # Get the process folder for the specified user ID
                                    $tempResult = Get-AMFolderRoot -Connection $obj.ConnectionAlias | Where-Object {$_.ID -eq $obj.ProcessFolderID}
                                    if (-not $tempResult) {
                                        $result += Get-AMFolder -ID $obj.ProcessFolderID -Connection $obj.ConnectionAlias
                                    } else {
                                        $result += $tempResult
                                    }
                                }
                                "CONDITIONS" {
                                    # Get the condition folder for the specified user ID
                                    $tempResult = Get-AMFolderRoot -Connection $obj.ConnectionAlias | Where-Object {$_.ID -eq $obj.ConditionFolderID}
                                    if (-not $tempResult) {
                                        $result += Get-AMFolder -ID $obj.ConditionFolderID -Connection $obj.ConnectionAlias
                                    } else {
                                        $result += $tempResult
                                    }
                                }
                            }
                        }
                        "Folder" {
                            if ($Parent) {
                                $tempResult = Get-AMFolderRoot -Connection $obj.ConnectionAlias | Where-Object {$_.ID -eq $obj.ParentID}
                                if (-not $tempResult) {
                                    # Get folders that contain the provided folders(s)
                                    $tempFilterSet = $FilterSet + @{Property = "ID"; Operator = "="; Value = $obj.ParentID}
                                    $tempSplat += @{ Resource = Format-AMUri -Path "folders/list" -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                                    $result += Invoke-AMRestMethod @tempSplat
                                } else {
                                    $result += $tempResult
                                }
                            } else {
                                # Get folders contained within the provided folder(s)
                                $tempFilterSet = $FilterSet + @{Property = "ParentID"; Operator = "="; Value = $obj.ID}
                                $tempSplat += @{ Resource = Format-AMUri -Path "folders/list" -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                                $tempResult = Invoke-AMRestMethod @tempSplat
                                $result += $tempResult
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

        if (($result.Count -gt 0) -and $Recurse) {
            $result += $result | Get-AMFolder -Recurse
        }

        # End workaround
        $SortProperty += "ConnectionAlias","ID"
        return $result | Sort-Object $SortProperty -Unique -Descending:$SortDescending.ToBool()
    }
}
