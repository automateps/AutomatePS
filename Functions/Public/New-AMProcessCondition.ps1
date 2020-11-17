function New-AMProcessCondition {
    <#
        .SYNOPSIS
            Creates a new Automate process condition.

        .DESCRIPTION
            New-AMProcessCondition creates a new process condition.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER ProcessName
            The name of the process.

        .PARAMETER Action
            The state of the process to trigger on.

        .PARAMETER TriggerOnce
            Only trigger the first time the process is started or stopped.

        .PARAMETER Started
            Only trigger when the process was running prior to the condition and is then stopped.

        .PARAMETER Wait
            Wait for the condition, or evaluate immediately.

        .PARAMETER Timeout
            If wait is specified, the amount of time before the condition times out.

        .PARAMETER TimeoutUnit
            The unit for Timeout (Seconds by default).

        .PARAMETER TriggerAfter
            The number of times the condition should occur before the trigger fires.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMProcessCondition.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProcessName,

        [ValidateNotNullOrEmpty()]
        [AMProcessTriggerState]$Action = [AMProcessTriggerState]::StoppedResponding,

        [ValidateNotNullOrEmpty()]
        [switch]$TriggerOnce = $false,

        [ValidateNotNullOrEmpty()]
        [switch]$Started = $false,

        [ValidateNotNullOrEmpty()]
        [switch]$Wait = $true,
        [int]$Timeout = 0,
        [AMTimeMeasure]$TimeoutUnit = [AMTimeMeasure]::Seconds,
        [int]$TriggerAfter = 1,

        [string]$Notes = "",

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    switch (($Connection | Measure-Object).Count) {
        1 {
            $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
            if (-not $Folder) { $Folder = $user | Get-AMFolder -Type CONDITIONS } # Place the condition in the users condition folder
            switch ($Connection.Version.Major) {
                10      { $newObject = [AMProcessTriggerv10]::new($Name, $Folder, $Connection.Alias) }
                11      { $newObject = [AMProcessTriggerv11]::new($Name, $Folder, $Connection.Alias) }
                default { throw "Unsupported server major version: $_!" }
            }
            $newObject.CreatedBy       = $user.ID
            $newObject.Notes           = $Notes
            $newObject.Wait            = $Wait.ToBool()
            if ($newObject.Wait) {
                $newObject.Timeout      = $Timeout
                $newObject.TimeoutUnit  = $TimeoutUnit
                $newObject.TriggerAfter = $TriggerAfter
            }
            $newObject.Action          = $Action
            $newObject.ProcessName     = $ProcessName
            if ($Action -in ([AMProcessTriggerState]::Started,[AMProcessTriggerState]::Ended)) {
                $newObject.TriggerOnce = $TriggerOnce.ToBool()
            }
            if ($Action -eq [AMProcessTriggerState]::Ended) {
                $newObject.Started = $Started.ToBool()
            }
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple Automate servers are connected, please specify which server to create the new condition on!" }
    }
}