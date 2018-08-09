---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Resume-AMWorkflow

## SYNOPSIS
Resumes a failed AutoMate Enterprise workflow.

## SYNTAX

### All (Default)
```
Resume-AMWorkflow [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByPipeline
```
Resume-AMWorkflow [-InputObject <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Resume-AMWorkflow resumse paused workflow and task instances.

## EXAMPLES

### EXAMPLE 1
```
# Resumes a workflow
```

Get-AMWorkflow "Failed workflow" | Resume-AMWorkflow

## PARAMETERS

### -InputObject
The workflow(s) to resumse.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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

