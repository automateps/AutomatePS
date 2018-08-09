function Get-AMAgent {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise agents.

        .DESCRIPTION
            Get-AMAgent gets agent objects from AutoMate Enterprise.  Get-AMAgent can receive items on the pipeline and return related objects.

        .PARAMETER InputObject
            The object(s) to use in search for agents.

        .PARAMETER Name
            The name of the agent (case sensitive).  Wildcard characters can be escaped using the ` character.  If using escaped wildcards, the string
            must be wrapped in single quotes.  For example: Get-AMAgent -Name '`[Test`]'

        .PARAMETER ID
            The ID of the agent.

        .PARAMETER Type
            The type of agent.

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Comparator, Value.
            Valid values for the Comparator are: =, !=, <, >, contains (default - no need to supply Comparator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .PARAMETER SortProperty
            The object property to sort results on.  Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

        .PARAMETER SortDescending
            If specified, this will sort the output on the specified SortProperty in descending order.  Otherwise, ascending order is assumed.

        .PARAMETER Connection
            The AutoMate Enterprise management server.

        .INPUTS
            Agents related to the following objects can be retrieved by this function:
            Workflow
            Task
            Condition
            Process
            AgentGroup
            Folder
            Instance

        .OUTPUTS
            Agent

        .EXAMPLE
            # Get agent "agent01"
            Get-AMAgent "agent01"

        .EXAMPLE
            # Get agents in agent group "group01"
            Get-AMAgentGroup "group01" | Get-AMAgent

        .EXAMPLE
            # Get agents configured within any workflow for the condition "My Condition"
            Get-AMCondition "My Condition" | Get-AMAgent

        .EXAMPLE
            # Get agents using filter sets
            Get-AMAgent -FilterSet @{ Property = "Enabled"; Comparator = "="; Value = "true"}

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName = "All")]
    [OutputType([System.Object[]])]
    param(
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
        [AMAgentType]$Type = [AMAgentType]::All,

        [Hashtable[]]$FilterSet,

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And",

        [ValidateNotNullOrEmpty()]
        [string[]]$SortProperty = "Name",

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
        $agentCache = @{}
        if ($PSBoundParameters.ContainsKey("Name") -and (-not [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name))) {
            $FilterSet += @{Property = "Name"; Comparator = "="; Value = [System.Management.Automation.WildcardPattern]::Unescape($Name)}
        } elseif ($PSBoundParameters.ContainsKey("Name") -and [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)) {
            try   { "" -like $Name | Out-Null } # Test wildcard string
            catch { throw }                     # Throw error if wildcard invalid
            $splat += @{ FilterScript = {$_.Name -like $Name} }
        }
        if ($Type -ne [AMAgentType]::All) {
            $FilterSet += @{Property = "AgentType"; Comparator = "="; Value = $Type.value__}
        }
    }

    PROCESS {
        switch($PSCmdlet.ParameterSetName) {
            "All" {
                $splat += @{ Resource = Format-AMUri -Path "agents/list" -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                $result = Invoke-AMRestMethod @splat
            }
            "ByID" {
                if ($PSBoundParameters.ContainsKey("Type")) {
                    Write-Warning "Parameter -Type is ignored when querying by ID."
                }
                $splat += @{ Resource = "agents/$ID/get" }
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
                    if (-not $agentCache.ContainsKey($obj.ConnectionAlias)) {
                        Write-Verbose "Caching agent objects for server $($obj.ConnectionAlias) for better performance"
                        $agentCache.Add($obj.ConnectionAlias, (Get-AMAgent -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() -Connection $obj.ConnectionAlias))
                    }
                    Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
                    switch ($obj.Type) {
                        "Workflow" {
                            # Get agents that are assigned to items within the provided workflow(s)
                            foreach ($item in $obj.Items | Where-Object {($_.ConstructType) -in ("Condition","Task")}) {
                                if ($Type -eq [AMAgentType]::All) {
                                    $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID}
                                } else {
                                    $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID -and $_.AgentType -eq $Type}
                                }
                            }
                            foreach ($trigger in $obj.Triggers | Where-Object {($_.TriggerType) -notin ("Schedule")}) {
                                if ($Type -eq [AMAgentType]::All) {
                                    $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $trigger.AgentID}
                                } else {
                                    $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $trigger.AgentID -and $_.AgentType -eq $Type}
                                }
                            }
                        }
                        "Task" {
                            if (-not $workflowCache.ContainsKey($obj.ConnectionAlias)) {
                                Write-Verbose "Caching workflow objects for server $($obj.ConnectionAlias) for better performance"
                                $workflowCache.Add($obj.ConnectionAlias, (Get-AMWorkflow -Connection $obj.ConnectionAlias))
                            }
                            # Get agents that are assigned to the provided task(s) within workflows
                            foreach ($workflow in $workflowCache[$obj.ConnectionAlias]) {
                                foreach ($item in $workflow.Items) {
                                    switch ($item.ConstructType) {
                                        "Task" {
                                            if ($item.ConstructID -eq $obj.ID) {
                                                if ($Type -eq [AMAgentType]::All) {
                                                    $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID}
                                                } else {
                                                    $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID -and $_.AgentType -eq $Type}
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        "Process" {
                            if (-not $workflowCache.ContainsKey($obj.ConnectionAlias)) {
                                Write-Verbose "Caching workflow objects for server $($obj.ConnectionAlias) for better performance"
                                $workflowCache.Add($obj.ConnectionAlias, (Get-AMWorkflow -Connection $obj.ConnectionAlias))
                            }
                            # Get agents that are assigned to the provided task(s) within workflows
                            foreach ($workflow in $workflowCache[$obj.ConnectionAlias]) {
                                foreach ($item in $workflow.Items) {
                                    switch ($item.ConstructType) {
                                        "Process" {
                                            if ($item.ConstructID -eq $obj.ID) {
                                                if ($Type -eq [AMAgentType]::All) {
                                                    $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID}
                                                } else {
                                                    $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID -and $_.AgentType -eq $Type}
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        "Condition" {
                            if (-not $workflowCache.ContainsKey($obj.ConnectionAlias)) {
                                Write-Verbose "Caching workflow objects for server $($obj.ConnectionAlias) for better performance"
                                $workflowCache.Add($obj.ConnectionAlias, (Get-AMWorkflow -Connection $obj.ConnectionAlias))
                            }
                            # Get agent groups that are assigned to the provided task(s) within workflows
                            foreach ($workflow in $workflowCache[$obj.ConnectionAlias]) {
                                foreach ($trigger in $workflow.Triggers) {
                                    if ($trigger.ConstructID -eq $obj.ID) {
                                        if ($trigger.AgentID) {
                                            if ($Type -eq [AMAgentType]::All) {
                                                $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID}
                                            } else {
                                                $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID -and $_.AgentType -eq $Type}
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        "AgentGroup" {
                            # Get agents contained within the provided agent group(s)
                            foreach ($agentID in $obj.AgentIDs) {
                                if ($Type -eq [AMAgentType]::All) {
                                    $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $agentID}
                                } else {
                                    $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $agentID -and $_.AgentType -eq $Type}
                                }
                            }
                        }
                        "Folder" {
                            if ($Type -eq [AMAgentType]::All) {
                                # Get agents contained within the provided folder(s)
                                $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ParentID -eq $obj.ID}
                            } else {
                                $result += $agentCache[$obj.ConnectionAlias] | Where-Object {$_.ParentID -eq $obj.ID -and $_.AgentType -eq $Type}
                            }
                        }
                        "Instance" {
                            # If the AgentID property is not specified, it's probably a workflow instance, which can be ignored
                            if ($obj.AgentID -ne "") {
                                # Get agents that host the specified instance(s)
                                $result += Get-AMAgent -ID $obj.AgentID
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
