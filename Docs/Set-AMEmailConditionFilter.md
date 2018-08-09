---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Set-AMEmailConditionFilter

## SYNOPSIS
Modifies an AutoMate Enterprise Email condition filter.

## SYNTAX

```
Set-AMEmailConditionFilter [-InputObject] <Object> [-ID] <Object> [<CommonParameters>]
```

## DESCRIPTION
Set-AMEmailConditionFilter modifies a filter in an AutoMate Enterprise Email condition.

## EXAMPLES

### EXAMPLE 1
```
Get-AMCondition "window" | Set-AMSnmpConditionCredential -ID "{0cee39da-1f6c-424b-a9bd-eeaf17cbd1f2}" -User david
```

## PARAMETERS

### -InputObject
The SNMP condition object to add the credential to.

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

### -ID
The ID of the credential.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

