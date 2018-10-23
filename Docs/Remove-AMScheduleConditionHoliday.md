---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Remove-AMScheduleConditionHoliday

## SYNOPSIS
Removes a holiday from an AutoMate Enterprise schedule condition using the Holidays interval.

## SYNTAX

```
Remove-AMScheduleConditionHoliday -InputObject <Object> [-Holiday] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Remove-AMScheduleConditionHoliday removes a holiday from an AutoMate Enterprise schedule condition using the Holidays interval.

## EXAMPLES

### EXAMPLE 1
```
# Add a holiday category to schedule "On Specified Dates"
```

Get-AMCondition "On Specified Dates" | Remove-AMScheduleConditionHoliday -Holiday "United States"

## PARAMETERS

### -InputObject
The schedule condition object to remove the holiday from.

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
The holiday categories to remove from the schedule.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following AutoMate object types can be modified by this function:
### Condition
## OUTPUTS

### None
## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

