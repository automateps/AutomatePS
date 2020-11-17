---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Import-AMHoliday.md
schema: 2.0.0
---

# Import-AMHoliday

## SYNOPSIS
Read the holidays.aho file into a dictionary.

## SYNTAX

```
Import-AMHoliday [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
This function reads in the holidays.aho file and returns a dictionary object.

## EXAMPLES

### EXAMPLE 1
```
Import-AMHoliday -Path "C:\ProgramData\AutoMate\Automate Enterprise 11\Holidays.aho"
```

## PARAMETERS

### -Path
Path to holidays.aho file

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Import-AMHoliday.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Import-AMHoliday.md)

