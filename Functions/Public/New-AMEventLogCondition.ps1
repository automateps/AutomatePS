function New-AMEventLogCondition {
    <#
        .SYNOPSIS
            Creates a new Automate event log condition.

        .DESCRIPTION
            New-AMEventLogCondition creates a new event log condition.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER LogType
            The type of event log to monitor.

        .PARAMETER EventSource
            The source of the event to monitor.

        .PARAMETER EventType
            The type of event to monitor.

        .PARAMETER EventCategory
            The event category to monitor.

        .PARAMETER EventDescription
            Allows a description for the event to optionally be entered. To specify partial matches, use wildcard characters * or ?.

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
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMEventLogCondition.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [ValidateNotNullOrEmpty()]
        [string]$LogType = "Application",

        [ValidateNotNullOrEmpty()]
        [string]$EventSource = "All Sources",

        [ValidateNotNullOrEmpty()]
        [AMEventLogTriggerEventType]$EventType = [AMEventLogTriggerEventType]::Any,

        [ValidateNotNullOrEmpty()]
        [string]$EventCategory = "All Categories",

        [ValidateNotNullOrEmpty()]
        [string]$EventDescription = "*",

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
            if (-not $Folder) { $Folder = Get-AMDefaultFolder -Connection $Connection -Type CONDITIONS }
            switch ($Connection.Version.Major) {
                10                   { $newObject = [AMEventLogTriggerv10]::new($Name, $Folder, $Connection.Alias) }
                {$_ -in 11,22,23,24} { $newObject = [AMEventLogTriggerv11]::new($Name, $Folder, $Connection.Alias) }
                default              { throw "Unsupported server major version: $_!" }
            }
            $newObject.Notes            = $Notes
            $newObject.Wait             = $Wait.ToBool()
            if ($newObject.Wait) {
                $newObject.Timeout      = $Timeout
                $newObject.TimeoutUnit  = $TimeoutUnit
                $newObject.TriggerAfter = $TriggerAfter
            }
            $newObject.EventCategory    = $EventCategory
            $newObject.EventDescription = $EventDescription
            $newObject.EventSource      = $EventSource
            $newObject.EventType        = $EventType
            $newObject.LogType          = $EventLog
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple Automate servers are connected, please specify which server to create the new condition on!" }
    }
}