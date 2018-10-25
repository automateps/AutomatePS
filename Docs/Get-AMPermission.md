---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Get-AMPermission

## SYNOPSIS
Gets AutoMate Enterprise permissions.

## SYNTAX

### All (Default)
```
Get-AMPermission [<CommonParameters>]
```

### ByPipeline
```
Get-AMPermission [[-InputObject] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMPermission gets permissions for objects.

## EXAMPLES

### EXAMPLE 1
```
# Get permissions for workflow "My Workflow"
```

Get-AMWorkflow "My Workflow" | Get-AMPermission

## PARAMETERS

### -InputObject
The object(s) to retrieve permissions for.

```yaml
Type: Object
Parameter Sets: ByPipeline
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

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
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

