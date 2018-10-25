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
Allow redirection to occur.

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
Specifies the authentication type to administer.

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
Specifies the authentication type to administer.

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

### -Certificate
The certificate to use.

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
The full path and file name of the certificate (.cer or .pfx extension) used to authenticate with.

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
The connection type.

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
Specifies the current mailbox folder that this trigger should monitor.

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
The domain name to authenticate with.

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
Use EWS.

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
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailFilterType
The type of filter to use: Sent or Received.

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
The Exchange server version.

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
The EWS URL.

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
Whether mailbox URL is specified.

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
HTTP or HTTPS.

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
Invalid or expired SSL certificates that are detected will be ignored.

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

### -Impersonate
Impersonate access as the specified user.

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
The URL for the mailbox.

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
The polling interval.

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
The port for the email server.

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
The email server type.

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
The port used to communicate with the proxy server.

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
The hostname of IP address of the proxy server.

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
The proxy protocol used to accept requests from clients in your network.

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
The username used to authenticate connection to the proxy server.

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
The security type.

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
The email server.

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

### -UseForm
Use form authentication.

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
Use HTTP.

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
Use NTLM authentication.

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
The user agent.

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
The user name.

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
The WebDAV authentication type.

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

