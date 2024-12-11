---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMWorkflow.md
schema: 2.0.0
---

# Set-AMWorkflow

## SYNOPSIS
Sets properties of an Automate workflow.

## SYNTAX

### ByInputObject
```
Set-AMWorkflow -InputObject <Object> [-Notes <String>] [-CompletionState <AMCompletionState>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByInstance
```
Set-AMWorkflow -Instance <Object> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Set-AMWorkflow can change properties of a workflow object.

## EXAMPLES

### EXAMPLE 1
```
# Change notes for a workflow
Get-AMWorkflow "Some Workflow" | Set-AMWorkflow -Notes "Does something important"
```

### EXAMPLE 2
```
# Modify a workflow
Set-AMWorkflow -Instance $modifiedWorkflow
```

## PARAMETERS

### -InputObject
The object to modify.

```yaml
Type: Object
Parameter Sets: ByInputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Instance
The object to save. 
Use this parameter if the object was modified directly, and not by another function in this module.

```yaml
Type: Object
Parameter Sets: ByInstance
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
The new notes to set on the object.

```yaml
Type: String
Parameter Sets: ByInputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompletionState
The completion state (staging level) to set on the object.

```yaml
Type: AMCompletionState
Parameter Sets: ByInputObject
Aliases:
Accepted values: InDevelopment, Testing, Production, Archive

Required: False
Position: Named
Default value: None
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

### The following Automate object types can be modified by this function:
### Workflow
## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMWorkflow.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMWorkflow.md)

