---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Set-AMWorkflowLink

## SYNOPSIS
Sets a link in a Automate workflow

## SYNTAX

```
Set-AMWorkflowLink -InputObject <Object> [[-ID] <String>] [-LinkType <AMLinkType>]
 [-ResultType <AMLinkResultType>] [-Value <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set-AMWorkflowLink can modify a link in a workflow object.

## EXAMPLES

### EXAMPLE 1
```
# Change the label on an item in a workflow
Get-AMWorkflow "Some Workflow" | Set-AMWorkflowLink -ID "{1103992f-cbbd-44fd-9177-9de31b1070ab}" -Value "123"
```

## PARAMETERS

### -InputObject
The object to modify - a workflow or a workflow link.

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
The ID of the link to modify (if passing in a workflow).

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

### -LinkType
The type of link to add.

```yaml
Type: AMLinkType
Parameter Sets: (All)
Aliases:
Accepted values: Blank, Success, Failure, Result

Required: False
Position: Named
Default value: Success
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResultType
If a Result link type is used, the type of result (true/false/default/value).

```yaml
Type: AMLinkResultType
Parameter Sets: (All)
Aliases:
Accepted values: Default, True, False, Value

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
If a Value result type is used, the value to set.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following Automate object types can be modified by this function:
### Workflow
### WorkflowLink
## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

