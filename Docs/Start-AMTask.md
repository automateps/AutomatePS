---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Start-AMTask.md
schema: 2.0.0
---

# Start-AMTask

## SYNOPSIS
Starts Automate tasks.

## SYNTAX

### Agent
```
Start-AMTask -InputObject <Object> [-Agent <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### AgentGroup
```
Start-AMTask -InputObject <Object> [-AgentGroup <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Start-AMTask starts tasks.

## EXAMPLES

### EXAMPLE 1
```
# Starts task "My Task" on agent "agent01"
Get-AMTask "My Task" | Start-AMTask -Agent "agent01"
```

## PARAMETERS

### -InputObject
The tasks to start.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Agent
The agent to run the task on.

```yaml
Type: Object
Parameter Sets: Agent
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AgentGroup
The agent group to run the task on.

```yaml
Type: Object
Parameter Sets: AgentGroup
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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

### Tasks can be supplied on the pipeline to this function.
## OUTPUTS

### AMInstancev10
### AMInstancev11
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Start-AMTask.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Start-AMTask.md)

