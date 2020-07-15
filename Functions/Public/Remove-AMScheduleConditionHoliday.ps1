function Remove-AMScheduleConditionHoliday {
    <#
        .SYNOPSIS
            Removes a holiday from an Automate schedule condition using the Holidays interval.

        .DESCRIPTION
            Remove-AMScheduleConditionHoliday removes a holiday from an Automate schedule condition using the Holidays interval.

        .PARAMETER InputObject
            The schedule condition object to remove the holiday from.

        .PARAMETER Holiday
            The holiday categories to remove from the schedule.

        .INPUTS
            The following Automate object types can be modified by this function:
            Condition

        .OUTPUTS
            None

        .EXAMPLE
            # Add a holiday category to schedule "On Specified Dates"
            Get-AMCondition "On Specified Dates" | Remove-AMScheduleConditionHoliday -Holiday "United States"

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMScheduleConditionHoliday.md
    #>
    [CmdletBinding(DefaultParameterSetName="Default",SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Holiday
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if (($obj.Type -eq "Condition") -and ($obj.TriggerType -eq [AMTriggerType]::Schedule) -and ($obj.ScheduleType -eq [AMScheduleType]::Holidays)) {
                $update = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                foreach ($h in $Holiday) {
                    if ($update.HolidayList -contains $h) {
                        $update.HolidayList = @($update.HolidayList | Where-Object {$_ -ne $h})
                        $shouldUpdate = $true
                    } else {
                        Write-Warning "$($obj.TriggerType) $($obj.Type) '$($obj.Name)' does not contain holiday category $h!"
                    }
                }
                if ($update.HolidayList.Count -eq 0) {
                    $shouldUpdate = $false
                    throw "A schedule condition using the Holiday interval must have at least 1 holiday category specified!"
                }
                if ($shouldUpdate) {
                    $update | Set-AMObject
                } else {
                    Write-Verbose "$($obj.TriggerType) $($obj.Type) '$($obj.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}