---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Switch-AMWorkflowItem

## SYNOPSIS
Replaces items in a AutoMate Enterprise workflow

## SYNTAX

```
Switch-AMWorkflowItem [-InputObject] <Object> [-CurrentItem] <Object> [-NewItem] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Switch-AMWorkflowItem can replace items in a workflow object.

## EXAMPLES

### EXAMPLE 1
```
# Replace instances of the "Copy Files" task with "Move Files" in workflow "FTP Files"
```

Get-AMWorkflow "FTP Files" | Switch-AMWorkflowItem -CurrentItem (Get-AMTask "Copy Files") -NewItem (Get-AMTask "Move Files")

## PARAMETERS

### -InputObject
The object to replace items in.

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

### -CurrentItem
The current item to replace.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewItem
The new item to replace the current item with.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following AutoMate object types can be modified by this function:
### Workflow
## OUTPUTS

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 11/15/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

