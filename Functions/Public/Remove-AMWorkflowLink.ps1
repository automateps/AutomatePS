function Remove-AMWorkflowLink {
    <#
        .SYNOPSIS
            Removes a link from an AutoMate Enterprise workflow

        .DESCRIPTION
            Remove-AMWorkflowLink can remove links from a workflow object.

        .PARAMETER InputObject
            The link object to remove.

        .PARAMETER ID
            The ID of the link to remove (if passing in a workflow).

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Workflow
            WorkflowLink

        .OUTPUTS
            None

        .EXAMPLE
            # Remove all links from workflow "Some Workflow"
            (Get-AMWorkflow "Some Workflow").Links | Remove-AMWorkflowLink

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
        [string]$ID
    )

    PROCESS {
        :objectloop foreach ($obj in $InputObject) {
            $shouldUpdate = $false
            switch ($obj.Type) {
                "Workflow" {
                    $updateObject = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                    if (($updateObject | Measure-Object).Count -eq 1) {
                        $updateObject.Links = @($updateObject.Links | Where-Object {$_.ID -ne $ID})
                        $shouldUpdate = $true
                    } else {
                        Write-Warning "Multiple workflows found for ID $($obj.ID)! No action will be taken."
                        continue objectloop
                    }
                }
                "WorkflowLink" {
                    $updateObject = Get-AMObject -ID $obj.WorkflowID -Types Workflow
                    if (($updateObject | Measure-Object).Count -eq 1) {
                        $updateObject.Links = @($updateObject.Links | Where-Object {$_.ID -ne $obj.ID})
                        $shouldUpdate = $true
                    } else {
                        Write-Warning "Multiple workflows found for ID $($obj.WorkflowID)! No action will be taken."
                        continue objectloop
                    }
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
            if ($shouldUpdate) {
                $updateObject | Set-AMObject
            } else {
                Write-Verbose "$($updateObject.Type) '$($updateObject.Name)' does not contain a link with ID $($obj.ID)."
            }
        }
    }
}