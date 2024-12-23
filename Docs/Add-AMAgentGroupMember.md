---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMAgentGroupMember.md
schema: 2.0.0
---

# Add-AMAgentGroupMember

## SYNOPSIS
Adds agents to an Automate agent group.

## SYNTAX

```
Add-AMAgentGroupMember -InputObject <Object> [-Agent] <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Add-AMAgentGroupMember adds agents to an agent group.

## EXAMPLES

### EXAMPLE 1
```
Get-AMAgentGroup "All Agents" | Add-AMAgentGroupMember -Agent *
```

### EXAMPLE 2
```
Get-AMAgentGroup | Add-AMAgentGroupMember -Agent (Get-AMAgent "Agent1")
```

## PARAMETERS

### -InputObject
The agent group to modify.

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
The agent name(s), or object(s) to add to the agent group.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

### The following Automate object types can be modified by this function:
### AgentGroup
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMAgentGroupMember.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMAgentGroupMember.md)

