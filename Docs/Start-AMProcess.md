---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Start-AMProcess.md
schema: 2.0.0
---

# Start-AMProcess

## SYNOPSIS
Starts Automate processes.

## SYNTAX

### Agent
```
Start-AMProcess -InputObject <Object> [-Agent <Object>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### AgentGroup
```
Start-AMProcess -InputObject <Object> [-AgentGroup <Object>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Start-AMProcess starts processes.

## EXAMPLES

### EXAMPLE 1
```
# Starts process "My Process" on agent "agent01"
Get-AMProcess "My Process" | Start-AMProcess -Agent "agent01"
```

## PARAMETERS

### -InputObject
The processes to start.

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
The agent to run the process on.

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
The agent group to run the process on.

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Processes can be supplied on the pipeline to this function.
## OUTPUTS

### AMInstancev10
### AMInstancev11
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Start-AMProcess.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Start-AMProcess.md)

