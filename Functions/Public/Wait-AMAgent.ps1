function Wait-AMAgent {
    <#
        .SYNOPSIS
            Waits for AutoMate Enterprise agent to go online or offline.

        .DESCRIPTION
            Wait-AMAgent waits for an agent to online or offline.

        .PARAMETER InputObject
            The agents to wait for.

        .PARAMETER Online
            Specify whether to wait for the agent to go online or offline (-Online:$false)

        .PARAMETER Timeout
            Seconds to wait for the agent status to change before timing out.

        .INPUTS
            Agents can be supplied on the pipeline to this function.

        .EXAMPLE
            # Wait for all offline agents to come online
            Get-AMAgent | Where-Object {-not $_.Online} | Wait-AMAgent

            # Wait for agent 'agent01' to go offline
            Get-AMAgent -Name agent01 | Wait-AMAgent -Online:$false

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName = "All")]
    [OutputType([System.Object[]])]
    param(
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "ByPipeline")]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [switch]$Online = $true,

        [ValidateNotNullOrEmpty()]
        $Timeout
    )

    BEGIN {
        if ($Timeout) {
            $startTime = Get-Date
        }
        $status = "online"
        if (-not $Online) {
            $status = "offline"
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                "Agent" {
                    $complete = $false
                    while (-not $complete) {
                        $temp = Get-AMAgent -Name $obj.Name -Connection $obj.ConnectionAlias
                        if ($temp.Online -ne $Online) {
                            Write-Verbose "Waiting for $($temp.Type) '$($temp.Name)' to go $status..."
                            if ($Timeout) {
                                $now = Get-Date
                                if (($now - $startTime).Seconds -gt $Timeout) {
                                    $complete = $true
                                    Write-Error -Message "Timed out after $Timeout seconds waiting for $($temp.Type) '$($temp.Name)' to go $status!" -TargetObject $temp
                                }
                            }
                            Start-Sleep 1
                        } else {
                            $complete = $true
                            Write-Verbose "Complete!"
                        }
                    }
                    $temp
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
        }
    }
}
