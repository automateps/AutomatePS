---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Get-AMWorkflowVariable

## SYNOPSIS
Gets a list of variables within a workflow.

## SYNTAX

```
Get-AMWorkflowVariable [[-InputObject] <Object>] [[-Name] <String>] [[-InitialValue] <String>]
 [[-DataType] <AMWorkflowVarDataType>] [[-VariableType] <AMWorkflowVarType>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMWorkflowVariable retrieves variables for a workflow.

## EXAMPLES

### EXAMPLE 1
```
# Get variables in workflow "FTP Files"
```

Get-AMWorkflow "FTP Files" | Get-AMWorkflowVariable

## PARAMETERS

### -InputObject
The object to retrieve variables from.

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

### -Name
Search on the name of the variable.
Wildcards are accepted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -InitialValue
Search on the initial value of the variable.
Wildcards are accepted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataType
Filter on the data type of the variable.

```yaml
Type: AMWorkflowVarDataType
Parameter Sets: (All)
Aliases:
Accepted values: Variable, Array, Dataset

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VariableType
Filter on the type of variable.

```yaml
Type: AMWorkflowVarType
Parameter Sets: (All)
Aliases:
Accepted values: Auto, Text, Number

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following AutoMate object types can be queried by this function:
### Workflow
## OUTPUTS

### WorkflowVariable
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

