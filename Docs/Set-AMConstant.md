---
external help file: AutomatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Set-AMConstant

## SYNOPSIS
Sets constants on an AutoMate Enterprise agent property.

## SYNTAX

```
Set-AMConstant -InputObject <Object> [-Name] <String> [-Value] <String> [-Comment <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Set-AMConstant sets constants for an agent.

## EXAMPLES

### EXAMPLE 1
```
Get-AMAgent "agent01" | Get-AMObjectProperty | Set-AMConstant -Name test -Value 123 -Comment "Test modifying a constant"
```

## PARAMETERS

### -InputObject
The agent property to modify.

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

### -Name
The name of the constant to modify.

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

### -Value
The value to set for the constant.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
The comment to set for the constant.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following AutoMate object types can be modified by this function:
### AgentProperty
## OUTPUTS

### None
## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 02/06/2019
Date Modified  : 02/06/2019

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)
