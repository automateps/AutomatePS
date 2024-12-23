---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMSession.md
schema: 2.0.0
---

# Get-AMSession

## SYNOPSIS
Gets Automate user sessions.

## SYNTAX

```
Get-AMSession [[-Connection] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMSession returns open SMC sessions from Automate. 
This function uses the audit event log to determine which sessions are open.
The results of this function could be inaccurate if a session wasn't closed property, or if audit events have aged out since the last server start.

## EXAMPLES

### EXAMPLE 1
```
# Gets all user sessions
Get-AMSession
```

## PARAMETERS

### -Connection
The Automate management server.

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

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMSession.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMSession.md)

