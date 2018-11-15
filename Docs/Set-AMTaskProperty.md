---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Set-AMTaskProperty

## SYNOPSIS
Sets the task properties of an AutoMate Enterprise task.

## SYNTAX

```
Set-AMTaskProperty [-InputObject] <Object> [-ErrorNotificationPropertiesSpecified]
 [[-ErrorNotifyEmailFromAddress] <String>] [[-ErrorNotifyEmailToAddress] <String>]
 [-ExecutionPropertiesSpecified] [[-TaskExecutionSpeed] <Int32>] [-CanStopTask] [-IsolationPropertiesSpecified]
 [[-Isolation] <AMTaskIsolation>] [-LogonPropertiesSpecified] [[-OnLocked] <AMRunAsUser>]
 [[-OnLogged] <AMRunAsUser>] [[-OnLogoff] <AMRunAsUser>] [-UseLogonDefault] [[-LogonUsername] <String>]
 [[-LogonPassword] <String>] [[-LogonDomain] <String>] [-RunAsElevated] [-PriorityPropertiesSpecified]
 [[-Priority] <AMConcurrencyType>] [[-PriorityAction] <AMPriorityAction>] [[-MaxTaskInstances] <Int32>]
 [[-PriorityWaitTimeOut] <Int32>] [[-TaskFailureAction] <AMTaskFailureAction>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Set-AMTaskProperty modifies task properties.

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
Position: 2
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
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExecutionPropertiesSpecified
Override the execution property inheritance.

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

### -TaskExecutionSpeed
The speed in milliseconds that the the task should wait between steps.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CanStopTask
Whether a user can stop the running task.

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

### -IsolationPropertiesSpecified
Override the isolation property inheritance.

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

### -Isolation
The task isolation level.

```yaml
Type: AMTaskIsolation
Parameter Sets: (All)
Aliases:
Accepted values: Default, Always, Never

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogonPropertiesSpecified
Override the logon property inheritance.

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

### -OnLocked
The action to take when the workstation is locked.

```yaml
Type: AMRunAsUser
Parameter Sets: (All)
Aliases:
Accepted values: LoggedonUser, SpecifiedUser, BackgroundUser, DoNotRun

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnLogged
The action to take when the workstation is logged on.

```yaml
Type: AMRunAsUser
Parameter Sets: (All)
Aliases:
Accepted values: LoggedonUser, SpecifiedUser, BackgroundUser, DoNotRun

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnLogoff
The action to take when the workstation is logged off.

```yaml
Type: AMRunAsUser
Parameter Sets: (All)
Aliases:
Accepted values: LoggedonUser, SpecifiedUser, BackgroundUser, DoNotRun

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseLogonDefault
Whether the task should run as the default agent user, or the specified user.

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

### -LogonUsername
The username to login as.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogonPassword
The password for the specified user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogonDomain
The domain for the specified user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunAsElevated
Whether the task should run with elevated rights.

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

### -PriorityPropertiesSpecified
Override the priority property inheritance.

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

### -Priority
The task priority level.

```yaml
Type: AMConcurrencyType
Parameter Sets: (All)
Aliases:
Accepted values: AlwaysRun, RunningInstancesBelowThreshold, RunningTasksBelowThreshold, RunWithNoOtherTasks

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PriorityAction
The action to take if the priority level is not met.

```yaml
Type: AMPriorityAction
Parameter Sets: (All)
Aliases:
Accepted values: Hold, DoNotRun, HoldInterrupt, HoldTimeout, InterruptTasks, InterruptInstances

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTaskInstances
The task instance threshold for the priority action specified.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PriorityWaitTimeOut
The timeout in minutes to use if the priority action allows for timeout.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaskFailureAction
If the priority is not met, the status to set on the task.

```yaml
Type: AMTaskFailureAction
Parameter Sets: (All)
Aliases:
Accepted values: Success, Failure, ReturnResult

Required: False
Position: 16
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
Date Created   : 07/27/2018
Date Modified  : 11/15/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

