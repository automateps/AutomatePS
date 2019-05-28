---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Stop-AMInstance

## SYNOPSIS
Stops AutoMate Enterprise workflow and task instances.

## SYNTAX

### All (Default)
```
Stop-AMInstance [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByPipeline
```
Stop-AMInstance [-InputObject <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Stop-AMInstance stops running workflow and task instances.

## EXAMPLES

### EXAMPLE 1
```
# Stops all currently running instances
```

Get-AMInstance -Status Running | Stop-AMInstance

## PARAMETERS

### -InputObject
The instances to stop.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Instances can be supplied on the pipeline to this function.
## OUTPUTS

### System.Object[]
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

