function New-AMAgent {
    <#
        .SYNOPSIS
            Creates a new Automate agent.

        .DESCRIPTION
            New-AMAgent creates a new agent object.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER Type
            The type of agent to create: TaskAgent or ProcessAgent.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .EXAMPLE
            # Create new task agent
            New-AMAgent -Name Task_Agent1 -Type TaskAgent

        .EXAMPLE
            # Create new process agent
            New-AMAgent -Name Proc_Agent1 -Type ProcessAgent

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMAgent.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [ValidateNotNullOrEmpty()]
        [AMAgentType]$Type = ([AMAgentType]::TaskAgent),

        [string]$Notes = "",

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    if ($Type -eq [AMAgentType]::All) {
        throw "Please specify an agent type!"
    }

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    switch (($Connection | Measure-Object).Count) {
        1 {
            if (-not $Folder) {
                switch ($Type) {
                    "TaskAgent" {
                        $Folder = Get-AMFolder -Path "\" -Name "TASKAGENTS" -Connection $Connection
                    }
                    "ProcessAgent" {
                        $Folder = Get-AMFolder -Path "\" -Name "PROCESSAGENTS" -Connection $Connection
                    }
                }
            }
            switch ($Connection.Version.Major) {
                10                   { $newObject = [AMAgentv10]::new($Name, $Folder, $Connection.Alias) }
                {$_ -in 11,22,23,24} { $newObject = [AMAgentv11]::new($Name, $Folder, $Connection.Alias) }
                default              { throw "Unsupported server major version: $_!" }
            }
            $newObject.Notes     = $Notes
            $newObject.AgentType = $Type
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple Automate servers are connected, please specify which server to create the new agent on!" }
    }
}