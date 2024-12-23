---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMConnection.md
schema: 2.0.0
---

# Get-AMConnection

## SYNOPSIS
Gets current Automate connections.

## SYNTAX

### AllConnections (Default)
```
Get-AMConnection [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByConnection
```
Get-AMConnection [-Connection <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMConnection gets a list of current connections to Automate.

## EXAMPLES

### EXAMPLE 1
```
$connection = Connect-AMServer "automate01"
Get-AMConnection -Connection $connection
```

### EXAMPLE 2
```
Connect-AMServer "automate01" -ConnectionAlias "prod"
Get-AMConnection -Connection "prod"
```

## PARAMETERS

### -Connection
The connection name(s) or object(s).

```yaml
Type: Object
Parameter Sets: ByConnection
Aliases: ConnectionAlias

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

### Connection, String
## OUTPUTS

### Connection
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMConnection.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMConnection.md)

