---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Set-AMProcess

## SYNOPSIS
Sets properties of an AutoMate Enterprise process.

## SYNTAX

### ByInputObject
```
Set-AMProcess -InputObject <Object> [-Notes <String>] [-CommandLine <String>] [-WorkingDirectory <String>]
 [-EnvironmentVariables <String>] [-RunningContext <AMRunProcessAs>] [-CompletionState <AMCompletionState>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByInstance
```
Set-AMProcess -Instance <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set-AMProcess can change properties of a process object.

## EXAMPLES

### EXAMPLE 1
```
# Change command for a process
```

Get-AMProcess "Start Service" | Set-AMProcess -Notes "Starts a service"

### EXAMPLE 2
```
# Empty notes for all agent groups
```

Get-AMProcess | Set-AMProcess -RunningContext Bash

## PARAMETERS

### -InputObject
The object to modify.

```yaml
Type: Object
Parameter Sets: ByInputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Instance
The process object to save directly to the server. 
This parameter takes a process that has been manually modified to be saved as-is to the server.

```yaml
Type: Object
Parameter Sets: ByInstance
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
The new notes to set on the object.

```yaml
Type: String
Parameter Sets: ByInputObject
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
Parameter Sets: ByInputObject
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
Parameter Sets: ByInputObject
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
Parameter Sets: ByInputObject
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
Parameter Sets: ByInputObject
Aliases:
Accepted values: Default, SH, Bash

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompletionState
The completion state (staging level) to set on the object.

```yaml
Type: AMCompletionState
Parameter Sets: ByInputObject
Aliases:
Accepted values: InDevelopment, Testing, Production, Archive

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

### The following AutoMate object types can be modified by this function:
### Process
## OUTPUTS

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

