---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMWorkflowItem.md
schema: 2.0.0
---

# Get-AMWorkflowItem

## SYNOPSIS
Gets a list of items within a workflow.

## SYNTAX

```
Get-AMWorkflowItem [-InputObject] <Object> [[-LinkType] <AMLinkType>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMWorkflowItem retrieves links for a workflow.

## EXAMPLES

### EXAMPLE 1
```
# Get links in workflow "FTP Files"
Get-AMWorkflow "FTP Files" | Get-AMWorkflowLink
```

## PARAMETERS

### -InputObject
The object to retrieve links from.

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

### -LinkType
Only retrieve variables of a specific link type.

```yaml
Type: AMLinkType
Parameter Sets: (All)
Aliases:
Accepted values: Blank, Success, Failure, Result

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following Automate object types can be queried by this function:
### Workflow
## OUTPUTS

### AMWorkflowItemv10
### AMWorkflowItemv11
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMWorkflowItem.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMWorkflowItem.md)

