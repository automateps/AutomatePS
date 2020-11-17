---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Disable-AMObject.md
schema: 2.0.0
---

# Disable-AMObject

## SYNOPSIS
Disables an Automate object.

## SYNTAX

```
Disable-AMObject [-InputObject] <Object> [<CommonParameters>]
```

## DESCRIPTION
Disable-AMObject receives Automate object(s) on the pipeline, or via the parameter $InputObject, and disables the object(s).

## EXAMPLES

### EXAMPLE 1
```
Get-AMWorkflow "My Workflow" | Disable-AMObject
```

## PARAMETERS

### -InputObject
The object(s) to be disabled.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following objects can be disabled by this function:
### Workflow
### Task
### Condition
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

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Disable-AMObject.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Disable-AMObject.md)

