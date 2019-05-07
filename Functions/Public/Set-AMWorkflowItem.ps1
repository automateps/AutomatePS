function Set-AMWorkflowItem {
    <#
        .SYNOPSIS
            Sets an item in a AutoMate Enterprise workflow

        .DESCRIPTION
            Set-AMWorkflowItem can modify an item in a workflow object.

        .PARAMETER InputObject
            The object to modify - a workflow or a workflow item.

        .PARAMETER ID
            The ID of the item to modify (if passing in a workflow).

        .PARAMETER Construct
            The new construct (Workflow/Task/Process/Condition) to set for this item.

        .PARAMETER Agent
            The agent or agent group to assign to this item.

        .PARAMETER Enabled
            If the item is enabled or not.

        .PARAMETER UseLabel
            If the item should use the configured label or not.

        .PARAMETER Label
            The label to place on the item (specify -UseLabel) to show the label in the workflow designer.

        .PARAMETER Height
            The height of the object in the workflow designer.

        .PARAMETER Width
            The width of the object in the workflow designer.

        .PARAMETER X
            The x location of the object in the workflow designer.

        .PARAMETER Y
            The y location of the object in the workflow designer.

        .PARAMETER Expression
            The expression to set on the evaluation object.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Workflow
            WorkflowItem

        .EXAMPLE
            # Change the label on an item in a workflow
            Get-AMWorkflow "Some Workflow" | Set-AMWorkflowItem -ID "{1103992f-cbbd-44fd-9177-9de31b1070ab}" -Label "Do something" -UseLabel

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$ID,

        [ValidateScript({
            if ($_.Type -notin "Workflow","Task","Condition","Process") {
                throw [System.Management.Automation.PSArgumentException]"Construct is not a valid type!"
                $false
            } else {
                $true
            }
        })]
        $Construct,

        [ValidateScript({
            if (($_ -ne "") -and ($null -ne $_) -and ($_.Type -notin "Agent","AgentGroup")) {
                throw [System.Management.Automation.PSArgumentException]"Agent is not an Agent type!"
                $false
            } else {
                $true
            }
        })]
        $Agent,

        [ValidateNotNullOrEmpty()]
        [switch]$Enabled,

        [ValidateNotNullOrEmpty()]
        [switch]$UseLabel,

        [ValidateNotNull()]
        [string]$Label,

        [ValidateNotNullOrEmpty()]
        [int]$Height,

        [ValidateNotNullOrEmpty()]
        [int]$Width,

        [ValidateNotNullOrEmpty()]
        [int]$X,

        [ValidateNotNullOrEmpty()]
        [int]$Y,

        [ValidateNotNull()]
        [string]$Expression
    )

    BEGIN {
        if ($null -eq $Agent) { $Agent = "" }
    }

    PROCESS {
        :objectloop foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                "Workflow" {
                    $updateObject = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                    $item = $updateObject.Items | Where-Object {$_.ID -eq $ID}
                    if ($null -eq $item) {
                        $item = $updateObject.Triggers | Where-Object {$_.ID -eq $ID}
                    }
                }
                "WorkflowItem" {
                    $updateObject = Get-AMObject -ID $obj.WorkflowID -Types Workflow
                    if (($updateObject | Measure-Object).Count -eq 1) {
                        $item = $updateObject.Items | Where-Object {$_.ID -eq $obj.ID}
                        if ($null -eq $item) {
                            $item = $updateObject.Triggers | Where-Object {$_.ID -eq $obj.ID}
                        }
                    } else {
                        Write-Warning "Multiple workflows found for ID $($obj.WorkflowID)! No action will be taken."
                        continue objectloop
                    }
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
            if ($null -eq $item) {
                throw "Unable to find workflow item with the specified ID!"
                break
            }
            $shouldUpdate = $false
            if ($PSBoundParameters.ContainsKey("Construct") -and ($item.ConstructID -ne $Construct.ID)) {
                $item.ConstructID = $Construct.ID
                $item.ConstructType = $Construct.Type
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("Agent") -and ($item.AgentID -ne $Agent.ID)) {
                $item.AgentID = $Agent.ID
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("Enabled") -and ($item.Enabled -ne $Enabled.ToBool())) {
                $item.Enabled = $Enabled.ToBool()
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("UseLabel") -and ($itemvar.UseLabel -ne $UseLabel.ToBool())) {
                $item.UseLabel = $UseLabel.ToBool()
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("Label") -and ($item.Label -ne $Label)) {
                $item.Label = $Label
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("Height") -and ($item.Height -ne $Height)) {
                $item.Height = $Height
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("Width") -and ($item.Width -ne $Width)) {
                $item.Width = $Width
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("X") -and ($item.X -ne $X)) {
                $item.X = $X
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("Y") -and ($item.Y -ne $Y)) {
                $item.Y = $Y
                $shouldUpdate = $true
            }
            if ($PSBoundParameters.ContainsKey("Expression") -and ($item.Expression -ne $Expression) -and ($item.ConstructType -eq "Evaluation")) {
                $item.Expression = $Expression
                $shouldUpdate = $true
            }
            if ($shouldUpdate) {
                $updateObject | Set-AMObject
            } else {
                Write-Verbose "No changes will be made to item '$($item.ID)' in $($updateObject.Type) '$($updateObject.Name)'."
            }
        }
    }
}
