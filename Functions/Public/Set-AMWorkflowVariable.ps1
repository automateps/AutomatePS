function Set-AMWorkflowVariable {
    <#
        .SYNOPSIS
            Sets a shared variable in a Automate workflow

        .DESCRIPTION
            Set-AMWorkflowVariable can set the initial value and description of shared variables in a workflow object.

        .PARAMETER InputObject
            The object to modify.

        .PARAMETER Name
            The name of the variable to modify.

        .PARAMETER InitialValue
            The initial value of the variable.

        .PARAMETER Description
            The description of the variable.

        .PARAMETER Type
            The data type of the variable.

        .PARAMETER PassValueFromParent
            If specified, the variable will be configured to pass the value from the parent workflow to this workflow.

        .PARAMETER PassValueToParent
            If specified, the variable will be configured to pass the value from this workflow to the parent workflow.

        .INPUTS
            The following Automate object types can be modified by this function:
            Workflow
            WorkflowVariable

        .EXAMPLE
            # Modify variable 'emailAddress' for workflow 'Some Workflow'
            Get-AMWorkflow "Some Workflow" | Set-AMWorkflowVariable -Name "emailAddress" -InitialValue "person@example.com" -PassValueFromParent -PassValueToParent:$false

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMWorkflowVariable.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [ValidateNotNull()]
        [string]$InitialValue,

        [ValidateNotNull()]
        [string]$Description,

        [ValidateNotNullOrEmpty()]
        [AMWorkflowVarType]$Type,

        [ValidateNotNullOrEmpty()]
        [switch]$PassValueFromParent,

        [ValidateNotNullOrEmpty()]
        [switch]$PassValueToParent
    )
    PROCESS {
        :objectloop foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                "Workflow" {
                    $updateObject = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                    $var = $updateObject.Variables | Where-Object {$_.Name -eq $Name}
                }
                "WorkflowVariable" {
                    $updateObject = Get-AMWorkflow -ID $obj.ParentID -Connection $obj.ConnectionAlias
                    $var = $updateObject.Variables | Where-Object {$_.ID -eq $obj.ID}
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
            $shouldUpdate = $false

            if (($PSBoundParameters.ContainsKey("InitialValue")) -and ($var.InitalValue -cne $InitialValue)) {
                if (($var.DataType) -in @([AMWorkflowVarDataType]::Array, [AMWorkflowVarDataType]::Dataset)) {
                    throw "Arrays and datasets do not support an initial value!"
                } else {
                    Write-Verbose "New initial value '$($InitialValue)' is different than current initial value '$($var.InitalValue)', it will be updated."
                    $var.InitalValue = $InitialValue
                    $shouldUpdate = $true
                }
            }
            if (($PSBoundParameters.ContainsKey("Description")) -and ($var.Description -ne $Description)) {
                $var.Description = $Description
                $shouldUpdate = $true
            }
            if (($PSBoundParameters.ContainsKey("Type")) -and ($var.VariableType -ne $Type)) {
                if (($var.DataType) -in @([AMWorkflowVarDataType]::Array, [AMWorkflowVarDataType]::Dataset)) {
                    throw "Arrays and datasets do not support a specific data type!"
                } else {
                    $var.VariableType = $Type
                    $shouldUpdate = $true
                }
            }
            if (($PSBoundParameters.ContainsKey("PassValueFromParent")) -and ($var.Parameter -ne $PassValueFromParent.ToBool())) {
                if (($var.DataType) -in @([AMWorkflowVarDataType]::Array, [AMWorkflowVarDataType]::Dataset)) {
                    throw "Arrays and datasets do not support passing values from a parent workflow!"
                } else {
                    $var.Parameter = $PassValueFromParent.ToBool()
                    $shouldUpdate = $true
                }
            }
            if (($PSBoundParameters.ContainsKey("PassValueToParent")) -and ($var.Private -ne $PassValueToParent.ToBool())) {
                if (($var.DataType) -in @([AMWorkflowVarDataType]::Array, [AMWorkflowVarDataType]::Dataset)) {
                    throw "Arrays and datasets do not support passing values to a parent workflow!"
                } else {
                    $var.Private = $PassValueToParent.ToBool()
                    $shouldUpdate = $true
                }
            }
            if ($shouldUpdate) {
                $updateObject | Set-AMObject
            } else {
                Write-Verbose "No changes will be made to variable '$($var.Name)' in $($updateObject.Type) '$($updateObject.Name)'."
            }
        }
    }
}
