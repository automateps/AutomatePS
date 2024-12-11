---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Rename-AMObject.md
schema: 2.0.0
---

# Rename-AMObject

## SYNOPSIS
Renames an Automate object.

## SYNTAX

```
Rename-AMObject -InputObject <Object> [-Name] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Rename-AMObject receives Automate object(s) on the pipeline, or via the parameter $InputObject, and renames the object(s).

## EXAMPLES

### EXAMPLE 1
```
Get-AMWorkflow "My Workflow" | Rename-AMObject "My Renamed Workflow"
```

## PARAMETERS

### -InputObject
The object(s) to be locked.

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
The new name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

### The following objects can be renamed by this function:
### Folder
### Workflow
### WorkflowVariable
### Task
### Process
### AgentGroup
### UserGroup
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Rename-AMObject.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Rename-AMObject.md)

