---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Get-AMConsoleOutput

## SYNOPSIS
Gets AutoMate Enterprise console output.

## SYNTAX

```
Get-AMConsoleOutput [[-MaxItems] <Int32>] [[-PollIntervalSeconds] <Int32>] [[-SuccessTextColor] <ConsoleColor>]
 [[-FailureTextColor] <ConsoleColor>] [[-SuccessBackgroundColor] <ConsoleColor>]
 [[-FailureBackgroundColor] <ConsoleColor>] [[-Connection] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMConsoleOutput gets the console output.

## EXAMPLES

### EXAMPLE 1
```
# Get console output from server "AM01"
```

Get-AMConsoleOutput -Connection "AM01"

## PARAMETERS

### -MaxItems
The maximum number of events in the console output to retrieve.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -PollIntervalSeconds
The number of seconds to wait between polls. 
Specifying this parameter enables polling until cancelled by the user with Ctrl + C.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SuccessTextColor
The text color to output success messages.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 3
Default value: White
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailureTextColor
The text color to output failure messages.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 4
Default value: Red
Accept pipeline input: False
Accept wildcard characters: False
```

### -SuccessBackgroundColor
The background color to output success messages.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailureBackgroundColor
The background color to output failure messages.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
The AutoMate Enterprise management server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
Date Modified  : 10/25/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

