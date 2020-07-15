---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMSnmpConditionCredential.md
schema: 2.0.0
---

# Add-AMSnmpConditionCredential

## SYNOPSIS
Adds a credential to an Automate SNMP condition.

## SYNTAX

```
Add-AMSnmpConditionCredential [-InputObject] <Object> [[-User] <Object>]
 [[-EncryptionAlgorithm] <AMEncryptionAlgorithm>] [<CommonParameters>]
```

## DESCRIPTION
Add-AMSnmpConditionCredential adds a credential to an Automate SNMP condition.

## EXAMPLES

### EXAMPLE 1
```
Get-AMCondition "snmp" | Add-AMSnmpConditionCredential -User john
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

### -User
The username used to accept authenticated traps.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptionAlgorithm
The type encryption to use.

```yaml
Type: AMEncryptionAlgorithm
Parameter Sets: (All)
Aliases:
Accepted values: NoEncryption, DES, AES, TripleDES

Required: False
Position: 3
Default value: NoEncryption
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

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMSnmpConditionCredential.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMSnmpConditionCredential.md)

