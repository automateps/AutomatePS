---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Disable-AMObject

## SYNOPSIS
Disables an AutoMate Enterprise object.

## SYNTAX

```
Disable-AMObject [-InputObject] <Object> [<CommonParameters>]
```

## DESCRIPTION
Disable-AMObject receives AutoMate Enterprise object(s) on the pipeline, or via the parameter $InputObject, and disables the object(s).

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following objects can be disabled by this function:
Workflow
Task
Condition
Process
TaskAgent
ProcessAgent
AgentGroup
User
UserGroup

## OUTPUTS

### None

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

