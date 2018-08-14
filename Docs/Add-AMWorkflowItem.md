---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Add-AMWorkflowItem

## SYNOPSIS
Adds an item to an AutoMate Enterprise workflow

## SYNTAX

### ByConstruct
```
Add-AMWorkflowItem -InputObject <Object> -Item <Object> [-Agent <Object>] [-X <Int32>] [-Y <Int32>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### ByEvaluation
```
Add-AMWorkflowItem -InputObject <Object> -Expression <String> [-X <Int32>] [-Y <Int32>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByWait
```
Add-AMWorkflowItem -InputObject <Object> [-Wait] [-X <Int32>] [-Y <Int32>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Add-AMWorkflowItem can add an item to an AutoMate Enterprise workflow

## EXAMPLES

### EXAMPLE 1
```
# Add a link between "Copy Files" and "Move Files"
```

Get-AMWorkflow "FTP Files" | Add-AMWorkflowItem -Item (Get-AMTask "Copy Files")

## PARAMETERS

### -InputObject
The workflow to add the item to.

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

### -Item
The item to add to the workflow.

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

### -Agent
The agent to assign the item to in the workflow.

```yaml
Type: Object
Parameter Sets: ByConstruct
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Expression
The expression to set on the evaluation object.

```yaml
Type: String
Parameter Sets: ByEvaluation
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
Adds a wait object.

```yaml
Type: SwitchParameter
Parameter Sets: ByWait
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -X
The X (horizontal) location of the new item.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Y
The Y (vertical) location of the new item.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following AutoMate object types can be modified by this function:
Workflow

## OUTPUTS

### None

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

