---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Resume-AMInstance

## SYNOPSIS
Resumes AutoMate Enterprise workflow and task instances.

## SYNTAX

### All (Default)
```
Resume-AMInstance [<CommonParameters>]
```

### ByPipeline
```
Resume-AMInstance [-InputObject <Object>] [<CommonParameters>]
```

## DESCRIPTION
Resume-AMInstance resumes paused workflow and task instances.

## EXAMPLES

### EXAMPLE 1
```
# Resumes all currently paused instances
```

Get-AMInstance -Status Paused | Resume-AMInstance

### EXAMPLE 2
```
# Resumes all currently paused instances of workflow "My Workflow"
```

Get-AMWorkflow "My Workflow" | Get-AMInstance -Status Paused | Resume-AMInstance

## PARAMETERS

### -InputObject
The instances to resumes.

```yaml
Type: Object
Parameter Sets: ByPipeline
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Instances can be supplied on the pipeline to this function.

## OUTPUTS

### Instance

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

