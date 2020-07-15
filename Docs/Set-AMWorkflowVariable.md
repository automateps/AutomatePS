---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMWorkflowVariable.md
schema: 2.0.0
---

# Set-AMWorkflowVariable

## SYNOPSIS
Sets a shared variable in a Automate workflow

## SYNTAX

```
Set-AMWorkflowVariable -InputObject <Object> [[-Name] <String>] [-InitialValue <String>]
 [-Description <String>] [-Type <AMWorkflowVarType>] [-PassValueFromParent] [-PassValueToParent] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set-AMWorkflowVariable can set the initial value and description of shared variables in a workflow object.

## EXAMPLES

### EXAMPLE 1
```
# Modify variable 'emailAddress' for workflow 'Some Workflow'
Get-AMWorkflow "Some Workflow" | Set-AMWorkflowVariable -Name "emailAddress" -InitialValue "person@example.com" -PassValueFromParent -PassValueToParent:$false
```

## PARAMETERS

### -InputObject
The object to modify.

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
The name of the variable to modify.

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

### -InitialValue
The initial value of the variable.

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

### -Description
The description of the variable.

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

### -Type
The data type of the variable.

```yaml
Type: AMWorkflowVarType
Parameter Sets: (All)
Aliases:
Accepted values: Auto, Text, Number

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassValueFromParent
If specified, the variable will be configured to pass the value from the parent workflow to this workflow.

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

### -PassValueToParent
If specified, the variable will be configured to pass the value from this workflow to the parent workflow.

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

### The following Automate object types can be modified by this function:
### Workflow
### WorkflowVariable
## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMWorkflowVariable.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMWorkflowVariable.md)

