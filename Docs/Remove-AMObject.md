---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Remove-AMObject

## SYNOPSIS
Removes an AutoMate Enterprise object.

## SYNTAX

```
Remove-AMObject [[-InputObject] <Object>] [-SkipUsageCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove-AMObject receives AutoMate Enterprise object(s) on the pipeline, or via the parameter $InputObject, and deletes the object(s).

## EXAMPLES

### EXAMPLE 1
```
# Deletes agent "agent01"
```

Get-AMAgent "agent01" | Remove-AMObject

## PARAMETERS

### -InputObject
The object(s) to be deleted.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SkipUsageCheck
Skips checking if object is in use.

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

### The following objects can be disabled by this function:
### Workflow
### Task
### Condition
### Process
### TaskAgent
### ProcessAgent
### AgentGroup
### User
### UserGroup
## OUTPUTS

### None
## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 11/15/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

