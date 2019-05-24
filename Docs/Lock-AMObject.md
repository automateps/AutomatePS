---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Lock-AMObject

## SYNOPSIS
Locks an AutoMate Enterprise object.

## SYNTAX

```
Lock-AMObject [-InputObject] <Object> [<CommonParameters>]
```

## DESCRIPTION
Lock-AMObject receives AutoMate Enterprise object(s) on the pipeline, or via the parameter $InputObject, and locks the object(s).

## EXAMPLES

### EXAMPLE 1
```
Get-AMWorkflow "My Workflow" | Lock-AMObject
```

## PARAMETERS

### -InputObject
The object(s) to be locked.

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

### The following objects can be locked by this function:
### Workflow
### Task
### Process
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

