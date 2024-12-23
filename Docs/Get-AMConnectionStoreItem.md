---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMConnectionStoreItem.md
schema: 2.0.0
---

# Get-AMConnectionStoreItem

## SYNOPSIS
Retrieves connections for the specified Automate server

## SYNTAX

### Default (Default)
```
Get-AMConnectionStoreItem [-FilePath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByServerOrPort
```
Get-AMConnectionStoreItem [[-Server] <String>] [-Port <Int32>] [-FilePath <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMConnectionStoreItem stores a server and connection object together in a connection store file.

## EXAMPLES

### EXAMPLE 1
```
Get-AMConnectionStoreItem -Connection server01
```

## PARAMETERS

### -Server
The Automate management server.

```yaml
Type: String
Parameter Sets: ByServerOrPort
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The TCP port for the management API.

```yaml
Type: Int32
Parameter Sets: ByServerOrPort
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
The file the server/connection combinations are stored in. 
It is stored in the user profile by default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: "$($env:APPDATA)\AutomatePS\connstore.xml"
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

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMConnectionStoreItem.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMConnectionStoreItem.md)

