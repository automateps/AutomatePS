function Remove-AMAgentGroupMember {
    <#
        .SYNOPSIS
            Removes agents from an Automate agent group.

        .DESCRIPTION
            Remove-AMAgentGroupMember can remove agents from an agent group.

        .PARAMETER InputObject
            The agent group to modify.

        .PARAMETER Agent
            The agent(s) to remove to the agent group.

        .INPUTS
            The following Automate object types can be modified by this function:
            AgentGroup

        .OUTPUTS
            None

        .EXAMPLE
            # Remove all agents from an agent group
            Get-AMAgentGroup "All Agents" | Remove-AMAgentGroupMember -Agent *

        .EXAMPLE
            # Remove an agent from an agent group (using agent object)
            Get-AMAgentGroup | Remove-AMAgentGroupMember -Agent (Get-AMAgent "Agent1")

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMAgentGroupMember.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
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
                    if ($update.AgentIDs -contains $a.ID) {
                        $update.AgentIDs = @($update.AgentIDs | Where-Object {$_ -ne $a.ID})
                        $shouldUpdate = $true
                        Write-Verbose "Removing agent '$($a.Name)' from agent group '$($obj.Name)'."
                    } else {
                        Write-Verbose "Agent '$($a.Name)' not present in agent group '$($obj.Name)'."
                    }
                }
                if ($shouldUpdate) {
                    $update | Set-AMObject
                    Write-Verbose "Completed removing agents from agent group '$($obj.Name)'."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
