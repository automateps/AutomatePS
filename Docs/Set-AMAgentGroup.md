---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMAgentGroup.md
schema: 2.0.0
---

# Set-AMAgentGroup

## SYNOPSIS
Sets properties of an Automate agent group.

## SYNTAX

```
Set-AMAgentGroup [-InputObject] <Object> [-Notes] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set-AMAgentGroup can change properties of an agent group object.

## EXAMPLES

### EXAMPLE 1
```
# Change notes for an agent group
Get-AMAgentGroup "All Agents" | Set-AMUserGroup -Notes "Group containing all agents"
```

### EXAMPLE 2
```
# Empty notes for all agent groups
Get-AMAgentGroup | Set-AMUserGroup -Notes ""
```

## PARAMETERS

### -InputObject
The agent group to modify.

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

### -Notes
The new notes to set on the object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMAgentGroup.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMAgentGroup.md)

