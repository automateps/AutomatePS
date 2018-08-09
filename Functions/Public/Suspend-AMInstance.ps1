function Suspend-AMInstance {
    <#
        .SYNOPSIS
            Pauses AutoMate Enterprise workflow and task instances.

        .DESCRIPTION
            Suspend-AMInstance suspends running workflow and task instances.

        .PARAMETER InputObject
            The instances to suspend.

        .INPUTS
            Instances can be supplied on the pipeline to this function.

        .EXAMPLE
            # Suspend all currently running instances
            Get-AMInstance -Status Running | Suspend-AMInstance

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "ByPipeline")]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Instance") {
                if ($obj.Status -eq "Running") {
                    switch ($obj.ConstructType) {
                        "Workflow" {
                            Invoke-AMRestMethod -Resource "workflows/$($obj.ConstructID)/running_instances/$($obj.ID)/pause" -RestMethod Post -Connection $obj.ConnectionAlias | Out-Null
                            Start-Sleep 1   # The instance can't be retrieved right away, have to pause briefly
                            $obj | Get-AMInstance
                        }
                        "Task" {
                            Invoke-AMRestMethod -Resource "tasks/$($obj.ConstructID)/running_instances/$($obj.ID)/pause" -RestMethod Post -Connection $obj.ConnectionAlias | Out-Null
                            Start-Sleep 1   # The instance can't be retrieved right away, have to pause briefly
                            $obj | Get-AMInstance
                        }
                        default {
                            Write-Error -Message "Unsupported construct type '$($obj.Type)' encountered! Workflow: $($obj.Name)" -TargetObject $obj
                        }
                    }
                } else {
                    Write-Error -Message "Instance $($obj.ID) is not running! Status: $_" -TargetObject $obj
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
