function Get-AMConsoleOutput {
    <#
        .SYNOPSIS
            Gets Automate console output.

        .DESCRIPTION
            Get-AMConsoleOutput gets the console output.

        .PARAMETER MaxItems
            The maximum number of events in the console output to retrieve.

        .PARAMETER PollIntervalSeconds
            The number of seconds to wait between polls.  Specifying this parameter enables polling until cancelled by the user with Ctrl + C.

        .PARAMETER SuccessTextColor
            The text color to output success messages.

        .PARAMETER FailureTextColor
            The text color to output failure messages.

        .PARAMETER SuccessBackgroundColor
            The background color to output success messages.

        .PARAMETER FailureBackgroundColor
            The background color to output failure messages.

        .PARAMETER Connection
            The Automate management server.

        .EXAMPLE
            # Get console output from server "AM01"
            Get-AMConsoleOutput -Connection "AM01"

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [int]$MaxItems = 20,

        [int]$PollIntervalSeconds,

        [ConsoleColor]$SuccessTextColor = [ConsoleColor]::White,

        [ConsoleColor]$FailureTextColor = [ConsoleColor]::Red,

        [ConsoleColor]$SuccessBackgroundColor,

        [ConsoleColor]$FailureBackgroundColor,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
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
                    continue
                }
            } else {
                $indexAdd = $serverLastMessageCount[$c.Alias]
                if ($indexAdd -gt 0) { $indexAdd += 1 }
                $serverStartIndex[$c.Alias] = $serverStartIndex[$c.Alias] + $indexAdd
            }
            Write-Verbose "Using index $($serverStartIndex[$c.Alias]) for server $($c.Alias) (last query returned $($serverLastMessageCount[$c.Alias]) messages)."
            $uri = Format-AMUri -Path "output/list" -Parameters "start_index=$($serverStartIndex[$c.Alias])","page_size=$MaxItems"
            $temp = Invoke-AMRestMethod -Resource $uri -RestMethod "Get" -Connection $c.Alias
            $serverLastMessageCount[$c.Alias] = ($temp.Messages | Measure-Object).Count
            foreach ($message in $temp.Messages) {
                $message.TimeStamp = $message.TimeStamp.ToLocalTime()
                $message | Add-Member -MemberType NoteProperty -Name "ConnectionAlias" -Value $c.Alias
                $output = "$(Get-Date $message.TimeStamp -Format G) - $($message.Text)"
                if (($Connection | Measure-Object).Count -gt 1) {
                    $output += " (Connection: $($message.ConnectionAlias))"
                }
                $splat = @{ Object = $output }
                if ($message.Type -eq 1) {
                    $splat.Add("ForegroundColor", $FailureTextColor)
                    if ($PSBoundParameters.ContainsKey("FailureBackgroundColor")) {
                        $splat.Add("BackgroundColor", $FailureBackgroundColor)
                    }
                } else {
                    $splat.Add("ForegroundColor", $SuccessTextColor)
                    if ($PSBoundParameters.ContainsKey("SuccessBackgroundColor")) {
                        $splat.Add("BackgroundColor", $SuccessBackgroundColor)
                    }
                }
                Write-Host @splat
            }
        }
        if ($pollContinuously) {
            Start-Sleep -Seconds $PollIntervalSeconds
        }
    } until (-not $pollContinuously)
}
