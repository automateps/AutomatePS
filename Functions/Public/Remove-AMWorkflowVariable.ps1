function Remove-AMWorkflowVariable {
    <#
        .SYNOPSIS
            Removes a shared variable from an Automate workflow

        .DESCRIPTION
            Remove-AMWorkflowVariable can remove shared variables from a workflow object.

        .PARAMETER InputObject
            The object to remove the variable from.

        .PARAMETER Name
            The name of the variable to remove.

        .INPUTS
            The following Automate object types can be modified by this function:
            Workflow
            WorkflowVariable

        .OUTPUTS
            None

        .EXAMPLE
            # Remove variable 'emailAddress' from workflow 'Some Workflow'
            Get-AMWorkflow "Some Workflow" | Remove-AMWorkflowVariable -Name "emailAddress"

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMWorkflowVariable.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            $shouldUpdate = $false
            switch ($obj.Type) {
                "Workflow" {
                    $update = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                    if ($update.Variables.Name -contains $Name) {
                        $update.Variables = @($update.Variables | Where-Object {$_.Name -ne $Name})
                        $shouldUpdate = $true
                    }
                }
                "WorkflowVariable" {
                    $update = Get-AMWorkflow -ID $obj.ParentID -Connection $obj.ConnectionAlias
                    $update.Variables = @($update.Variables | Where-Object {$_.ID -ne $obj.ID})
                    $shouldUpdate = $true
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }

            if ($shouldUpdate) {
                $update | Set-AMObject
            } else {
                Write-Verbose "$($obj.Type) '$($obj.Name)' does not contain a variable named '$Name'."
            }
        }
    }
}
