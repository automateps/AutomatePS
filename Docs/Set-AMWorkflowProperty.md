---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Set-AMWorkflowProperty

## SYNOPSIS
Sets the properties of an AutoMate Enterprise workflow.

## SYNTAX

```
Set-AMWorkflowProperty [-InputObject] <Object> [-DefaultAgentPropertiesSpecified] [[-DefaultAgent] <Object>]
 [-ErrorNotificationPropertiesSpecified] [[-ErrorNotifyEmailFromAddress] <String>]
 [[-ErrorNotifyEmailToAddress] <String>] [-DisableOnFailure] [-ResumeFromFailure] [-TimeoutPropertiesSpecified]
 [-TimeoutEnabled] [[-Timeout] <Int32>] [[-TimeoutUnit] <AMTimeMeasure>] [<CommonParameters>]
```

## DESCRIPTION
Set-AMWorkflowProperty modifies workflow properties.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -InputObject
The workflow property to modify.

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

### -DefaultAgentPropertiesSpecified
Override the default agent property inheritance.

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

### -DefaultAgent
The default agent.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorNotificationPropertiesSpecified
Override the error property inheritance.

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

### -ErrorNotifyEmailFromAddress
The error email sender.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorNotifyEmailToAddress
The error email recipient.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableOnFailure
Whether the workflow should be automatically disabled on next failure.

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

### -ResumeFromFailure
Whether the workflow should automatically resume from failure on next run.

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

### -TimeoutPropertiesSpecified
Override the timeout property inheritance.

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

### -TimeoutEnabled
Whether the timeout property is enabled.

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

### -Timeout
The timeout duration.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutUnit
The timeout unit.

```yaml
Type: AMTimeMeasure
Parameter Sets: (All)
Aliases:
Accepted values: Seconds, Minutes, Hours, Days, Milliseconds

Required: False
Position: 6
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
Date Created   : 07/27/2018
Date Modified  : 08/08/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

