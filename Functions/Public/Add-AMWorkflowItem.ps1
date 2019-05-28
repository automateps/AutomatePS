function Add-AMWorkflowItem {
    <#
        .SYNOPSIS
            Adds an item to an AutoMate Enterprise workflow

        .DESCRIPTION
            Add-AMWorkflowItem can add an item to an AutoMate Enterprise workflow

        .PARAMETER InputObject
            The workflow to add the item to.

        .PARAMETER Item
            The item to add to the workflow.

        .PARAMETER Agent
            The agent to assign the item to in the workflow.

        .PARAMETER Expression
            The expression to set on the evaluation object.

        .PARAMETER Wait
            Adds a wait object.

        .PARAMETER UseLabel
            If the item should use the configured label or not.

        .PARAMETER Label
            The label to place on the item (specify -UseLabel) to show the label in the workflow designer.

        .PARAMETER X
            The X (horizontal) location of the new item.

        .PARAMETER Y
            The Y (vertical) location of the new item.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Workflow

        .OUTPUTS
            None

        .EXAMPLE
            # Add task "Copy Files" to workflow "FTP Files"
            Get-AMWorkflow "FTP Files" | Add-AMWorkflowItem -Item (Get-AMTask "Copy Files")

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = "ByConstruct")]
        [ValidateScript({
            if ($_.Type -in "Workflow","Task","Condition","Process") {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"Item is invalid!"
            }
        })]
        $Item,

        [Parameter(ParameterSetName = "ByConstruct")]
        [ValidateScript({
            if ($_.Type -in "Agent","AgentGroup","SystemAgent") {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"Agent is invalid!"
            }
        })]
        $Agent,

        [Parameter(Mandatory = $true, ParameterSetName = "ByEvaluation")]
        [ValidateNotNullOrEmpty()]
        [string]$Expression,

        [Parameter(Mandatory = $true, ParameterSetName = "ByWait")]
        [switch]$Wait,

        [ValidateNotNullOrEmpty()]
        [switch]$UseLabel,

        [ValidateNotNull()]
        [string]$Label,

        [int]$X,

        [int]$Y
    )

    PROCESS {
        :workflowloop foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Workflow") {
                $updateObject = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias

                $allItems = $updateObject.Items + $updateObject.Triggers
                if (-not $PSBoundParameters.ContainsKey("X")) {
                    if (($allItems | Measure-Object).Count -gt 0) {
                        $maxX = ($allItems | Measure-Object -Property X -Maximum).Maximum
                        $X = $maxX + 50
                    } else {
                        $X = 10
                    }
                }
                if (-not $PSBoundParameters.ContainsKey("Y")) {
                    if (($allItems | Measure-Object).Count -gt 0) {
                        $maxY = ($allItems | Measure-Object -Property Y -Maximum).Maximum
                        $Y = $maxY
                    } else {
                        $Y = 10
                    }
                }
                if (-not $PSBoundParameters.ContainsKey("Agent")) {
                    $Agent = Get-AMSystemAgent -Type Default -Connection $obj.ConnectionAlias
                }
                $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
                $isTrigger = $false
                switch ($PSCmdlet.ParameterSetName) {
                    "ByConstruct" {
                        if ($Item.Type -eq "Condition")  {
                            switch ($connection.Version.Major) {
                                10      { $newItem = [AMWorkflowTriggerv10]::new($obj.ConnectionAlias) }
                                11      { $newItem = [AMWorkflowTriggerv11]::new($obj.ConnectionAlias) }
                                default { throw "Unsupported server major version: $_!" }
                            }
                            $newItem.TriggerType = $Item.TriggerType
                            $isTrigger = $true
                        } else {
                            switch ($connection.Version.Major) {
                                10      { $newItem = [AMWorkflowItemv10]::new($obj.ConnectionAlias) }
                                11      { $newItem = [AMWorkflowItemv11]::new($obj.ConnectionAlias) }
                                default { throw "Unsupported server major version: $_!" }
                            }
                        }
                        # Workflows don't use an agent, so there's no reason to set it
                        if (($Item.Type -ne "Workflow") -and ($Item.TriggerType -ne "Schedule")) {
                            $newItem.AgentID = $Agent.ID
                        }
                        $newItem.ConstructID = $Item.ID
                        $newItem.ConstructType = $Item.Type
                    }
                    "ByEvaluation" {
                        switch ($connection.Version.Major) {
                            10      { $newItem = [AMWorkflowConditionv10]::new($obj.ConnectionAlias) }
                            11      { $newItem = [AMWorkflowConditionv11]::new($obj.ConnectionAlias) }
                            default { throw "Unsupported server major version: $_!" }
                        }
                        $newItem.Expression = $Expression
                    }
                    "ByWait" {
                        switch ($connection.Version.Major) {
                            10      { $newItem = [AMWorkflowItemv10]::new($obj.ConnectionAlias) }
                            11      { $newItem = [AMWorkflowItemv11]::new($obj.ConnectionAlias) }
                            default { throw "Unsupported server major version: $_!" }
                        }
                        $newItem.ConstructType = [AMConstructType]::Wait
                    }
                }
                $newItem.WorkflowID = $obj.ID
                $newItem.UseLabel = $UseLabel.ToBool()
                $newItem.Label = $Label
                $newItem.X = $X
                $newItem.Y = $Y

                if ($isTrigger) {
                    $updateObject.Triggers += $newItem
                } else {
                    $updateObject.Items += $newItem
                }
                Set-AMWorkflow -Instance $updateObject
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
