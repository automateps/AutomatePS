function Get-AMSession {
    <#
        .SYNOPSIS
            Gets Automate user sessions.

        .DESCRIPTION
            Get-AMSession returns open SMC sessions from Automate.  This function uses the audit event log to determine which sessions are open.
            The results of this function could be inaccurate if a session wasn't closed property, or if audit events have aged out since the last server start.

        .PARAMETER Connection
            The Automate management server.

        .EXAMPLE
            # Gets all user sessions
            Get-AMSession

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )
    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }

    $result = @()
    foreach ($c in $Connection) {
        # Get events starting when the management server last started
        $mgtServer = Get-AMServer -Type Management -Connection $c -Verbose:$VerbosePreference
        $uptimeDays = [int]($mgtServer.Uptime.Split(".")[0])
        $uptimePart2 = $mgtServer.Uptime.Split(".")[1]
        $uptimeHours = [int]($uptimePart2.Split(":")[0])
        $uptimeMinutes = [int]($uptimePart2.Split(":")[1])
        $uptimeSeconds = [int]($uptimePart2.Split(":")[2])
        $uptime = New-TimeSpan -Days $uptimeDays -Hours $uptimeHours -Minutes $uptimeMinutes -Seconds $uptimeSeconds
        $filterSet = @()
        $filterSet += @{Property = "EventType"; Operator = "="; Value = [AMAuditEventType]::UserConnectedSmc.value__}
        $filterSet += @{Property = "EventType"; Operator = "="; Value = [AMAuditEventType]::UserDisconnectedSmc.value__}
        $events = Get-AMAuditEvent -FilterSet $filterSet -FilterSetMode Or -StartDate (Get-Date).Subtract($uptime) -Connection $c -Verbose:$VerbosePreference

        $connectEvents = ($events | Group-Object SessionID | Where-Object {$_.Count -eq 1}).Group | Where-Object {$_.EventType -eq [AMAuditEventType]::UserConnectedSmc.value__}

        foreach ($connectEvent in $connectEvents) {
            $eventData = @{}
            $connectEvent.Data.Split("|") | ForEach-Object {$eventData.Add($_.Split(":")[0],$_.Split(":")[1])}

            $result = [PSCustomObject]@{
                ID = $connectEvent.SessionID
                UserID = $connectEvent.UserID
                User = $eventData["User"]
                Machine = $eventData["MachineName"]
                IPAddress = $eventData["IP"]
                OSUser = $eventData["OSUser"]
                StartDateTime = $connectEvent.EventDateTime
                Duration = New-Timespan -Start $connectEvent.EventDateTime
                Type = [AMConstructType]::MachineConnection
                ConnectionAlias = $c.Alias
            }
            $result.PSObject.TypeNames.Insert(0,"CustomUserSession")
            $result
        }
    }
}
