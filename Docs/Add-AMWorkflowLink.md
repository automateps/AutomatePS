---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Add-AMWorkflowLink

## SYNOPSIS
Adds a link between two objects in an AutoMate Enterprise workflow

## SYNTAX

```
Add-AMWorkflowLink [-InputObject] <Object> [-SourceItem] <Object> [-DestinationItem] <Object>
 [[-Type] <AMLinkType>] [[-ResultType] <AMLinkResultType>] [[-Value] <Object>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Add-AMWorkflowLink can add a link between two objects in an AutoMate Enterprise workflow

## EXAMPLES

### EXAMPLE 1
```
# Add a link between "Copy Files" and "Move Files"
```

Get-AMWorkflow "FTP Files" | Add-AMWorkflowLink -SourceItem (Get-AMTask "Copy Files") -DestinationItem (Get-AMTask "Move Files")

## PARAMETERS

### -InputObject
The workflow to add the link to.

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

### -SourceItem
The source object for the link. 
Object can only exist once in the workflow.

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

### -DestinationItem
The destination object for the link. 
Object can only exist once in the workflow.

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

### -Type
The type of link to add.

```yaml
Type: AMLinkType
Parameter Sets: (All)
Aliases:
Accepted values: Blank, Success, Failure, Result

Required: False
Position: 4
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
Position: 5
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
Position: 6
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

### None
## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

