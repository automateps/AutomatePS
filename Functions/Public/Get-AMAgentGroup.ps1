function Get-AMAgentGroup {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise agent groups.

        .DESCRIPTION
            Get-AMAgentGroup gets agent group objects from AutoMate Enterprise.  Get-AMAgentGroup can receive items on the pipeline and return related objects.

        .PARAMETER InputObject
            The object(s) to use in search for agent groups.

        .PARAMETER Name
            The name of the agent group (case sensitive).  Wildcard characters can be escaped using the ` character.  If using escaped wildcards, the string
            must be wrapped in single quotes.  For example: Get-AMAgentGroup -Name '`[Test`]'

        .PARAMETER ID
            The ID of the agent group.

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
            Agent groups related to the following objects can be retrieved by this function:
            Workflow
            Task
            Condition
            Process
            Agent
            Folder

        .OUTPUTS
            AgentGroup

        .EXAMPLE
            # Get agent group "group01"
            Get-AMAgentGroup "group01"

        .EXAMPLE
            # Get agent groups configured within any workflow for the task "My Task"
            Get-AMTask "My Task" | Get-AMAgentGroup

        .EXAMPLE
            # Get tasks using multiple filter sets
            Get-AMAgentGroup -FilterSet @{ Property = "Name"; Operator = "contains"; Value = "FTP"}

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
        $workflowCache = @{}
        $agentGroupCache = @{}
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
                $splat += @{ Resource = Format-AMUri -Path "agent_groups/list" -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                $result = Invoke-AMRestMethod @splat
            }
            "ByID" {
                $splat += @{ Resource = "agent_groups/$ID/get" }
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
                    if (-not $agentGroupCache.ContainsKey($obj.ConnectionAlias)) {
                        Write-Verbose "Caching agent group objects for server $($obj.ConnectionAlias) for better performance"
                        $agentGroupCache.Add($obj.ConnectionAlias, (Get-AMAgentGroup -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() -Connection $obj.ConnectionAlias))
                    }
                    Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
                    switch ($obj.Type) {
                        "Workflow" {
                            # Get agent groups that are assigned to items within the provided workflow(s)
                            foreach ($item in $obj.Items | Where-Object {($_.ConstructType) -in ("Condition","Task")}) {
                                $result += $agentGroupCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID}
                            }
                            foreach ($trigger in $obj.Triggers) {
                                $result += $agentGroupCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $trigger.AgentID}
                            }
                        }
                        "Task" {
                            if (-not $workflowCache.ContainsKey($obj.ConnectionAlias)) {
                                Write-Verbose "Caching workflow objects for server $($obj.ConnectionAlias) for better performance"
                                $workflowCache.Add($obj.ConnectionAlias, (Get-AMWorkflow -Connection $obj.ConnectionAlias))
                            }
                            # Get agent groups that are assigned to the provided task(s) within workflows
                            foreach ($workflow in $workflowCache[$obj.ConnectionAlias]) {
                                foreach ($item in $workflow.Items) {
                                    switch ($item.ConstructType) {
                                        "Task" {
                                            if ($item.ConstructID -eq $obj.ID) {
                                                $result += $agentGroupCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID}
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
                                                $result += $agentGroupCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $item.AgentID}
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
                                            $result += $agentGroupCache[$obj.ConnectionAlias] | Where-Object {$_.ID -eq $trigger.AgentID}
                                        }
                                    }
                                }
                            }
                        }
                        "Agent" {
                            foreach ($agentGroup in $agentGroupCache[$obj.ConnectionAlias]) {
                                if ($agentGroup.AgentIDs -contains $obj.ID) {
                                    $result += $agentGroup
                                }
                            }
                        }
                        "Folder" {
                            # Get folders contained within the provided folder(s)
                            $result += $agentGroupCache[$obj.ConnectionAlias] | Where-Object {$_.ParentID -eq $obj.ID}
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
