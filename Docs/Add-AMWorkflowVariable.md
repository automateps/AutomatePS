---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMWorkflowVariable.md
schema: 2.0.0
---

# Add-AMWorkflowVariable

## SYNOPSIS
Adds a shared variable to an Automate workflow

## SYNTAX

```
Add-AMWorkflowVariable [-InputObject] <Object> [-Name] <String> [[-InitialValue] <Object>]
 [[-Description] <String>] [[-VariableType] <AMWorkflowVarDataType>] [[-DataType] <AMWorkflowVarType>]
 [-PassValueFromParent] [-PassValueToParent] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Add-AMWorkflowVariable can add shared variables to a workflow object.

## EXAMPLES

### EXAMPLE 1
```
# Add variable 'emailAddress' to workflow 'Some Workflow'
Get-AMWorkflow "Some Workflow" | Add-AMWorkflowVariable -Name "emailAddress" -InitialValue "person@example.com" -Description "Email this user when the job fails"
```

## PARAMETERS

### -InputObject
The object to add the variable to.

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

### -Name
The name of the variable.

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

### -InitialValue
The initial value of the variable.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VariableType
The type of variable: Auto, Number or Text.

```yaml
Type: AMWorkflowVarDataType
Parameter Sets: (All)
Aliases:
Accepted values: Variable, Array, Dataset

Required: False
Position: 5
Default value: Variable
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataType
The data type of the variable.

```yaml
Type: AMWorkflowVarType
Parameter Sets: (All)
Aliases:
Accepted values: Auto, Text, Number

Required: False
Position: 6
Default value: Auto
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

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMWorkflowVariable.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMWorkflowVariable.md)

