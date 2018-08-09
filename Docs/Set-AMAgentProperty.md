---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# Set-AMAgentProperty

## SYNOPSIS
Sets the properties of an AutoMate Enterprise agent.

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
 [[-EventMonitorUser] <String>] [<CommonParameters>]
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
Default User

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
{{Fill DefaultRunAsUserName Description}}

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
{{Fill DefaultRunAsPassword Description}}

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
{{Fill DefaultRunAsDomain Description}}

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
{{Fill LogonScript Description}}

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
{{Fill UnlockScript Description}}

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
{{Fill LogonScriptKeystrokeDelay Description}}

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
Indicator

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
{{Fill ShowTrayIcon Description}}

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
{{Fill ShowTrayIconMenu Description}}

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
{{Fill ShowRunningTaskWindow Description}}

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
{{Fill RunningTaskWindowWithTitleBar Description}}

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
{{Fill RunningTaskOnTop Description}}

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
{{Fill RunningTaskWindowTransparent Description}}

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
{{Fill UseInterruptHotkey Description}}

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
{{Fill InterruptHotkey Description}}

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
Staging

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
{{Fill UseLowestCompletionState Description}}

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
{{Fill LowestCompletionState Description}}

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
Load Management

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
{{Fill MaxRunningTasks Description}}

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
Proxy

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
{{Fill SocksType Description}}

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
{{Fill ProxyHost Description}}

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
{{Fill ProxyPort Description}}

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
{{Fill ProxyUserID Description}}

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
{{Fill ProxyPassword Description}}

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
SNMP

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
{{Fill MIBLocation Description}}

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
{{Fill SNMPTrapPort Description}}

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
Email

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
{{Fill EmailProtocol Description}}

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
{{Fill EmailServer Description}}

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
{{Fill EmailPort Description}}

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
{{Fill EmailAuthenticationType Description}}

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
{{Fill EmailUserName Description}}

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
{{Fill EmailPassword Description}}

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
{{Fill EmailSecurity Description}}

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
{{Fill EmailCertificate Description}}

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
{{Fill EmailCertificatePassphrase Description}}

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
{{Fill EmailIgnoreServerCertificate Description}}

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
{{Fill EmailAddress Description}}

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
{{Fill EmailUseAutoDiscovery Description}}

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
{{Fill EmailExchangeProtocol Description}}

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
{{Fill EmailUrl Description}}

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
{{Fill EmailDomainName Description}}

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
{{Fill EmailVersion Description}}

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
{{Fill EmailProxyType Description}}

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
{{Fill EmailProxyServer Description}}

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
{{Fill EmailProxyPort Description}}

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
{{Fill EmailProxyUsername Description}}

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
{{Fill EmailProxyPassword Description}}

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
Miscellaneous

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
{{Fill AgentPort Description}}

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
{{Fill TaskCacheFilePath Description}}

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
{{Fill EventMonitorAutoMateStartMode Description}}

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
{{Fill DisableForegroundTimeout Description}}

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
{{Fill EventMonitorUser Description}}

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

