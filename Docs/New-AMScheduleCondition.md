---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# New-AMScheduleCondition

## SYNOPSIS
Creates a new AutoMate Enterprise schedule condition.

## SYNTAX

```
New-AMScheduleCondition [-Name] <String> [-ScheduleType <AMScheduleType>] [-NextLaunchDate <DateTime>]
 [-Frequency <Object>] [-Day <DayOfWeek[]>] [-End <DateTime>] [-Measure <AMScheduleMeasure>]
 [-Month <String[]>] [-MonthInterval <Int32>] [-OnTaskLate <AMOnTaskLateRescheduleOption>]
 [-Reschedule <AMRescheduleOption>] [-Notes <String>] [-Folder <Object>] [-Connection <Object>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
New-AMScheduleCondition creates a new schedule condition.

## EXAMPLES

### EXAMPLE 1
```
# Create a new schedule to run every day at 8AM
```

New-AMScheduleCondition -Name "Daily at 8AM" -DayInterval -NextLaunchDate (Get-Date "8:00AM")

### EXAMPLE 2
```
# Create a new schedule to run every other month on the third Wednesday at 9PM
```

New-AMScheduleCondition -Name "Third Wednesday" -MonthInterval -Measure Wednesday -DayOfMonth third -Frequency 2 -NextLaunchDate (Get-Date "9:00PM")

## PARAMETERS

### -Name
The name of the new object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
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
Position: Named
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
Position: Named
Default value: (Get-Date)
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
Position: Named
Default value: 1
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
Position: Named
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
Position: Named
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
Position: Named
Default value: Day
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Folder
The folder to place the object in.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
The server to create the object on.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 12/03/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

