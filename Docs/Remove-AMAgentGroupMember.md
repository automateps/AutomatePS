---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMAgentGroupMember.md
schema: 2.0.0
---

# Remove-AMAgentGroupMember

## SYNOPSIS
Removes agents from an Automate agent group.

## SYNTAX

```
Remove-AMAgentGroupMember -InputObject <Object> [-Agent] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove-AMAgentGroupMember can remove agents from an agent group.

## EXAMPLES

### EXAMPLE 1
```
# Remove all agents from an agent group
Get-AMAgentGroup "All Agents" | Remove-AMAgentGroupMember -Agent *
```

### EXAMPLE 2
```
# Remove an agent from an agent group (using agent object)
Get-AMAgentGroup | Remove-AMAgentGroupMember -Agent (Get-AMAgent "Agent1")
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
The agent(s) to remove to the agent group.

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

### The following Automate object types can be modified by this function:
### AgentGroup
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMAgentGroupMember.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMAgentGroupMember.md)

