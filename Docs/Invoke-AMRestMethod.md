---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Invoke-AMRestMethod.md
schema: 2.0.0
---

# Invoke-AMRestMethod

## SYNOPSIS
Invokes a command against the Automate management API.

## SYNTAX

### AllConnections (Default)
```
Invoke-AMRestMethod -Resource <String> [-RestMethod <String>] [-Body <String>] [-FilterScript <ScriptBlock>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### SpecificConnection
```
Invoke-AMRestMethod -Resource <String> [-RestMethod <String>] [-Body <String>] [-FilterScript <ScriptBlock>]
 [-Connection <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Invoke-AMRestMethod makes calls against the REST API and returns results.

## EXAMPLES

### EXAMPLE 1
```
# Call the API to get server information
Invoke-AMRestMethod -Resource "info/get" -RestMethod Get
```

## PARAMETERS

### -Resource
The REST resource to call.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestMethod
The REST method to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Get
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
When using the POST method, the body to send to the API.

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

### -FilterScript
Applies the specified filter to the results from the API prior to property addition and date conversion to improve performance. 
When passing dates in the filter, they must be in UTC.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
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
Parameter Sets: SpecificConnection
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

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Invoke-AMRestMethod.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Invoke-AMRestMethod.md)

[https://hstechdocs.helpsystems.com/manuals/automate/automate/api/index.html](https://hstechdocs.helpsystems.com/manuals/automate/automate/api/index.html)

