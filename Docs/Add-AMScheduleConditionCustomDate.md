---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMScheduleConditionCustomDate.md
schema: 2.0.0
---

# Add-AMScheduleConditionCustomDate

## SYNOPSIS
Adds a custom date to an Automate schedule condition using the Custom interval.

## SYNTAX

```
Add-AMScheduleConditionCustomDate -InputObject <Object> [-CustomLaunchDates] <DateTime[]>
 [-RemovePreviousDates] [<CommonParameters>]
```

## DESCRIPTION
Add-AMScheduleConditionCustomDate adds a custom date to an Automate schedule condition using the Custom interval.

## EXAMPLES

### EXAMPLE 1
```
# Add a custom run time of 1 hour from now to schedule "On Specified Dates"
Get-AMCondition "On Specified Dates" | Add-AMScheduleConditionCustomDate -CustomLaunchDates (Get-Date).AddHours(1)
```

## PARAMETERS

### -InputObject
The schedule condition object to add the custom date to.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -CustomLaunchDates
The future launch date(s) to add to the schedule.

```yaml
Type: DateTime[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemovePreviousDates
If specified, past dates are removed from the schedule.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following Automate object types can be modified by this function:
### Condition
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMScheduleConditionCustomDate.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMScheduleConditionCustomDate.md)

