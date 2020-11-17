function Add-AMScheduleConditionCustomDate {
    <#
        .SYNOPSIS
            Adds a custom date to an Automate schedule condition using the Custom interval.

        .DESCRIPTION
            Add-AMScheduleConditionCustomDate adds a custom date to an Automate schedule condition using the Custom interval.

        .PARAMETER InputObject
            The schedule condition object to add the custom date to.

        .PARAMETER CustomLaunchDates
            The future launch date(s) to add to the schedule.

        .PARAMETER RemovePreviousDates
            If specified, past dates are removed from the schedule.

        .INPUTS
            The following Automate object types can be modified by this function:
            Condition

        .OUTPUTS
            None

        .EXAMPLE
            # Add a custom run time of 1 hour from now to schedule "On Specified Dates"
            Get-AMCondition "On Specified Dates" | Add-AMScheduleConditionCustomDate -CustomLaunchDates (Get-Date).AddHours(1)

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMScheduleConditionCustomDate.md
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [DateTime[]]$CustomLaunchDates,

        [ValidateNotNullOrEmpty()]
        [switch]$RemovePreviousDates
    )

    BEGIN {
        $now = Get-Date
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            if (($obj.Type -eq "Condition") -and ($obj.TriggerType -eq [AMTriggerType]::Schedule) -and ($obj.ScheduleType -eq [AMScheduleType]::Custom)) {
                $update = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                foreach ($date in $CustomLaunchDates) {
                    if ($date -gt $now) {
                        # Add the date
                        $update.Day.Add($date.ToString($AMScheduleDateFormat)) | Out-Null
                        # Update the next launch date
                        $nextLaunchDate = $update.Day | ForEach-Object {Get-Date $_} | Where-Object {$_ -gt $now} | Sort-Object | Select-Object -First 1
                        $update.NextLaunchDate = $nextLaunchDate.ToString($AMScheduleDateFormat)
                        # Cleanup old launch dates
                        if ($RemovePreviousDates.IsPresent) {
                            foreach ($day in $update.Day | Where-Object {(Get-Date $_) -le $now}) {
                                $update.Day.Remove($day)
                            }
                        }
                        $shouldUpdate = $true
                    } else {
                        Write-Warning "Date '$($date)' is in the past, and will not be added to schedule '$($obj.Name)'"
                    }
                }
                if ($shouldUpdate) {
                    $update | Set-AMObject
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}
