function Stop-AMInstance {
    <#
        .SYNOPSIS
            Stops Automate workflow and task instances.

        .DESCRIPTION
            Stop-AMInstance stops running workflow and task instances.

        .PARAMETER InputObject
            The instances to stop.

        .INPUTS
            Instances can be supplied on the pipeline to this function.

        .EXAMPLE
            # Stops all currently running instances
            Get-AMInstance -Status Running | Stop-AMInstance

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="All",SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    [OutputType([System.Object[]])]
    param (
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "ByPipeline")]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                "Instance" {
                    switch ($obj.Status) {
                        {($_ -in @("Running","Paused","Queued"))} {
                            switch ($obj.ConstructType) {
                                "Workflow" {
                                    if ($PSCmdlet.ShouldProcess($obj.ConnectionAlias, "Stopping Workflow instance: '$($obj.ConstructName)'")) {
                                        Invoke-AMRestMethod -Resource "workflows/$($obj.ConstructID)/running_instances/$($obj.ID)/stop" -RestMethod Post -Connection $obj.ConnectionAlias | Out-Null
                                        Start-Sleep 1   # The instance can't be retrieved right away, have to pause briefly
                                        try {
                                            $obj | Get-AMInstance
                                        } catch {
                                            Write-Error -Message "Exception occurred while stopping workflow instance $($obj.ID): $_" -TargetObject $obj
                                        }
                                    }
                                }
                                "Task" {
                                    if ($PSCmdlet.ShouldProcess($obj.ConnectionAlias, "Stopping Task instance: '$($obj.ConstructName)'")) {
                                        Invoke-AMRestMethod -Resource "tasks/$($obj.ConstructID)/running_instances/$($obj.ID)/stop" -RestMethod Post -Connection $obj.ConnectionAlias | Out-Null
                                        Start-Sleep 1   # The instance can't be retrieved right away, have to pause briefly
                                        try {
                                            $obj | Get-AMInstance
                                        } catch {
                                            Write-Error -Message "Exception occurred while stopping task instance $($obj.ID): $_" -TargetObject $obj
                                        }
                                    }
                                }
                                default {
                                    Write-Error -Message "Unsupported construct type '$($obj.Type)' encountered! Workflow: $($obj.Name)" -TargetObject $obj
                                }
                            }
                        }
                        default {
                            Write-Error -Message "Instance $($obj.ID) is not running! Status: $_" -TargetObject $obj
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
