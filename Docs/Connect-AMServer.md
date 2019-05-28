---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Connect-AMServer

## SYNOPSIS
Connect to an AutoMate Enterprise management server

## SYNTAX

### ByConnectionStore (Default)
```
Connect-AMServer [-Server] <String[]> [-Port <Int32>] [-ConnectionAlias <String>]
 [-ConnectionStoreFilePath <String>] [-SaveConnection] [<CommonParameters>]
```

### ByCredential
```
Connect-AMServer [-Server] <String[]> [-Port <Int32>] [-Credential <PSCredential>] [-ConnectionAlias <String>]
 [-SaveConnection] [<CommonParameters>]
```

### ByUserPass
```
Connect-AMServer [-Server] <String[]> [-Port <Int32>] [-UserName <String>] [-Password <SecureString>]
 [-ConnectionAlias <String>] [-SaveConnection] [<CommonParameters>]
```

## DESCRIPTION
Connect-AMServer gathers connection information for AutoMate Enterprise, and tests authentication.
This module supports connecting to multiple servers at once.

## EXAMPLES

### EXAMPLE 1
```
Connect-AMServer -Connection "automate01" -Credential (Get-Credential)
```

## PARAMETERS

### -Server
The AutoMate Enterprise management server. 
One or more can be provided. 
The same credentials are used for all servers.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The TCP port for the management API.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 9708
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
The credentials use during authentication.

```yaml
Type: PSCredential
Parameter Sets: ByCredential
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
The username to use during authentication.

```yaml
Type: String
Parameter Sets: ByUserPass
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password to use during authentication.

```yaml
Type: SecureString
Parameter Sets: ByUserPass
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionAlias
The alias to assign to this connection.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionStoreFilePath
The file that connections are stored in.

```yaml
Type: String
Parameter Sets: ByConnectionStore
Aliases:

Required: False
Position: Named
Default value: "$($env:APPDATA)\AutomatePS\connstore.xml"
Accept pipeline input: False
Accept wildcard characters: False
```

### -SaveConnection
Saves the new connection to the connection store.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Connection
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

