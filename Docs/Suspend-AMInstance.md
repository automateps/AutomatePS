---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Suspend-AMInstance.md
schema: 2.0.0
---

# Suspend-AMInstance

## SYNOPSIS
Pauses Automate workflow and task instances.

## SYNTAX

### All (Default)
```
Suspend-AMInstance [<CommonParameters>]
```

### ByPipeline
```
Suspend-AMInstance [-InputObject <Object>] [<CommonParameters>]
```

## DESCRIPTION
Suspend-AMInstance suspends running workflow and task instances.

## EXAMPLES

### EXAMPLE 1
```
# Suspend all currently running instances
Get-AMInstance -Status Running | Suspend-AMInstance
```

## PARAMETERS

### -InputObject
The instances to suspend.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Instances can be supplied on the pipeline to this function.
## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Suspend-AMInstance.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Suspend-AMInstance.md)

