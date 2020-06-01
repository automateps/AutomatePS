---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS
schema: 2.0.0
---

# New-AMKeyboardCondition

## SYNOPSIS
Creates a new Automate keyboard condition.

## SYNTAX

### Hotkey
```
New-AMKeyboardCondition [-Name] <String> [-Hotkey <String>] [-HotkeyPassthrough] [-Process <String>]
 [-ProcessFocused] [-Notes <String>] [-Folder <Object>] [-Connection <Object>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Text
```
New-AMKeyboardCondition [-Name] <String> [-Text <String>] [-EraseText] [-Process <String>] [-ProcessFocused]
 [-Notes <String>] [-Folder <Object>] [-Connection <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
New-AMKeyboardCondition creates a new keyboard condition.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS](https://github.com/AutomatePS/AutomatePS)

