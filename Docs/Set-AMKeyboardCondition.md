---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# Set-AMKeyboardCondition

## SYNOPSIS
Sets properties of an Automate keyboard condition.

## SYNTAX

### Hotkey
```
Set-AMKeyboardCondition -InputObject <Object> [-Hotkey <String>] [-HotkeyPassthrough] [-Process <String>]
 [-ProcessFocused] [-Notes <String>] [-CompletionState <AMCompletionState>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Text
```
Set-AMKeyboardCondition -InputObject <Object> [-Text <String>] [-EraseText] [-Process <String>]
 [-ProcessFocused] [-Notes <String>] [-CompletionState <AMCompletionState>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Set-AMKeyboardCondition modifies an existing keyboard condition.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -InputObject
The condition to modify.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Hotkey
The hotkey to trigger the condition.

```yaml
Type: String
Parameter Sets: Hotkey
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HotkeyPassthrough
Allow hotkey to continue to the application.

```yaml
Type: SwitchParameter
Parameter Sets: Hotkey
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text
The text to trigger the condition.

```yaml
Type: String
Parameter Sets: Text
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EraseText
Erase text afterwards.

```yaml
Type: SwitchParameter
Parameter Sets: Text
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Process
Only run when the specified process is active.

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

### -ProcessFocused
The process window must be focused.

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

### -CompletionState
The completion state (staging level) to set on the object.

```yaml
Type: AMCompletionState
Parameter Sets: (All)
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

