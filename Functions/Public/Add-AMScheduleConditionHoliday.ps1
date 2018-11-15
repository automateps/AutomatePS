function Add-AMScheduleConditionHoliday {
    <#
        .SYNOPSIS
            Adds a holiday to an AutoMate Enterprise schedule condition using the Holidays interval.

        .DESCRIPTION
            Add-AMScheduleConditionHoliday adds a holiday to an AutoMate Enterprise schedule condition using the Holidays interval.

        .PARAMETER InputObject
            The schedule condition object to add the holiday to.

        .PARAMETER Holiday
            The holiday categories to add to the schedule.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Condition

        .OUTPUTS
            None

        .EXAMPLE
            # Add a holiday category to schedule "On Specified Dates"
            Get-AMCondition "On Specified Dates" | Add-AMScheduleConditionHoliday -Holiday "United States"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
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
                    if ($update.HolidayList -notcontains $h) {
                        $update.HolidayList += $h
                        $shouldUpdate = $true
                    } else {
                        Write-Warning "$($obj.TriggerType) $($obj.Type) '$($obj.Name)' already contains holiday category $h!"
                    }
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
