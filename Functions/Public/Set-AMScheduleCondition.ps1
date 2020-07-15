function Set-AMScheduleCondition {
    <#
        .SYNOPSIS
            Sets properties of an Automate schedule condition.

        .DESCRIPTION
            Sets-AMScheduleCondition modifies an existing schedule condition.

        .PARAMETER InputObject
            The condition to modify.

        .PARAMETER ScheduleType
            Set the schedule to use a Custom interval.

        .PARAMETER NextLaunchDate
            The next time the schedule will execute

        .PARAMETER Frequency
            How frequently the schedule should execute the specified interval. For example: every 1 day, every 2 days, etc.

        .PARAMETER Day
            The day(s) of the week to execute the schedule on.

        .PARAMETER End
            The last date the schedule will execute.

        .PARAMETER Measure
            When using the -MonthInterval option, use this parameter to specify regular days, work days, or a specific weekday (i.e. Monday, Tuesday, etc.).

        .PARAMETER Month
            The month(s) to execute.

        .PARAMETER MonthInterval
            The frequency to execute when using a "Specific day(s) of the month" schedule type.

        .PARAMETER OnTaskLate
            The action to take when the task is late.

        .PARAMETER Reschedule
            Specify how the schedule should be rescheduled.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .EXAMPLE
            # Set schedule "Daily at 8PM" to disable the trigger when late
            Get-AMCondition "Daily at 8PM" | Set-AMScheduleCondition -ScheduleType Day -OnTaskLate DisableTrigger

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMScheduleCondition.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium",DefaultParameterSetName="Default")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [AMScheduleType]$ScheduleType,

        [ValidateNotNullOrEmpty()]
        [DateTime]$NextLaunchDate,

        [ValidateSet(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,"first","second","third","fourth","last")]
        $Frequency,

        [DayOfWeek[]]$Day,

        [DateTime]$End,

        [ValidateNotNullOrEmpty()]
        [AMScheduleMeasure]$Measure,

        [ValidateSet("January","February","March","April","May","June","July","August","September","October","November","December")]
        [string[]]$Month,

        [ValidateNotNullOrEmpty()]
        [int]$MonthInterval,

        [ValidateNotNullOrEmpty()]
        [AMOnTaskLateRescheduleOption]$OnTaskLate = [AMOnTaskLateRescheduleOption]::RunImmediately,

        [ValidateNotNullOrEmpty()]
        [AMRescheduleOption]$Reschedule = [AMRescheduleOption]::RelativeToOriginalTime,

        [AllowEmptyString()]
        [string]$Notes,

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::Schedule) {
                $updateObject = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                $boundParameterKeys = $PSBoundParameters.Keys | Where-Object {($_ -ne "InputObject") -and `
                                                                              ($_ -notin [System.Management.Automation.PSCmdlet]::CommonParameters) -and `
                                                                              ($_ -notin [System.Management.Automation.PSCmdlet]::OptionalCommonParameters)}
                foreach ($boundParameterKey in $boundParameterKeys) {
                    $property = $boundParameterKey
                    $value = $PSBoundParameters[$property]

                    # Handle special property types
                    if ($value -is [System.Management.Automation.SwitchParameter]) { $value = $value.ToBool() }
                    elseif ($value -is [DateTime])                                 { $value = Get-Date $value -Format $AMScheduleDateFormat }
                    elseif ($property -eq "Day") {
                        $value = ($Day -join ",").ToLower() -split ","
                        $updateObject."$property" = $value
                        $shouldUpdate = $true
                    }

                    # Compare and change properties
                    if ($updateObject."$property" -ne $value) {
                        $updateObject."$property" = $value
                        $shouldUpdate = $true
                    }
                }

                if ($shouldUpdate) {
                    $updateObject | Set-AMObject
                } else {
                    Write-Verbose "$($obj.Type) '$($obj.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}
