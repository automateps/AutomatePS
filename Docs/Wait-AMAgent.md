---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Wait-AMAgent.md
schema: 2.0.0
---

# Wait-AMAgent

## SYNOPSIS
Waits for Automate agent to go online or offline.

## SYNTAX

### All (Default)
```
Wait-AMAgent [-Online] [-Timeout <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByPipeline
```
Wait-AMAgent [-InputObject <Object>] [-Online] [-Timeout <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Wait-AMAgent waits for an agent to online or offline.

## EXAMPLES

### EXAMPLE 1
```
# Wait for all offline agents to come online
Get-AMAgent | Where-Object {-not $_.Online} | Wait-AMAgent
```

# Wait for agent 'agent01' to go offline
Get-AMAgent -Name agent01 | Wait-AMAgent -Online:$false

## PARAMETERS

### -InputObject
The agents to wait for.

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

### -Online
Specify whether to wait for the agent to go online or offline (-Online:$false)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Seconds to wait for the agent status to change before timing out.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

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

### Agents can be supplied on the pipeline to this function.
## OUTPUTS

### AMAgentv10
### AMAgentv11
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Wait-AMAgent.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Wait-AMAgent.md)

