---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Copy-AMProcess

## SYNOPSIS
Copies an Automate process.

## SYNTAX

```
Copy-AMProcess [-InputObject] <Object> [[-Name] <String>] [[-Folder] <Object>] [[-Connection] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Copy-AMProcess can copy a process object within, or between servers.

## EXAMPLES

### EXAMPLE 1
```
# Copy process "Start Service" from server1 to server2
Get-AMProcess "Start Service" -Connection server1 | Copy-AMProcess -Folder (Get-AMFolder PROCESSES -Connection server2) -Connection server2
```

### EXAMPLE 2
```
# Copy process "Start Service" with new name "Restart Service"
Get-AMProcess "Start Service" | Copy-AMProcess -Name "Restart Service"
```

## PARAMETERS

### -InputObject
The object to copy.

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

### -Name
The new name to set on the object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Folder
The folder to place the object in.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
The server to copy the object to.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following Automate object types can be modified by this function:
### Process
## OUTPUTS

### Process
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

