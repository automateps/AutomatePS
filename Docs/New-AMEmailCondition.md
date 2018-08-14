---
external help file: AutoMatePS-help.xml
Module Name: AutoMatePS
online version: https://github.com/davidseibel/AutoMatePS
schema: 2.0.0
---

# New-AMEmailCondition

## SYNOPSIS
Creates a new AutoMate Enterprise Email condition.

## SYNTAX

```
New-AMEmailCondition [[-Name] <String>] [-Wait] [[-Timeout] <Int32>] [[-TimeoutUnit] <AMTimeMeasure>]
 [[-TriggerAfter] <Int32>] [-AllowRedirection] [[-AuthType] <String>] [[-AuthenticationType] <String>]
 [-AutoDiscover] [[-Certificate] <String>] [[-CertificatePath] <String>] [[-ConnectionType] <AMConnectionType>]
 [[-CurrentFolder] <String>] [[-DomainName] <String>] [-EWSUseDefault] [[-EmailAddress] <String>]
 [[-EmailFilterType] <AMEmailFilterType>] [[-ExchangeVersion] <String>] [[-ExternalEWSUrl] <String>]
 [-HasMailBoxURL] [[-HttpProtocol] <AMHttpProtocol>] [-IgnoreCertificate] [-IgnoreServerCertificate]
 [-Impersonate] [[-MailBoxURL] <String>] [[-PollingInterval] <Int32>] [[-Port] <String>]
 [[-ProtocolType] <AMGetEmailProtocol>] [[-ProxyPort] <String>] [[-ProxyServer] <String>]
 [[-ProxyType] <AMProxyType>] [[-ProxyUserName] <String>] [[-Security] <AMSecurityType>] [[-Server] <String>]
 [-UseAutoDiscovery] [-UseForm] [-UseHTTP] [-UseNTLM] [[-UserAgent] <String>] [[-UserName] <String>]
 [[-WebDavAuthentication] <AMWebDavAuthentication>] [[-Notes] <String>] [[-Folder] <Object>]
 [[-Connection] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
New-AMEmailCondition creates a new Email condition.

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

Required: False
Position: 1
Default value: None
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
Position: 2
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
Position: 3
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
Position: 4
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowRedirection
{{Fill AllowRedirection Description}}

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

### -AuthType
{{Fill AuthType Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Auto
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthenticationType
{{Fill AuthenticationType Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Auto
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoDiscover
{{Fill AutoDiscover Description}}

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

### -Certificate
{{Fill Certificate Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CertificatePath
{{Fill CertificatePath Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionType
{{Fill ConnectionType Description}}

```yaml
Type: AMConnectionType
Parameter Sets: (All)
Aliases:
Accepted values: System, Host, Session

Required: False
Position: 9
Default value: System
Accept pipeline input: False
Accept wildcard characters: False
```

### -CurrentFolder
{{Fill CurrentFolder Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: Inbox
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainName
{{Fill DomainName Description}}

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

### -EWSUseDefault
{{Fill EWSUseDefault Description}}

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
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailFilterType
{{Fill EmailFilterType Description}}

```yaml
Type: AMEmailFilterType
Parameter Sets: (All)
Aliases:
Accepted values: Sent, Received

Required: False
Position: 13
Default value: Received
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExchangeVersion
{{Fill ExchangeVersion Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExternalEWSUrl
{{Fill ExternalEWSUrl Description}}

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

### -HasMailBoxURL
{{Fill HasMailBoxURL Description}}

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

### -HttpProtocol
{{Fill HttpProtocol Description}}

```yaml
Type: AMHttpProtocol
Parameter Sets: (All)
Aliases:
Accepted values: HTTPS, HTTP

Required: False
Position: 16
Default value: HTTPS
Accept pipeline input: False
Accept wildcard characters: False
```

### -IgnoreCertificate
{{Fill IgnoreCertificate Description}}

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

### -IgnoreServerCertificate
{{Fill IgnoreServerCertificate Description}}

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

### -Impersonate
{{Fill Impersonate Description}}

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

### -MailBoxURL
{{Fill MailBoxURL Description}}

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

### -PollingInterval
\[string\]$Passphrase,
\[string\]$Password,

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
{{Fill Port Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProtocolType
{{Fill ProtocolType Description}}

```yaml
Type: AMGetEmailProtocol
Parameter Sets: (All)
Aliases:
Accepted values: Webdav, EWS

Required: False
Position: 20
Default value: EWS
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProxyPort
\[string\]$ProxyPassword,

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProxyServer
{{Fill ProxyServer Description}}

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

### -ProxyType
{{Fill ProxyType Description}}

```yaml
Type: AMProxyType
Parameter Sets: (All)
Aliases:
Accepted values: NoProxy, Socks4, Socks4a, Socks5, HTTP

Required: False
Position: 23
Default value: NoProxy
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProxyUserName
{{Fill ProxyUserName Description}}

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

### -Security
{{Fill Security Description}}

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

### -Server
{{Fill Server Description}}

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

### -UseAutoDiscovery
{{Fill UseAutoDiscovery Description}}

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

### -UseForm
{{Fill UseForm Description}}

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

### -UseHTTP
{{Fill UseHTTP Description}}

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

### -UseNTLM
{{Fill UseNTLM Description}}

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

### -UserAgent
{{Fill UserAgent Description}}

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

### -UserName
{{Fill UserName Description}}

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

### -WebDavAuthentication
{{Fill WebDavAuthentication Description}}

```yaml
Type: AMWebDavAuthentication
Parameter Sets: (All)
Aliases:
Accepted values: Basic, Default, Form

Required: False
Position: 29
Default value: Basic
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
Position: 30
Default value: [string]::Empty
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
Position: 31
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
Position: 32
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
Date Modified  : 08/14/2018

## RELATED LINKS

[https://github.com/davidseibel/AutoMatePS](https://github.com/davidseibel/AutoMatePS)

