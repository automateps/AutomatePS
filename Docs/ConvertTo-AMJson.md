---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/ConvertTo-AMJson.md
schema: 2.0.0
---

# ConvertTo-AMJson

## SYNOPSIS
Converts Automate objects to JSON.

## SYNTAX

```
ConvertTo-AMJson [[-InputObject] <Object>] [[-Depth] <Int32>] [-Compress] [<CommonParameters>]
```

## DESCRIPTION
ConvertTo-AMJson converts Automate objects to JSON. 
In PowerShell versions 6 and above, special handling is required to properly serialize date objects.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -InputObject
The object to serialize to JSON.

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

### -Depth
Specifies how many levels of contained objects are included in the JSON representation.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 1024
Accept pipeline input: False
Accept wildcard characters: False
```

### -Compress
Omits white space and indented formatting in the output string.

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

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/ConvertTo-AMJson.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/ConvertTo-AMJson.md)

