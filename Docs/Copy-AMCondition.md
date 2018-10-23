---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Copy-AMCondition

## SYNOPSIS
Copies an AutoMate Enterprise condition.

## SYNTAX

```
Copy-AMCondition [-InputObject] <Object> [[-Name] <String>] [[-Folder] <Object>] [[-Connection] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Copy-AMCondition can copy a condition object within, or between servers.

## EXAMPLES

### EXAMPLE 1
```
# Copy condition "Daily at 12:00PM" from server1 to server2
```

Get-AMCondition "Daily at 12:00PM" -Connection server1 | Copy-AMCondition -Folder (Get-AMFolder CONDITIONS -Connection server2) -Connection server2

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### The following AutoMate object types can be modified by this function:
### Condition
## OUTPUTS

### Condition
## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

