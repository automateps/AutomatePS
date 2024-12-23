---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMSystemAgent.md
schema: 2.0.0
---

# Get-AMSystemAgent

## SYNOPSIS
Gets Automate system agent types.

## SYNTAX

### All (Default)
```
Get-AMSystemAgent [-Connection <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByID
```
Get-AMSystemAgent [-ID <String>] [-Connection <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ByType
```
Get-AMSystemAgent [-Type <String>] [-Connection <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-AMSystemAgent returns a list of system agent types and their IDs.

## EXAMPLES

### EXAMPLE 1
```
# Get the default system agent
Get-AMSystemAgent -Type Default
```

### EXAMPLE 2
```
# Get workflows that use "Previous Agent"
Get-AMSystemAgent -Type Previous | Get-AMWorkflow
```

## PARAMETERS

### -ID
The ID of the system agent.

```yaml
Type: String
Parameter Sets: ByID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of system agent to return.

```yaml
Type: String
Parameter Sets: ByType
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
The Automate management server.

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

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMSystemAgent.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMSystemAgent.md)

