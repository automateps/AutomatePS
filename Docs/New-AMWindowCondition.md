---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMWindowCondition.md
schema: 2.0.0
---

# New-AMWindowCondition

## SYNOPSIS
Creates a new Automate window condition.

## SYNTAX

```
New-AMWindowCondition [-Name] <String> [-Action <AMWindowAction>] [-TriggerOnce] [-HoldFocus] [-Title <String>]
 [-Class <String>] [-Handle <String>] [-ChildWindow] [-Delay <Int32>] [-Wait] [-Timeout <Int32>]
 [-TimeoutUnit <AMTimeMeasure>] [-TriggerAfter <Int32>] [-Notes <String>] [-Folder <Object>]
 [-Connection <Object>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
New-AMWindowCondition creates a new window condition.

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

### -Action
Specifies the window state to monitor.

```yaml
Type: AMWindowAction
Parameter Sets: (All)
Aliases:
Accepted values: Open, Close, Focus, Background

Required: False
Position: Named
Default value: Open
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerOnce
If enabled, specifies that the action to be performed on the window being monitored will occur only once when that window first opens and ignore other instances.

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

### -HoldFocus
If specified, holds the window in focus.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
Specifies the title of the window to monitor.
The value is not case sensitive.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Class
Specifies the class of the window to monitor.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Handle
Specifies the handle of the window to monitor.
A window handle is code that uniquely identifies an open window (disabled by default).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ChildWindow
If enabled, specifies that the window to monitor is a child window.
A child window is normally a secondary window on screen that is displayed within the main overall window of the application.
This option is available only when the Action parameter is set to Wait for window to be focused or Wait for window to not be focused.

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

### -Delay
Use a delay (in milliseconds) to prevent this condition from checking a window's condition immediately.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
Wait for the condition, or evaluate immediately.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
If wait is specified, the amount of time before the condition times out.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutUnit
The unit for Timeout (Seconds by default).

```yaml
Type: AMTimeMeasure
Parameter Sets: (All)
Aliases:
Accepted values: Seconds, Minutes, Hours, Days, Milliseconds

Required: False
Position: Named
Default value: Seconds
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerAfter
The number of times the condition should occur before the trigger fires.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMWindowCondition.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMWindowCondition.md)

