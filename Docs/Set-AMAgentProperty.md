---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMAgentProperty.md
schema: 2.0.0
---

# Set-AMAgentProperty

## SYNOPSIS
Sets the properties of an Automate agent.

## SYNTAX

```
Set-AMAgentProperty [-InputObject] <Object> [-DefaultUserPropertiesSpecified]
 [[-DefaultRunAsUserName] <String>] [[-DefaultRunAsPassword] <String>] [[-DefaultRunAsDomain] <String>]
 [[-LogonScript] <String>] [[-UnlockScript] <String>] [[-LogonScriptKeystrokeDelay] <Int32>]
 [-IndicatorsPropertiesSpecified] [[-ShowTrayIcon] <AMPrefsShowTrayIcon>] [-ShowTrayIconMenu]
 [-ShowRunningTaskWindow] [-RunningTaskWindowWithTitleBar] [-RunningTaskOnTop] [-RunningTaskWindowTransparent]
 [-UseInterruptHotkey] [[-InterruptHotkey] <String>] [-StagingPropertiesSpecified] [-UseLowestCompletionState]
 [[-LowestCompletionState] <AMCompletionState>] [-LoadManagementPropertiesSpecified]
 [[-MaxRunningTasks] <Int32>] [-ProxyPropertiesSpecified] [[-SocksType] <AMSocksType>] [[-ProxyHost] <String>]
 [[-ProxyPort] <Int32>] [[-ProxyUserID] <String>] [[-ProxyPassword] <String>] [-SNMPPropertiesSpecified]
 [[-MIBLocation] <String>] [[-SNMPTrapPort] <Int32>] [-EmailPropertiesSpecified]
 [[-EmailProtocol] <AMSendEmailProtocol>] [[-EmailServer] <String>] [[-EmailPort] <Int32>]
 [[-EmailAuthenticationType] <String>] [[-EmailUserName] <String>] [[-EmailPassword] <String>]
 [[-EmailSecurity] <AMSecurityType>] [[-EmailCertificate] <String>] [[-EmailCertificatePassphrase] <String>]
 [-EmailIgnoreServerCertificate] [[-EmailAddress] <String>] [-EmailUseAutoDiscovery]
 [[-EmailExchangeProtocol] <AMHttpProtocol>] [[-EmailUrl] <String>] [[-EmailDomainName] <String>]
 [[-EmailVersion] <AMEmailVersion>] [[-EmailProxyType] <AMProxyType>] [[-EmailProxyServer] <String>]
 [[-EmailProxyPort] <Int32>] [[-EmailProxyUsername] <String>] [[-EmailProxyPassword] <String>]
 [-SystemPropertiesSpecified] [[-AgentPort] <Int32>] [[-TaskCacheFilePath] <String>]
 [[-EventMonitorAutoMateStartMode] <AMEventMonitorAutoStartModeType>] [-DisableForegroundTimeout]
 [[-EventMonitorUser] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set-AMAgentProperty modifies agent properties.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -InputObject
The agent property to modify.

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

### -DefaultUserPropertiesSpecified
Whether the default user settings are specified (true) or inherited (false) from the server.

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

### -DefaultRunAsUserName
The default user name that agents should use when automatically logging onto or unlocking a workstation.

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

### -DefaultRunAsPassword
The default password to be used with the user name specified.

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

### -DefaultRunAsDomain
The domain or machine name associated with the user.
This parameter can be left blank if the user is not a member of a domain or if there is only one workgroup for the machine.

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

### -LogonScript
The keystrokes to use in order for an agent to successfully log onto the workstation when a user is not present.
Automate will simulate a user entering these keystrokes onto the Windows Logon screen.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UnlockScript
The keystrokes to use in order for the agent to successfully unlock the workstation.
Automate will simulate a user entering these keystrokes in order to successfully unlock a machine.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogonScriptKeystrokeDelay
The number of milliseconds to pause between each keystroke.
By default, Automate will press each key of the key sequence every 200 milliseconds.
Adjust this number if keystrokes appear to be missing during the logon or unlock process, which may indicate that they are being typed too quickly.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -IndicatorsPropertiesSpecified
Whether the indicator settings are specified (true) or inherited (false) from the server.

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

### -ShowTrayIcon
Indicates whether the Automate "A" icon should be displayed in the system tray of the agent machine.

```yaml
Type: AMPrefsShowTrayIcon
Parameter Sets: (All)
Aliases:
Accepted values: Always, Never, RunOnly

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowTrayIconMenu
If enabled, allows right-clicks to be performed on the tray icon in order to display a context menu.

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

### -ShowRunningTaskWindow
If enabled, the agent computer displays a small indicator window in the lower right-hand corner of the desktop during task execution.

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

### -RunningTaskWindowWithTitleBar
If enabled, a title bar is displayed on the Running Task Indicator window.

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

### -RunningTaskOnTop
If enabled, puts the Running Task Indicator window on top of all other open windows on the desktop.

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

### -RunningTaskWindowTransparent
If enabled, the Running Task Indicator window appears transparent.

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

### -UseInterruptHotkey
If enabled, activates the Task interruption hotkey parameter which allows entry of a specific hotkey combination used to interrupt running tasks.

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

### -InterruptHotkey
Specifies the hot-key combination to enter in order to suspend one or more running tasks and invoke the a Running Tasks dialog.

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

### -StagingPropertiesSpecified
Whether the staging settings are specified (true) or inherited (false) from the server.

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

### -UseLowestCompletionState
If enabled, tasks and conditions will execute on the agent only if the completion state is equal to or higher than the one specified.

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

### -LowestCompletionState
InDevelopment (default) - Tells the system to run all tasks and conditions currently in development stage (lowest stage) or higher, which basically indicates all tasks and conditions.
         Testing - Tells the system to run all tasks and conditions that are currently in the testing stage or higher.
         Production - Tells the system to run all tasks and conditions currently in the production stage or higher.
         Archive - Tells the system to run all tasks and conditions currently in the archive stage.

```yaml
Type: AMCompletionState
Parameter Sets: (All)
Aliases:
Accepted values: InDevelopment, Testing, Production, Archive

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoadManagementPropertiesSpecified
Whether the load management settings are specified (true) or inherited (false) from the server.

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

### -MaxRunningTasks
Specifies the maximum number of tasks that should run simultaneously on a given agent.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProxyPropertiesSpecified
Whether the proxy settings are specified (true) or inherited (false) from the server.

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

### -SocksType
The proxy protocol that the proxy server uses to accept requests from Automate Enterprise.

```yaml
Type: AMSocksType
Parameter Sets: (All)
Aliases:
Accepted values: NoProxy, Socks4, Socks4a, Socks5, HTTP

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProxyHost
The host name or host address of the proxy to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProxyPort
The port on the proxy server to use.

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

### -ProxyUserID
The user name to authenticate proxy requests.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProxyPassword
The password to authenticate proxy requests.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SNMPPropertiesSpecified
Whether the SNMP settings are specified (true) or inherited (false) from the server.

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

### -MIBLocation
Indicates the directory location of the MIB (Management Information Base) files.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SNMPTrapPort
The port that Automate Enterprise will use to listen for traps using the SNMP Trap Condition.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailPropertiesSpecified
Whether the email settings are specified (true) or inherited (false) from the server.

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

### -EmailProtocol
The email protocol to communicate with.

```yaml
Type: AMSendEmailProtocol
Parameter Sets: (All)
Aliases:
Accepted values: SMTP, Webdav, EWS

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailServer
The name of the mail server that will send emails generated by Automate Enterprise.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailPort
The default port that the mail server uses.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailAuthenticationType
Specifies the authentication type to administer.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailUserName
Specifies the username that the server authenticates with.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 23
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailPassword
Specifies the password matching the username that the server authenticates with.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 24
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailSecurity
The type of security that this action should use.

```yaml
Type: AMSecurityType
Parameter Sets: (All)
Aliases:
Accepted values: None, Explicit, Implicit

Required: False
Position: 25
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailCertificate
The full path and file name of the certificate (.cer or .pfx extension) used to authenticate with.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 26
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailCertificatePassphrase
The passphrase used to authenticate the SSL/TLS private key file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 27
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailIgnoreServerCertificate
Invalid or expired SSL server certificates that are detected will be ignored.

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

### -EmailAddress
The Exchange server email address to use for email transactions.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 28
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailUseAutoDiscovery
Automatically discover the server based on the email address entered in the EmailAddress parameter.

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

### -EmailExchangeProtocol
The protocol to use for email transactions.

```yaml
Type: AMHttpProtocol
Parameter Sets: (All)
Aliases:
Accepted values: HTTPS, HTTP

Required: False
Position: 29
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailUrl
The URL for the email server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 30
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailDomainName
The domain name to authenticate with.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 31
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailVersion
The email server version.

```yaml
Type: AMEmailVersion
Parameter Sets: (All)
Aliases:
Accepted values: Exchange2007SP1, Exchange2010, Exchange2010SP1, Exchange2010SP2, Exchange2013

Required: False
Position: 32
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailProxyType
The proxy protocol used.

```yaml
Type: AMProxyType
Parameter Sets: (All)
Aliases:
Accepted values: NoProxy, Socks4, Socks4a, Socks5, HTTP

Required: False
Position: 33
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailProxyServer
The hostname or IP address of the proxy server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 34
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailProxyPort
The port used to communicate with the proxy server.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 35
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailProxyUsername
The username used to authenticate connection to the proxy server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 36
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailProxyPassword
The password used to authenticate the username specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 37
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SystemPropertiesSpecified
Whether the system settings are specified (true) or inherited (false) from the server.

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

### -AgentPort
Specifies the default port that connected agents should use to communicate with the server component.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 38
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaskCacheFilePath
The path to cache task files on the agent.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 39
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventMonitorAutoMateStartMode
The event monitor user context.

```yaml
Type: AMEventMonitorAutoStartModeType
Parameter Sets: (All)
Aliases:
Accepted values: FirstComeFirstServed, ConsoleOnly, TerminalServiceUser, Off

Required: False
Position: 40
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableForegroundTimeout
If this option is enabled, Windows Foreground Timeout functionality is turned off, allowing Automate to properly bring specific windows into the foreground.

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

### -EventMonitorUser
The user to run the event monitor as.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 41
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

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMAgentProperty.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMAgentProperty.md)

