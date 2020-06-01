---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Set-AMScheduleCondition

## SYNOPSIS
Sets properties of an Automate schedule condition.

## SYNTAX

```
Set-AMScheduleCondition [-InputObject] <Object> [[-ScheduleType] <AMScheduleType>]
 [[-NextLaunchDate] <DateTime>] [[-Frequency] <Object>] [[-Day] <DayOfWeek[]>] [[-End] <DateTime>]
 [[-Measure] <AMScheduleMeasure>] [[-Month] <String[]>] [[-MonthInterval] <Int32>]
 [[-OnTaskLate] <AMOnTaskLateRescheduleOption>] [[-Reschedule] <AMRescheduleOption>] [[-Notes] <String>]
 [[-CompletionState] <AMCompletionState>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets-AMScheduleCondition modifies an existing schedule condition.

## EXAMPLES

### EXAMPLE 1
```
# Set schedule "Daily at 8PM" to disable the trigger when late
Get-AMCondition "Daily at 8PM" | Set-AMScheduleCondition -ScheduleType Day -OnTaskLate DisableTrigger
```

## PARAMETERS

### -InputObject
The condition to modify.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ScheduleType
Set the schedule to use a Custom interval.

```yaml
Type: AMScheduleType
Parameter Sets: (All)
Aliases:
Accepted values: Custom, SecondInterval, MinuteInterval, HourInterval, DayInterval, WeekInterval, MonthInterval, Holidays

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NextLaunchDate
The next time the schedule will execute

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Frequency
How frequently the schedule should execute the specified interval.
For example: every 1 day, every 2 days, etc.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Day
The day(s) of the week to execute the schedule on.

```yaml
Type: DayOfWeek[]
Parameter Sets: (All)
Aliases:
Accepted values: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
The last date the schedule will execute.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Measure
When using the -MonthInterval option, use this parameter to specify regular days, work days, or a specific weekday (i.e.
Monday, Tuesday, etc.).

```yaml
Type: AMScheduleMeasure
Parameter Sets: (All)
Aliases:
Accepted values: Day, WorkDay, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Month
The month(s) to execute.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MonthInterval
The frequency to execute when using a "Specific day(s) of the month" schedule type.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnTaskLate
The action to take when the task is late.

```yaml
Type: AMOnTaskLateRescheduleOption
Parameter Sets: (All)
Aliases:
Accepted values: RunImmediately, IgnoreAndReschedule, DisableTrigger

Required: False
Position: 10
Default value: RunImmediately
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reschedule
Specify how the schedule should be rescheduled.

```yaml
Type: AMRescheduleOption
Parameter Sets: (All)
Aliases:
Accepted values: RelativeToOriginalTime, RelativeToTriggeredTime, DisableTrigger

Required: False
Position: 11
Default value: RelativeToOriginalTime
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
The new notes to set on the object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompletionState
The completion state (staging level) to set on the object.

```yaml
Type: AMCompletionState
Parameter Sets: (All)
Aliases:
Accepted values: InDevelopment, Testing, Production, Archive

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

