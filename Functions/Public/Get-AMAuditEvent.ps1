function Get-AMAuditEvent {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise audit events.

        .DESCRIPTION
            Get-AMAuditEvent gets audit events for AutoMate Enterprise objects.

        .PARAMETER InputObject
            The object(s) to retrieve audit events for.

        .PARAMETER StartDate
            The first date of events to retrieve (Default: 1 day ago).

        .PARAMETER EndDate
            The last date of events to retrieve (Default: now).

        .PARAMETER EventType
            The type of event(s) to be retrieved.  Use auto-complete or see types.ps1 for a full list.

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Operator, Value.
            Valid values for the Operator are: =, !=, <, >, contains (default - no need to supply Operator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .PARAMETER SortProperty
            The object property to sort results on.  Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

        .PARAMETER SortDescending
            If specified, this will sort the output on the specified SortProperty in descending order.  Otherwise, ascending order is assumed.

        .PARAMETER AuditUserActivity
            If this switch is supplied, then this function returns any audited events that were performed by the piped in user. Otherwise,
                audit events related to the user object are returned.

        .PARAMETER Connection
            The AutoMate Enterprise management server.

        .INPUTS
            Audit events for the following objects can be retrieved by this function:
            Workflow
            Task
            Condition
            Process
            TaskAgent
            ProcessAgent
            AgentGroup
            User
            UserGroup
            Folder

        .OUTPUTS
            AuditEvent

        .EXAMPLE
            # Get events for workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Get-AMAuditEvent

        .EXAMPLE
            # Get audit events using filter sets
            Get-AMAuditEvent -FilterSet @{Property = 'EventText'; Operator = 'contains'; Value = 'connection from IP 10.1.1.10'}

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Position = 0, ParameterSetName = "ByPipeline", ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [DateTime]$StartDate = (Get-Date).AddDays(-1),

        [ValidateNotNullOrEmpty()]
        [DateTime]$EndDate = (Get-Date),

        [ValidateNotNullOrEmpty()]
        [AMAuditEventType]$EventType = [AMAuditEventType]::All,

        [ValidateNotNull()]
        [Hashtable[]]$FilterSet = @(),

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And",

        [ValidateNotNullOrEmpty()]
        [string[]]$SortProperty = "EventDateTime",

        [ValidateNotNullOrEmpty()]
        [switch]$SortDescending = $false,

        [Parameter(ParameterSetName = "ByPipeline")]
        [ValidateNotNullOrEmpty()]
        [switch]$AuditUserActivity = $false,

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
        $result = @()
        if ($EventType -ne [AMAuditEventType]::All) {
            $FilterSet += @{Property = "EventType"; Operator = "="; Value = $EventType.value__}
        }
    }

    PROCESS {
        switch($PSCmdlet.ParameterSetName) {
            "All" {
                $splat += @{ Resource = Format-AMUri -Path "audit_events/get" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
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
                    Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
                    switch ($obj.Type) {
                        {($_ -in @("Workflow","Task","Process","Condition","Folder","Agent","AgentGroup","User","UserGroup"))} {
                            if ($obj.Type -eq "User" -and $AuditUserActivity) {
                                $tempFilterSet = $FilterSet + @{Property = "UserID"; Operator = "="; Value = $obj.ID}
                            } else {
                                $tempFilterSet = $FilterSet + @{Property = "PrimaryConstructID"; Operator = "="; Value = $obj.ID}
                                if ($AuditUserActivity) {
                                    Write-Warning "The -AuditUserActivity switch is only used when a user is piped in."
                                }
                            }
                            $tempSplat += @{ Resource = Format-AMUri -Path "audit_events/get" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                            $result += Invoke-AMRestMethod @tempSplat
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
