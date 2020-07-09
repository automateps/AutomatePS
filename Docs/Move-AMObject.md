---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Move-AMObject

## SYNOPSIS
Moves an Automate object.

## SYNTAX

```
Move-AMObject -InputObject <Object> [-Folder] <Object> [<CommonParameters>]
```

## DESCRIPTION
Move-AMObject receives Automate object(s) on the pipeline, or via the parameter $InputObject, and moves the object(s) to the specified folder.

## EXAMPLES

### EXAMPLE 1
```
Get-AMWorkflow "My Workflow" | Move-AMObject -Folder (Get-AMFolder -Path \WORKFLOWS)
```

## PARAMETERS

### -InputObject
The object(s) to be moved.

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

### -Folder
The folder to move the object to.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following objects can be moved by this function:
### Folder
### Workflow
### Task
### Process
### TaskAgent
### ProcessAgent
### AgentGroup
### User
### UserGroup
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

