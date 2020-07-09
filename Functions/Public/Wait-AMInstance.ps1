function Wait-AMInstance {
    <#
        .SYNOPSIS
            Waits for Automate workflow and task instances to complete.

        .DESCRIPTION
            Wait-AMInstance waits for running workflow and task instances to complete.

        .PARAMETER InputObject
            The instances to wait for.

        .PARAMETER Timeout
            Seconds to wait for the instance to complete before timing out.

        .INPUTS
            Instances can be supplied on the pipeline to this function.

        .EXAMPLE
            # Suspend all currently running instances
            Get-AMInstance -Status Running | Wait-AMInstance

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([AMInstancev10],[AMInstancev11])]
    param (
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "ByPipeline")]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        $Timeout
    )

    BEGIN {
        if ($Timeout) {
            $startTime = Get-Date
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Instance") {
                if ($obj.Status -eq "Running") {
                    if ($obj.ConstructType -in "Workflow","Task") {
                        $complete = $false
                        while (-not $complete) {
                            $temp = $obj | Get-AMInstance
                            if (($temp.Status) -eq "Running") {
                                Write-Verbose "Waiting for $($temp.ConstructType) instance '$($temp.ConstructName)' to complete..."
                                if ($Timeout) {
                                    $now = Get-Date
                                    if (($now - $startTime).Seconds -gt $Timeout) {
                                        $complete = $true
                                        Write-Error -Message "Timed out after $Timeout seconds waiting for $($temp.ConstructType) instance '$($temp.ConstructName) to complete!" -TargetObject $temp
                                    }
                                }
                                Start-Sleep 1
                            } else {
                                $complete = $true
                                Write-Verbose "Complete!"
                            }
                        }
                        $temp
                    } else {
                        Write-Error -Message "Unsupported construct type '$($obj.Type)' encountered! Workflow: $($obj.Name)" -TargetObject $obj
                    }
                } else {
                    Write-Error -Message "Instance $($obj.ID) is not running! Status: $($obj.Status)" -TargetObject $obj
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
