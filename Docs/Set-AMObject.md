---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMObject.md
schema: 2.0.0
---

# Set-AMObject

## SYNOPSIS
Modifies an Automate object.

## SYNTAX

```
Set-AMObject [-InputObject] <Object> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Set-AMObject receives modified Automate object(s) on the pipeline, or via the parameter $InputObject, and applies the modifications.

## EXAMPLES

### EXAMPLE 1
```
$obj = Get-AMWorkflow "My Workflow"
$obj.Notes = "New Notes"
$obj | Set-AMObject
```

## PARAMETERS

### -InputObject
The object(s) to be modified.

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following objects can be modified by this function:
### Workflow
### Task
### Process
### TaskAgent
### ProcessAgent
### AgentGroup
### User
### UserGroup
## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMObject.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMObject.md)

