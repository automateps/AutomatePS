function Start-AMTask {
    <#
        .SYNOPSIS
            Starts AutoMate Enterprise tasks.

        .DESCRIPTION
            Start-AMTask starts tasks.

        .PARAMETER InputObject
            The tasks to start.

        .PARAMETER Agent
            The agent to run the task on.

        .PARAMETER AgentGroup
            The agent group to run the task on.

        .INPUTS
            Tasks can be supplied on the pipeline to this function.

        .EXAMPLE
            # Starts task "My Task" on agent "agent01"
            Get-AMTask "My Task" | Start-AMTask -Agent "agent01"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 10/19/2018

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
            if ($obj.Type -eq "Task") {
                switch($PSCmdlet.ParameterSetName) {
                    "Agent" {
                        if ($Agent -is [string]) {
                            $name = $Agent
                            # Can't assign agent directly because of ValidateNotNullOrEmpty on parameter
                            $tempAgent = Get-AMAgent -Name $name -Connection $obj.ConnectionAlias
                            if (($tempAgent | Measure-Object).Count -eq 1) {
                                $Agent = $tempAgent
                            } else {
                                throw "Agent '$name' not found!"
                            }
                        }
                        if ($Agent.Type -eq "Agent") {
                            if ($Agent.AgentType -eq "TaskAgent") {
                                if ($Agent.ConnectionAlias -eq $obj.ConnectionAlias) {
                                    Write-Verbose "Running task $($obj.Name) on agent $($Agent.Name)."
                                    $runUri = Format-AMUri -Path "tasks/$($obj.ID)/run" -Parameters "agent_id=$($Agent.ID)"
                                } else {
                                    throw "Task '$($obj.Name)' and agent '$($Agent.Name)' are not on the same server!" 
                                }
                            } else {
                                throw "Agent $($Agent.Name) is not a task agent!"
                            }
                        } else {
                            throw "Unsupported agent type '$($Agent.Type)' encountered!"
                        }
                    }
                    "AgentGroup" {
                        if ($AgentGroup -is [string]) {
                            $name = $AgentGroup
                            # Can't assign agent directly because of ValidateNotNullOrEmpty on parameter
                            $tempAgentGroup = Get-AMAgentGroup -Name $name -Connection $obj.ConnectionAlias
                            if (($tempAgentGroup | Measure-Object).Count -eq 1) {
                                $AgentGroup = $tempAgentGroup
                            } else {
                                throw "Agent group '$name' not found!"
                            }
                        }
                        if ($AgentGroup.Type -eq "AgentGroup") {
                            if ($AgentGroup.ConnectionAlias -eq $obj.ConnectionAlias) {
                                Write-Verbose "Running task $($obj.Name) on agent group $($AgentGroup.Name)."
                                $runUri = Format-AMUri -Path "tasks/$($obj.ID)/run" -Parameters "agent_group_id=$($AgentGroup.ID)"
                            } else {
                                throw "Task '$($obj.Name)' and agent group '$($AgentGroup.Name)' are not on the same server!" 
                            }
                        } else {
                            throw "Unsupported agent group type '$($AgentGroup.Type)' encountered!"
                        }
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