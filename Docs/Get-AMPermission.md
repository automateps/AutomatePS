---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMPermission.md
schema: 2.0.0
---

# Get-AMPermission

## SYNOPSIS
Gets Automate permissions.

## SYNTAX

```
Get-AMPermission [[-InputObject] <Object>] [-ID <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMPermission gets permissions for objects.

## EXAMPLES

### EXAMPLE 1
```
# Get permissions for workflow "My Workflow"
Get-AMWorkflow "My Workflow" | Get-AMPermission
```

## PARAMETERS

### -InputObject
The object(s) to retrieve permissions for.

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

### -ID
The ID of the permission to retrieve.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Permissions for the following objects can be retrieved by this function:
### Workflow
### Task
### Condition
### Process
### Agent
### AgentGroup
### User
### UserGroup
### Folder
## OUTPUTS

### Permission
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMPermission.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMPermission.md)

