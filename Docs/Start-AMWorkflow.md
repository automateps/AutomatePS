---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Start-AMWorkflow

## SYNOPSIS
Starts AutoMate Enterprise workflows.

## SYNTAX

```
Start-AMWorkflow [-InputObject] <Object> [<CommonParameters>]
```

## DESCRIPTION
Start-AMWorkflow starts workflows.

## EXAMPLES

### EXAMPLE 1
```
# Starts workflow "My Workflow"
```

Get-AMWorkflow "My Workflow" | Start-AMWorkflow

## PARAMETERS

### -InputObject
The workflows to start.

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

### Workflows can be supplied on the pipeline to this function.

## OUTPUTS

### System.Object[]

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

