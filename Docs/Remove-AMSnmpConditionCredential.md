---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Remove-AMSnmpConditionCredential

## SYNOPSIS
Removes a credential from an AutoMate Enterprise SNMP condition.

## SYNTAX

```
Remove-AMSnmpConditionCredential [-InputObject] <Object> [-ID] <Object> [<CommonParameters>]
```

## DESCRIPTION
Remove-AMSnmpConditionCredential removes a credential from an AutoMate Enterprise SNMP condition.

## EXAMPLES

### EXAMPLE 1
```
Get-AMCondition "snmp" | Remove-AMSnmpConditionCredential -ID "{5ccaab49-012a-48db-b186-696061e20a2c}"
```

## PARAMETERS

### -InputObject
The SNMP condition object to remove the credential from.

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

