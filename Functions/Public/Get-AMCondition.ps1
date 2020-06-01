function Get-AMCondition {
    <#
        .SYNOPSIS
            Gets Automate conditions.

        .DESCRIPTION
            Get-AMCondition gets condition objects from Automate.  Get-AMCondition can receive items on the pipeline and return related objects.

        .PARAMETER InputObject
            The object(s) use in search for conditions.

        .PARAMETER Name
            The name of the condition (case sensitive).  Wildcard characters can be escaped using the ` character.  If using escaped wildcards, the string
            must be wrapped in single quotes.  For example: Get-AMCondition -Name '`[Test`]'

        .PARAMETER ID
            The ID of the condition.

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Operator, Value.
            Valid values for the Operator are: =, !=, <, >, contains (default - no need to supply Operator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .PARAMETER Type
            The condition type:
                All
                Logon
                Window
                Schedule
                Keyboard
                Idle
                Performance
                EventLog
                FileSystem
                Process
                Service
                SNMPTrap
                WMI
                Database
                SharePoint

        .OUTPUTS
            Condition

        .PARAMETER SortProperty
            The object property to sort results on.  Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

        .PARAMETER SortDescending
            If specified, this will sort the output on the specified SortProperty in descending order.  Otherwise, ascending order is assumed.

        .PARAMETER Connection
            The Automate management server.

        .INPUTS
            Conditions related to the following objects can be retrieved by this function:
            Workflow
            Agent
            Folder

        .EXAMPLE
            Get-AMCondition "My Condition"
            Get-AMWorkflow "My Workflow" | Get-AMCondition

        .EXAMPLE
            # Get conditions that have "Daily" in the name and are not enabled, using filter sets
            Get-AMCondition -FilterSet @{ Property = "Name"; Operator = "contains"; Value = "Daily"},@{ Property = "Enabled"; Operator = "="; Value = "false"}

        .LINK
            https://github.com/AutomatePS/AutomatePS
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
        [AMTriggerType]$Type = [AMTriggerType]::All,

        [ValidateNotNullOrEmpty()]
        [string[]]$SortProperty = "Name",

        [ValidateNotNullOrEmpty()]
        [switch]$SortDescending = $false,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
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
        $conditionCache = @{}
        if ($PSBoundParameters.ContainsKey("Name") -and (-not [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name))) {
            $FilterSet += @{Property = "Name"; Operator = "="; Value = [System.Management.Automation.WildcardPattern]::Unescape($Name)}
        } elseif ($PSBoundParameters.ContainsKey("Name") -and [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)) {
            try   { "" -like $Name | Out-Null } # Test wildcard string
            catch { throw }                     # Throw error if wildcard invalid
            $splat += @{ FilterScript = {$_.Name -like $Name} }
        }
        if ($Type -ne [AMTriggerType]::All) {
            $FilterSet += @{Property = "TriggerType"; Operator = "="; Value = $Type.value__}
        }
    }

    PROCESS {
        switch($PSCmdlet.ParameterSetName) {
            "All" {
                $splat += @{ Resource = Format-AMUri -Path "conditions/list" -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                $result = Invoke-AMRestMethod @splat
            }
            "ByID" {
                $splat += @{ Resource = "conditions/$ID/get" }
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
                    if (-not $conditionCache.ContainsKey($obj.ConnectionAlias)) {
                        Write-Verbose "Caching condition objects for server $($obj.ConnectionAlias) for better performance"
                        $conditionCache.Add($obj.ConnectionAlias, (Get-AMCondition -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() -Connection $obj.ConnectionAlias))
                    }
                    Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
                    switch ($obj.Type) {
                        "Workflow" {
                            # Get conditions contained within the provided workflow(s)
                            foreach ($trigger in $obj.Triggers) {
                                switch ($trigger.ConstructType) {
                                    "Condition" {
                                        if ($trigger.ConstructID -ne "") {
                                            if ($Type -eq [AMTriggerType]::All) {
                                                $result += $conditionCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $trigger.ConstructID}
                                            } else {
                                                $result += $conditionCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $trigger.ConstructID -and $_.TriggerType -eq $Type}
                                            }
                                        } else {
                                            Write-Warning "Workflow '$($obj.Name)' contains an unbuilt condition!"
                                        }
                                    }
                                }
                            }
                        }
                        "Agent" {
                            # Get conditions monitored by the provided agent(s)
                            $tempFilterSet = $FilterSet
                            if ($Type -ne [AMTriggerType]::All) {
                                $tempFilterSet += @{ Property = "TriggerType"; Operator = "="; Value = $Type.value__ }
                            }
                            $tempSplat += @{ Resource = Format-AMUri -Path "agents/$($obj.ID)/conditions" -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                            $result += Invoke-AMRestMethod @tempSplat
                        }
                        "Folder" {
                            # Get conditions contained within the provided folder(s)
                            if ($Type -eq [AMTriggerType]::All) {
                                $result += $conditionCache[$obj.ConnectionAlias] | Where-Object {$_.ParentID -eq $obj.ID}
                            } else {
                                $result += $conditionCache[$obj.ConnectionAlias] | Where-Object {$_.ParentID -eq $obj.ID -and $_.TriggerType -eq $Type}
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
