function Add-AMAgentGroupMember {
    <#
        .SYNOPSIS
            Adds agents to an AutoMate Enterprise agent group.

        .DESCRIPTION
            Add-AMAgentGroupMember adds agents to an agent group.

        .PARAMETER InputObject
            The agent group to modify.

        .PARAMETER Agent
            The agent name(s), or object(s) to add to the agent group.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            AgentGroup

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMAgentGroup "All Agents" | Add-AMAgentGroupMember -Agent *

        .EXAMPLE
            Get-AMAgentGroup | Add-AMAgentGroupMember -Agent (Get-AMAgent "Agent1")

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        $Agent
    )
    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "AgentGroup") {
                $update = Get-AMAgentGroup -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                foreach ($a in $Agent) {
                    if ($a.PSObject.Properties.Name -contains "Type") {
                        if ($a.Type -ne "Agent")  {
                            throw "Unsupported input type '$($a.Type)' encountered!"
                        }
                    } elseif ($a -is [string]) {
                        $tempAgent = Get-AMAgent -Name $a -Connection $obj.ConnectionAlias
                        if ($tempAgent) {
                            $a = $tempAgent
                        } else {
                            throw "Agent '$a' not found!"
                        }
                    }
                    if ($a.ConnectionAlias -eq $obj.ConnectionAlias) {
                        if ($update.AgentIDs -notcontains $a.ID) {
                            $update.AgentIDs += $a.ID
                            $shouldUpdate = $true
                            Write-Verbose "Adding agent '$($a.Name)' to agent group '$($obj.Name)'."
                        } else {
                            Write-Verbose "Agent '$($a.Name)' already present in agent group '$($obj.Name)'."
                        }
                    } else {
                        Write-Warning "Agent '$($a.Name)' on server $($a.ConnectionAlias) can not be added to agent group '$($obj.Name)' on server $($obj.ConnectionAlias)."
                    }
                }
                if ($shouldUpdate) {
                    $update | Set-AMObject
                    Write-Verbose "Completed adding agents to agent group '$($obj.Name)'."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
