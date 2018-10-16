function Start-AMProcess {
    <#
        .SYNOPSIS
            Starts AutoMate Enterprise processes.

        .DESCRIPTION
            Start-AMProcess starts processes.

        .PARAMETER InputObject
            The processes to start.

        .PARAMETER Agent
            The agent to run the process on.

        .PARAMETER AgentGroup
            The agent group to run the process on.

        .INPUTS
            Processes can be supplied on the pipeline to this function.

        .EXAMPLE
            # Starts process "My Process" on agent "agent01"
            Get-AMProcess "My Process" | Start-AMProcess -Agent "agent01"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 10/16/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(ParameterSetName = "Agent")]
        [ValidateNotNullOrEmpty()]
        $Agent,

        [Parameter(ParameterSetName = "AgentGroup")]
        [ValidateNotNullOrEmpty()]
        $AgentGroup
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Process") {
                switch($PSCmdlet.ParameterSetName) {
                    "Agent" {
                        if ($Agent.Type -ne "Agent") {
                            $name = $Agent
                            $Agent = Get-AMAgent -Name $name -Connection $obj.ConnectionAlias
                            if (($Agent | Measure-Object).Count -ne 1) {
                                throw "Agent '$name' not found!"
                            }
                        }
                        if ($Agent.AgentType -eq "ProcessAgent") {
                            Write-Verbose "Running process $($obj.Name) on agent $($Agent.Name)."
                            $runUri = Format-AMUri -Path "processes/$($obj.ID)/run" -Parameters "process_agent_id=$($Agent.ID)"
                        } else {
                            throw "Agent $($Agent.Name) is not a process agent!"
                        }
                    }
                    "AgentGroup" {
                        if ($AgentGroup.Type -ne "AgentGroup") {
                            $name = $AgentGroup
                            $AgentGroup = Get-AMAgentGroup -Name $name -Connection $obj.ConnectionAlias
                            if (($AgentGroup | Measure-Object).Count -ne 1) {
                                throw "Agent group '$name' not found!"
                            }
                        }

                        Write-Verbose "Running process $($obj.Name) on agent group $($AgentGroup.Name)."
                        $runUri = Format-AMUri -Path "processes/$($obj.ID)/run" -Parameters "agent_group_id=$($AgentGroup.ID)"
                    }
                }
                $instanceID = Invoke-AMRestMethod -Resource $runUri -RestMethod Post -Connection $obj.ConnectionAlias
                Start-Sleep -Seconds 1   # The instance can't be retrieved right away, have to pause briefly
                $listUri = Format-AMUri -Path "instances/list" -FilterSet @{Property = "ID"; Operator = "="; Value = $instanceID}
                Invoke-AMRestMethod -Resource $listUri -RestMethod Get -Connection $obj.ConnectionAlias
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
