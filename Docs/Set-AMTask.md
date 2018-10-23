---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Set-AMTask

## SYNOPSIS
Sets properties of an AutoMate Enterprise task.

## SYNTAX

### ByInputObject
```
Set-AMTask -InputObject <Object> [-Notes <String>] [-AML <String>] [-CompletionState <AMCompletionState>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByInstance
```
Set-AMTask -Instance <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set-AMTask can change properties of a task object.

## EXAMPLES

### EXAMPLE 1
```
# Change notes for a task
```

Get-AMTask "Delete Log Files" | Set-AMTask -Notes "Deletes old log files"

### EXAMPLE 2
```
# Change AML for a task
```

Get-AMTask "Some Task" | Set-AMTask -AML (Get-AMTask "Some Other Task").AML

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
The task object to save directly to the server. 
This parameter takes a task that has been manually modified to be saved as-is to the server.

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

### -AML
The new AutoMate Markup Language (AML) to set on the object.

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
### Task
## OUTPUTS

## NOTES
Author(s):     : David Seibel
Contributor(s) :
Date Created   : 07/26/2018
Date Modified  : 10/23/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

