function Get-AMConsoleOutput {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise console output.

        .DESCRIPTION
            Get-AMConsoleOutput gets the console output.

        .PARAMETER MaxItems
            The maximum number of events in the console output to retrieve.

        .PARAMETER PollIntervalSeconds
            The number of seconds to wait between polls.  Specifying this parameter enables polling until cancelled by the user.

        .PARAMETER Colorize
            If specified, error output is written in red text.

        .PARAMETER Connection
            The AutoMate Enterprise management server.

        .EXAMPLE
            # Get console output from server "AM01"
            Get-AMConsoleOutput -Connection "AM01"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [int]$MaxItems = 20,

        [int]$PollIntervalSeconds,

        [ValidateNotNullOrEmpty()]
        [switch]$Colorize = $false,

        [ValidateNotNullOrEmpty()]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }

    $pollContinuously = $PSBoundParameters.ContainsKey("PollIntervalSeconds")
    $serverStartIndex = @{}
    $serverLastMessageCount = @{}
    do {
        foreach ($c in $Connection) {
            if (-not $serverStartIndex.ContainsKey($c.Alias)) {
                $serverStartIndex += @{$c.Alias = -1}
            }
            if (-not $serverLastMessageCount.ContainsKey($c.Alias)) {
                $serverLastMessageCount += @{$c.Alias = 0}
            }
            if ($serverStartIndex[$c.Alias] -eq -1) { # First poll
                $serverIndex = (Invoke-AMRestMethod -Resource "output/list" -RestMethod "Get" -Connection $c.Alias).IndexOfLastMessage -as [int]
                if (($serverIndex - $MaxItems) -ge 0) {
                    $serverStartIndex[$c.Alias] = $serverIndex - $MaxItems
                } else {
                    $serverStartIndex[$c.Alias] = 0
                }
            } else {
                $indexAdd = $serverLastMessageCount[$c.Alias]
                if ($indexAdd -gt 0) { $indexAdd += 1 }
                $serverStartIndex[$c.Alias] = $serverStartIndex[$c.Alias] + $indexAdd
            }
            Write-Verbose "Using index $($serverStartIndex[$c.Alias]) for server $($c.Alias) (last query returned $($serverLastMessageCount[$c.Alias]) messages)."
            $temp = Invoke-AMRestMethod -Resource "output/list?start_index=$($serverStartIndex[$c.Alias])&page_size=$MaxItems" -RestMethod "Get" -Connection $c.Alias
            $serverLastMessageCount[$c.Alias] = ($temp.Messages | Measure-Object).Count
            foreach ($message in $temp.Messages) {
                $message.TimeStamp = $message.TimeStamp.ToLocalTime()
                $message | Add-Member -MemberType NoteProperty -Name "ConnectionAlias" -Value $c.Alias
                if ($Colorize.ToBool()) {
                    switch ($message.Type) {
                        1       { Write-Host "$(Get-Date $message.TimeStamp -Format G) - $($message.Text) ($($message.ConnectionAlias))" -ForegroundColor Red }
                        default { Write-Host "$(Get-Date $message.TimeStamp -Format G) - $($message.Text) ($($message.ConnectionAlias))"}
                    }
                } else {
                    $message
                }
            }
        }
        if ($pollContinuously) {
            Start-Sleep -Seconds $PollIntervalSeconds
        }
    } until (-not $pollContinuously)
}
