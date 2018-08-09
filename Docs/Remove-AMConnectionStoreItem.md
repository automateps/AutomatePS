---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Remove-AMConnectionStoreItem

## SYNOPSIS
Removes connection for the specified AutoMate Enterprise server from the connection store.

## SYNTAX

```
Remove-AMConnectionStoreItem [-ConnectionStoreItem] <Object> [<CommonParameters>]
```

## DESCRIPTION
Remove-AMConnectionStoreItem removes connection objects from the connection store file.

## EXAMPLES

### EXAMPLE 1
```
Remove-AMConnectionStoreItem -Connection server01
```

## PARAMETERS

### -ConnectionStoreItem
The connection store item to delete.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

