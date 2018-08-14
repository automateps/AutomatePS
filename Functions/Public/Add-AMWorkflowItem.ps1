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
            # Add a link between "Copy Files" and "Move Files"
            Get-AMWorkflow "FTP Files" | Add-AMWorkflowItem -Item (Get-AMTask "Copy Files")

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/14/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = "ByConstruct")]
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
        [string]$Expression,

        [Parameter(Mandatory = $true, ParameterSetName = "ByWait")]
        [switch]$Wait,

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
                        $X = $maxX
                    } else {
                        $X = 10
                    }
                }
                if (-not $PSBoundParameters.ContainsKey("Y")) {
                    if (($allItems | Measure-Object).Count -gt 0) {
                        $maxY = ($allItems | Measure-Object -Property Y -Maximum).Maximum
                        $Y = $maxY + 50
                    } else {
                        $Y = 10
                    }
                }
                if (-not $PSBoundParameters.ContainsKey("Agent")) {
                    $Agent = Get-AMSystemAgent -Type Default -Connection $obj.ConnectionAlias
                }

                switch ($PSCmdlet.ParameterSetName) {
                    "ByConstruct" {
                        switch ((Get-AMConnection $obj.ConnectionAlias).Version.Major) {
                            10      { $newItem = [AMWorkflowItemv10]::new($obj.ConnectionAlias) }
                            11      { $newItem = [AMWorkflowItemv11]::new($obj.ConnectionAlias) }
                            default { throw "Unsupported server major version: $_!" }
                        }
                        # Workflows and Schedules don't use an agent, so there's no reason to set it
                        if (($Item.Type -ne "Workflow") -and ($Item.TriggerType -ne "Schedule")) {
                            $newItem.AgentID = $Agent.ID
                        }
                        $newItem.ConstructID = $Item.ID
                        $newItem.ConstructType = $Item.Type
                    }
                    "ByEvaluation" {
                        switch ((Get-AMConnection $obj.ConnectionAlias).Version.Major) {
                            10      { $newItem = [AMWorkflowConditionv10]::new($obj.ConnectionAlias) }
                            11      { $newItem = [AMWorkflowConditionv11]::new($obj.ConnectionAlias) }
                            default { throw "Unsupported server major version: $_!" }
                        }
                        $newItem.Expression = $Expression
                    }
                    "ByWait" {
                        switch ((Get-AMConnection $obj.ConnectionAlias).Version.Major) {
                            10      { $newItem = [AMWorkflowItemv10]::new($obj.ConnectionAlias) }
                            11      { $newItem = [AMWorkflowItemv11]::new($obj.ConnectionAlias) }
                            default { throw "Unsupported server major version: $_!" }
                        }
                        $newItem.ConstructType = [AMConstructType]::Wait
                    }
                }
                $newItem.WorkflowID = $obj.ID
                $newItem.X = $X
                $newItem.Y = $Y

                if ($updateObject.Items.Count -gt 0) {
                    $updateObject.Items += $newItem
                } else {
                    $updateObject.Items = @($newItem)
                }
                Set-AMWorkflow -Instance $updateObject
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
