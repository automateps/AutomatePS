---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Unlock-AMObject.md
schema: 2.0.0
---

# Unlock-AMObject

## SYNOPSIS
Unlocks an Automate object.

## SYNTAX

```
Unlock-AMObject [-InputObject] <Object> [<CommonParameters>]
```

## DESCRIPTION
Unlock-AMObject receives Automate object(s) on the pipeline, or via the parameter $InputObject, and unlocks the object(s).

## EXAMPLES

### EXAMPLE 1
```
Get-AMWorkflow "My Workflow" | Unlock-AMObject
```

## PARAMETERS

### -InputObject
The object(s) to be unlocked.

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

### The following objects can be unlocked by this function:
### Workflow
### Task
### Process
## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Unlock-AMObject.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Unlock-AMObject.md)

