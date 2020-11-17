---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMRepositoryMapDetail.md
schema: 2.0.0
---

# Get-AMRepositoryMapDetail

## SYNOPSIS
Retrieves information about server to server repository mappings

## SYNTAX

```
Get-AMRepositoryMapDetail [[-SourceConnection] <Object>] [[-DestinationConnection] <Object>]
 [[-FilePath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMRepositoryMapDetail retrieves information about repository mappings between two servers to be supplied to Copy-AMWorkflow

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -SourceConnection
The source server connection alias

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

### -DestinationConnection
The destination server connection alias

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
The file path to retrieve repository mappings from, retrieved from the user profile by default

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: "$($env:APPDATA)\AutomatePS\repositorymap.csv"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMRepositoryMapDetail.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMRepositoryMapDetail.md)

