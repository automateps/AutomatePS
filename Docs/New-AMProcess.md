---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# New-AMProcess

## SYNOPSIS
Creates a new AutoMate Enterprise process.

## SYNTAX

```
New-AMProcess [-Name] <String> [-Notes <String>] [-CommandLine <String>] [-WorkingDirectory <String>]
 [-EnvironmentVariables <String>] [-RunningContext <AMRunProcessAs>] [-CompletionState <AMCompletionState>]
 [-Folder <Object>] [-Connection <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
New-AMProcess creates a new process object.

## EXAMPLES

### EXAMPLE 1
```
# Change command for a process
```

New-AMProcess -Name "Test Process" -CommandLine "dir.exe \> %TEMP%\dir.txt" -EnvironmentVariables "TEMP"

## PARAMETERS

### -Name
The name of the new object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
The new notes to set on the object.

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

### -CommandLine
The command to run.

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

### -WorkingDirectory
The working directory to use when running the command.

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

### -EnvironmentVariables
Environment variables to load when running the command.

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

### -RunningContext
The context to execute the command in: Default, SH or Bash.

```yaml
Type: AMRunProcessAs
Parameter Sets: (All)
Aliases:
Accepted values: Default, SH, Bash

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompletionState
The completion state (staging level) to set on the object.

```yaml
Type: AMCompletionState
Parameter Sets: (All)
Aliases:
Accepted values: InDevelopment, Testing, Production, Archive

Required: False
Position: Named
Default value: Production
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
The server to create the object on.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

