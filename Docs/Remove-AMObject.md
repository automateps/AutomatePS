---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMObject.md
schema: 2.0.0
---

# Remove-AMObject

## SYNOPSIS
Removes an Automate object.

## SYNTAX

```
Remove-AMObject [[-InputObject] <Object>] [-SkipUsageCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove-AMObject receives Automate object(s) on the pipeline, or via the parameter $InputObject, and deletes the object(s).

## EXAMPLES

### EXAMPLE 1
```
# Deletes agent "agent01"
Get-AMAgent "agent01" | Remove-AMObject
```

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following objects can be removed by this function:
### Folder
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

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMObject.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMObject.md)

