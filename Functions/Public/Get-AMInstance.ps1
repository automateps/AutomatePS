function Get-AMInstance {
    <#
        .SYNOPSIS
            Gets Automate workflow and task instances.

        .DESCRIPTION
            Get-AMInstance gets instance objects from Automate.  Get-AMInstance can receive items on the pipeline and return related objects.

        .PARAMETER InputObject
            The object(s) to use in search for instances.

        .PARAMETER ID
            The ID of the instance.

        .PARAMETER TransactionID
            The transaction ID of the instance.

        .PARAMETER StartDate
            The first date of events to retrieve (Default: 1 day ago).

        .PARAMETER EndDate
            The last date of events to retrieve (Default: now).

        .PARAMETER Status
            The status of the instance:
                All
                Completed
                Running
                Success
                Failed
                Stopped
                Paused
                Aborted
                Queued
                ResumedFromFailure

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Operator, Value.
            Valid values for the Operator are: =, !=, <, >, contains (default - no need to supply Operator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .PARAMETER SortProperty
            The object property to sort results on.  Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

        .PARAMETER SortDescending
            If specified, this will sort the output on the specified SortProperty in descending order.  Otherwise, ascending order is assumed.

        .PARAMETER IncludeRelative
            If instance is searched for using the -ID parameter, or when a workflow, task or process is piped in, related instances are also returned.

        .PARAMETER Connection
            The Automate management server.

        .INPUTS
            Instances of the following objects can be retrieved by this function:
            Workflow
            Task
            Folder
            TaskAgent
            ProcessAgent

        .OUTPUTS
            Instance

        .EXAMPLE
            # Get currently running instances
            Get-AMInstance -Status Running

        .EXAMPLE
            # Get failed instances of workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Get-AMInstance -Status Failed

        .EXAMPLE
            # Get instances using filter sets
            Get-AMInstance -FilterSet @{ Property = "ResultText"; Operator = "contains"; Value = "FTP Workflow"}

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param (
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "ByPipeline")]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Position = 0, ParameterSetName = "ByID")]
        [ValidateNotNullOrEmpty()]
        [string]$ID,

        [Parameter(ParameterSetName = "ByTransactionID")]
        [ValidateNotNullOrEmpty()]
        [string]$TransactionID,

        [ValidateNotNullOrEmpty()]
        [DateTime]$StartDate = (Get-Date).AddDays(-1),

        [ValidateNotNullOrEmpty()]
        [DateTime]$EndDate = (Get-Date),

        [ValidateNotNullOrEmpty()]
        [AMInstanceStatus]$Status = [AMInstanceStatus]::All,

        [ValidateNotNull()]
        [Hashtable[]]$FilterSet = @(),

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And",

        [ValidateNotNullOrEmpty()]
        [switch]$IncludeRelative = $false,

        [ValidateNotNullOrEmpty()]
        [string[]]$SortProperty = "StartDateTime",

        [ValidateNotNullOrEmpty()]
        [switch]$SortDescending = $false,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    BEGIN {
        if ($StartDate -gt $EndDate) {
            throw "StartDate must be before EndDate!"
        }
        $splat = @{
            RestMethod = "Get"
        }
        if ($PSBoundParameters.ContainsKey("Connection")) {
            $Connection = Get-AMConnection -Connection $Connection
            $splat.Add("Connection",$Connection)
        }
        # ID queries are case-sensitive
        if ($PSBoundParameters.ContainsKey("ID")) { $ID = $ID.ToLower() }
        if ($PSBoundParameters.ContainsKey("TransactionID")) { $TransactionID = $TransactionID.ToLower() }
        $result = @()
    }

    PROCESS {
        switch($PSCmdlet.ParameterSetName) {
            "All" {
                $restFunction = "list"
                $tempFilterSet = $FilterSet
                switch($Status) {
                    "Running" {
                        $restFunction = "running/list"
                    }
                    "Completed" {
                        $restFunction = "completed/list"
                    }
                    default {
                        if ($Status -ne [AMInstanceStatus]::All) {
                            $tempFilterSet += @{Property = "Status"; Operator = "="; Value = $Status.value__}
                        }
                    }
                }
                $splat += @{ Resource = Format-AMUri -Path "instances/$restFunction" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -IncludeRelativeInstances:$IncludeRelative.ToBool() -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                $result = Invoke-AMRestMethod @splat
            }
            "ByID" {
                $tempFilterSet = $FilterSet + @{Property = "ID"; Operator = "="; Value = $ID}
                $splat += @{ Resource = Format-AMUri -Path "instances/list" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -IncludeRelativeInstances:$IncludeRelative.ToBool() -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                $result = Invoke-AMRestMethod @splat
            }
            "ByTransactionID" {
                $tempFilterSet = $FilterSet + @{Property = "TransactionID"; Operator = "="; Value = $TransactionID}
                $splat += @{ Resource = Format-AMUri -Path "instances/list" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -IncludeRelativeInstances:$IncludeRelative.ToBool() -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                $result = Invoke-AMRestMethod @splat
            }
            "ByPipeline" {
                foreach ($obj in $InputObject) {
                    $thisStatus = $Status  # Store the status temporarily, if multiple object types are on the pipeline (for example: workflows and instances)
                                           #   this will make sure instances on the pipeline are always returned, regardless of status
                    $tempSplat = $splat
                    if (-not $tempSplat.ContainsKey("Connection")) {
                        $tempSplat += @{ Connection = $obj.ConnectionAlias }
                    } else {
                        $tempSplat["Connection"] = $obj.ConnectionAlias
                    }
                    $tempResult = @()
                    Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
                    switch ($obj.Type) {
                        {($_ -in @("Workflow","Task","Process"))} {
                            $tempFilterSet = $FilterSet + @{Property = "ConstructID"; Operator = "="; Value = $obj.ID}
                            $tempSplat += @{ Resource = Format-AMUri -Path "instances/list" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -IncludeRelativeInstances:$IncludeRelative.ToBool() -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                            $tempResult += Invoke-AMRestMethod @tempSplat
                        }
                        "Agent" {
                            switch($Status) {
                                "Running" {
                                    $tempSplat += @{ Resource = Format-AMUri -Path "agents/$($obj.ID)/running_instances/list" -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                                }
                                default {
                                    $tempFilterSet = $FilterSet + @{Property = "AgentID"; Operator = "="; Value = $obj.ID}
                                    $tempSplat += @{ Resource = Format-AMUri -Path "instances/list" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -IncludeRelativeInstances:$IncludeRelative.ToBool() -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool()}
                                }
                            }
                            $tempResult += Invoke-AMRestMethod @tempSplat
                        }
                        "Folder" {
                            $tempSplat += @{ Resource = Format-AMUri -Path "instances/list" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $FilterSet -FilterSetMode $FilterSetMode -FolderID $obj.ID -IncludeRelativeInstances:$IncludeRelative.ToBool() -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                            $tempResult += Invoke-AMRestMethod @tempSplat
                        }
                        "Instance" {
                            $thisStatus = [AMInstanceStatus]::All
                            if ($obj.Status -eq "Running") {
                                $instanceEndDate = $EndDate
                            } else {
                                $instanceEndDate = $obj.EndDateTime
                            }
                            $tempResult += Get-AMInstance -ID $obj.ID -Status All -StartDate $obj.StartDateTime -EndDate $instanceEndDate -Connection $obj.ConnectionAlias -IncludeRelative:$IncludeRelative.ToBool()
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
                    switch($thisStatus) {
                        "All" {
                            $result += $tempResult
                        }
                        "Completed" {
                            $result += $tempResult | Where-Object {$_.Status -ne [AMInstanceStatus]::Running}
                        }
                        default {
                            $result += $tempResult | Where-Object {$_.Status -eq $thisStatus}
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
