---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Disconnect-AMServer

## SYNOPSIS
Disconnect from an AutoMate Enterprise management server

## SYNTAX

### All (Default)
```
Disconnect-AMServer [<CommonParameters>]
```

### ByConnection
```
Disconnect-AMServer [[-Connection] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Disconnect-AMServer removes stored connection information for the management server(s).

## EXAMPLES

### EXAMPLE 1
```
Disonnect-AMServer -Connection "AM01" -Credential (Get-Credential)
```

## PARAMETERS

### -Connection
The AutoMate Enterprise management server.
If the server isn't specified, all servers are removed.

```yaml
Type: Object
Parameter Sets: ByConnection
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 11/14/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

