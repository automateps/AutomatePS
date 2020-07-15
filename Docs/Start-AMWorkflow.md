---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Start-AMWorkflow.md
schema: 2.0.0
---

# Start-AMWorkflow

## SYNOPSIS
Starts Automate workflows.

## SYNTAX

```
Start-AMWorkflow [-InputObject] <Object> [[-Parameters] <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Start-AMWorkflow starts workflows.

## EXAMPLES

### EXAMPLE 1
```
# Starts workflow "My Workflow"
Get-AMWorkflow "My Workflow" | Start-AMWorkflow
```

### EXAMPLE 2
```
# Starts workflow "My Workflow" with parameters
$parameters = @{ varName = "test" }
Get-AMWorkflow "My Workflow" | Start-AMWorkflow -Parameters $parameters
```

## PARAMETERS

### -InputObject
The workflows to start.

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

### -Parameters
A hashtable containing shared variable name/value pairs to update the workflow with prior to execution.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

### Workflows can be supplied on the pipeline to this function.
## OUTPUTS

### AMInstancev10
### AMInstancev11
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Start-AMWorkflow.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Start-AMWorkflow.md)

