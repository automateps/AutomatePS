---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Remove-AMWorkflowItem

## SYNOPSIS
Removes an item from an Automate workflow

## SYNTAX

```
Remove-AMWorkflowItem -InputObject <Object> [[-ID] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove-AMWorkflowItem can remove items from a workflow object.

## EXAMPLES

### EXAMPLE 1
```
# Remove all triggers from workflow "Some Workflow"
(Get-AMWorkflow "Some Workflow").Triggers | Remove-AMWorkflowItem
```

## PARAMETERS

### -InputObject
The item object to remove.

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

### -ID
The ID of the item to remove (if passing in a workflow).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following Automate object types can be modified by this function:
### Workflow
### WorkflowItem
### WorkflowTrigger
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

