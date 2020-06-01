---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Add-AMScheduleConditionHoliday

## SYNOPSIS
Adds a holiday to an Automate schedule condition using the Holidays interval.

## SYNTAX

```
Add-AMScheduleConditionHoliday -InputObject <Object> [-Holiday] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Add-AMScheduleConditionHoliday adds a holiday to an Automate schedule condition using the Holidays interval.

## EXAMPLES

### EXAMPLE 1
```
# Add a holiday category to schedule "On Specified Dates"
Get-AMCondition "On Specified Dates" | Add-AMScheduleConditionHoliday -Holiday "United States"
```

## PARAMETERS

### -InputObject
The schedule condition object to add the holiday to.

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

### -Holiday
The holiday categories to add to the schedule.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
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

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

