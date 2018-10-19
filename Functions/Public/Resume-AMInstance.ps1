function Resume-AMInstance {
    <#
        .SYNOPSIS
            Resumes AutoMate Enterprise workflow and task instances.

        .DESCRIPTION
            Resume-AMInstance resumes paused workflow and task instances.

        .PARAMETER InputObject
            The instances to resumes.

        .INPUTS
            Instances can be supplied on the pipeline to this function.

        .OUTPUTS
            Instance

        .EXAMPLE
            # Resumes all currently paused instances
            Get-AMInstance -Status Paused | Resume-AMInstance

        .EXAMPLE
            # Resumes all currently paused instances of workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Get-AMInstance -Status Paused | Resume-AMInstance

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 10/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName = "All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "ByPipeline")]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                "Instance" {
                    switch ($obj.Status) {
                        "Paused" {
                            switch ($obj.ConstructType) {
                                "Workflow" {
                                    Invoke-AMRestMethod -Resource "workflows/$($obj.ConstructID)/running_instances/$($obj.ID)/resume" -RestMethod Post -Connection $obj.ConnectionAlias | Out-Null
                                    Start-Sleep 1   # The instance can't be retrieved right away, have to pause briefly
                                    $uri = Format-AMUri -Path "instances/list" -FilterSet @{Property = "ID"; Operator = "="; Value = $obj.ID}
                                    Invoke-AMRestMethod -Resource $uri -RestMethod Get -Connection $obj.ConnectionAlias
                                }
                                "Task" {
                                    Invoke-AMRestMethod -Resource "tasks/$($obj.ConstructID)/running_instances/$($obj.ID)/resume" -RestMethod Post -Connection $obj.ConnectionAlias | Out-Null
                                    Start-Sleep 1   # The instance can't be retrieved right away, have to pause briefly
                                    $uri = Format-AMUri -Path "instances/list" -FilterSet @{Property = "ID"; Operator = "="; Value = $obj.ID}
                                    Invoke-AMRestMethod -Resource $uri -RestMethod Get -Connection $obj.ConnectionAlias
                                }
                                default {
                                    if ($_) { $message = "Unsupported construct type '$_' encountered! Workflow: $($obj.Name)"           }
                                    else    { $message = "Unsupported construct type '$($obj.Type)' encountered! Workflow: $($obj.Name)" }
                                    Write-Error -Message $message -TargetObject $obj
                                }
                            }
                        }
                        default {
                            Write-Error -Message "Instance $($obj.ID) is not suspended! Status: $_" -TargetObject $obj
                        }
                    }
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
        }
    }
}
