---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Get-AMSession

## SYNOPSIS
Gets AutoMate Enterprise user sessions.

## SYNTAX

```
Get-AMSession [[-Connection] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMSession returns open SMC sessions from AutoMate Enterprise. 
This function uses the audit event log to determine which sessions are open.
The results of this function could be inaccurate if a session wasn't closed property, or if audit events have aged out since the last server start.

## EXAMPLES

### EXAMPLE 1
```
# Gets all user sessions
```

Get-AMSession

## PARAMETERS

### -Connection
The AutoMate Enterprise management server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
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
Date Modified  : 10/04/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

