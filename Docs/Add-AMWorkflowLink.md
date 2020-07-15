---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMWorkflowLink.md
schema: 2.0.0
---

# Add-AMWorkflowLink

## SYNOPSIS
Adds a link between two objects in an Automate workflow

## SYNTAX

### ByConstruct
```
Add-AMWorkflowLink -InputObject <Object> -SourceConstruct <Object> -DestinationConstruct <Object>
 [-LinkType <AMLinkType>] [-ResultType <AMLinkResultType>] [-Value <Object>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByItem
```
Add-AMWorkflowLink -InputObject <Object> -SourceItemID <Object> -DestinationItemID <Object>
 [-LinkType <AMLinkType>] [-ResultType <AMLinkResultType>] [-Value <Object>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Add-AMWorkflowLink can add a link between two objects in an Automate workflow

## EXAMPLES

### EXAMPLE 1
```
# Add a link between "Copy Files" and "Move Files"
Get-AMWorkflow "FTP Files" | Add-AMWorkflowLink -SourceConstruct (Get-AMTask "Copy Files") -DestinationConstruct (Get-AMTask "Move Files")
```

## PARAMETERS

### -InputObject
The workflow to add the link to.

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

### -SourceConstruct
The source repository object for the link. 
Object can only exist once in the workflow.

```yaml
Type: Object
Parameter Sets: ByConstruct
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationConstruct
The destination repository object for the link. 
Object can only exist once in the workflow.

```yaml
Type: Object
Parameter Sets: ByConstruct
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceItemID
The source workflow item or trigger ID for the link.

```yaml
Type: Object
Parameter Sets: ByItem
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationItemID
The destination workflow item or trigger ID for the link.

```yaml
Type: Object
Parameter Sets: ByItem
Aliases:

Required: True
Position: Named
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
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMWorkflowLink.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMWorkflowLink.md)

