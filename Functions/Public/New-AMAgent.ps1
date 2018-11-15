function New-AMAgent {
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise agent.

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

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
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
    if (($Connection | Measure-Object).Count -gt 1) {
        throw "Multiple AutoMate Servers are connected, please specify which server to create the new agent on!"
    }

    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
    if (-not $Folder) {
        switch ($Type) {
            "TaskAgent" {
                $Folder = Get-AMFolder -Name TASKAGENTS -Connection $Connection
            }
            "ProcessAgent" {
                $Folder = Get-AMFolder -Name PROCESSAGENTS -Connection $Connection
            }
        }
    }

    switch ($Connection.Version.Major) {
        10      { $newObject = [AMAgentv10]::new($Name, $Folder, $Connection.Alias) }
        11      { $newObject = [AMAgentv11]::new($Name, $Folder, $Connection.Alias) }
        default { throw "Unsupported server major version: $_!" }
    }
    $newObject.CreatedBy = $user.ID
    $newObject.Notes     = $Notes
    $newObject.AgentType = $Type
    $newObject | New-AMObject -Connection $Connection
}
