function New-AMEmailCondition {
    <#
        .SYNOPSIS
            Creates a new Automate Email condition.

        .DESCRIPTION
            New-AMEmailCondition creates a new Email condition.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER AllowRedirection
			Allow redirection to occur.

		.PARAMETER AuthType
			Specifies the authentication type to administer.

		.PARAMETER AuthenticationType
			Specifies the authentication type to administer.

		.PARAMETER AutoDiscover
			Automatically discover the server based on the email address entered in the EmailAddress parameter.

		.PARAMETER Certificate
			The certificate to use.

		.PARAMETER CertificatePath
			The full path and file name of the certificate (.cer or .pfx extension) used to authenticate with.

		.PARAMETER ConnectionType
			The connection type.

		.PARAMETER CurrentFolder
			Specifies the current mailbox folder that this trigger should monitor.

		.PARAMETER DomainName
			The domain name to authenticate with.

		.PARAMETER EWSUseDefault
			Use EWS.

		.PARAMETER EmailAddress
			The Exchange server email address to use for email transactions.

		.PARAMETER EmailFilterType
			The type of filter to use: Sent or Received.

		.PARAMETER ExchangeVersion
			The Exchange server version.

		.PARAMETER ExternalEWSUrl
			The EWS URL.

		.PARAMETER HasMailBoxURL
			Whether mailbox URL is specified.

		.PARAMETER HttpProtocol
			HTTP or HTTPS.

		.PARAMETER IgnoreCertificate
			Invalid or expired SSL certificates that are detected will be ignored.

		.PARAMETER IgnoreServerCertificate
			Invalid or expired SSL server certificates that are detected will be ignored.

		.PARAMETER Impersonate
			Impersonate access as the specified user.

		.PARAMETER MailBoxURL
			The URL for the mailbox.

		.PARAMETER PollingInterval
			The polling interval.

		.PARAMETER Port
			The port for the email server.

		.PARAMETER ProtocolType
			The email server type.

		.PARAMETER ProxyPort
			The port used to communicate with the proxy server.

		.PARAMETER ProxyServer
			The hostname of IP address of the proxy server.

		.PARAMETER ProxyType
			The proxy protocol used to accept requests from clients in your network.

		.PARAMETER ProxyUserName
			The username used to authenticate connection to the proxy server.

		.PARAMETER Security
			The security type.

		.PARAMETER Server
			The email server.

		.PARAMETER UseAutoDiscovery
			Automatically discover the server based on the email address entered in the EmailAddress parameter.

		.PARAMETER UseForm
			Use form authentication.

		.PARAMETER UseHTTP
			Use HTTP.

		.PARAMETER UseNTLM
			Use NTLM authentication.

		.PARAMETER UserAgent
			The user agent.

		.PARAMETER UserName
			The user name.

		.PARAMETER WebDavAuthentication
			The WebDAV authentication type.

        .PARAMETER Wait
            Wait for the condition, or evaluate immediately.

        .PARAMETER Timeout
            If wait is specified, the amount of time before the condition times out.

        .PARAMETER TimeoutUnit
            The unit for Timeout (Seconds by default).

        .PARAMETER TriggerAfter
            The number of times the condition should occur before the trigger fires.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMEmailCondition.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [switch]$Wait = $true,
        [int]$Timeout = 0,
        [AMTimeMeasure]$TimeoutUnit = [AMTimeMeasure]::Seconds,
        [int]$TriggerAfter = 1,

        [switch]$AllowRedirection = $false,
        [string]$AuthType = "Auto",
        [string]$AuthenticationType = "Auto",
        [switch]$AutoDiscover = $false,
        [string]$Certificate,
        [string]$CertificatePath,
        [AMConnectionType]$ConnectionType = [AMConnectionType]::System,
        [string]$CurrentFolder = "Inbox",
        [string]$DomainName,
        [switch]$EWSUseDefault = $false,
        [string]$EmailAddress,
        [AMEmailFilterType]$EmailFilterType = [AMEmailFilterType]::Received,
        [string]$ExchangeVersion,
        [string]$ExternalEWSUrl,
        [switch]$HasMailBoxURL = $false,
        [AMHttpProtocol]$HttpProtocol     = [AMHttpProtocol]::HTTPS,
        [switch]$IgnoreCertificate = $false,
        [switch]$IgnoreServerCertificate = $false,
        [switch]$Impersonate = $false,
        [string]$MailBoxURL,
        #[string]$Passphrase,
        #[string]$Password,
        [int]$PollingInterval = 10,
        [string]$Port,
        [AMGetEmailProtocol]$ProtocolType = [AMGetEmailProtocol]::EWS,
        #[string]$ProxyPassword,
        [string]$ProxyPort,
        [string]$ProxyServer,
        [AMProxyType]$ProxyType = [AMProxyType]::NoProxy,
        [string]$ProxyUserName,
        [AMSecurityType]$Security = [AMSecurityType]::None,
        [string]$Server,
        [switch]$UseAutoDiscovery = $false,
        [switch]$UseForm = $false,
        [switch]$UseHTTP = $false,
        [switch]$UseNTLM = $false,
        [string]$UserAgent,
        [string]$UserName,
        [AMWebDavAuthentication]$WebDavAuthentication = [AMWebDavAuthentication]::Basic,

        [string]$Notes = [string]::Empty,

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    switch (($Connection | Measure-Object).Count) {
        1 {
            $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
            if (-not $Folder) { $Folder = $user | Get-AMFolder -Type CONDITIONS } # Place the condition in the users condition folder
            switch ($Connection.Version.Major) {
                11      { $newObject = [AMEmailTriggerv11]::new($Name, $Folder, $Connection.Alias) }
                default { throw "Unsupported server major version: $_!" }
            }
            $newObject.CreatedBy       = $user.ID
            $newObject.Notes           = $Notes
            $newObject.Wait            = $Wait.ToBool()
            if ($newObject.Wait) {
                $newObject.Timeout      = $Timeout
                $newObject.TimeoutUnit  = $TimeoutUnit
                $newObject.TriggerAfter = $TriggerAfter
            }
            $newObject.AllowRedirection        = $AllowRedirection.ToBool()
            $newObject.AuthType                = $AuthType
            $newObject.AuthenticationType      = $AuthenticationType
            $newObject.AutoDiscover            = $AutoDiscover.ToBool()
            $newObject.Certificate             = $Certificate
            $newObject.CertificatePath         = $CertificatePath
            $newObject.ConnectionType          = $ConnectionType
            $newObject.CurrentFolder           = $CurrentFolder
            $newObject.DomainName              = $DomainName
            $newObject.EWSUseDefault           = $EWSUseDefault.ToBool()
            $newObject.EmailAddress            = $EmailAddress
            $newObject.EmailFilterType         = $EmailFilterType
            $newObject.ExchangeVersion         = $ExchangeVersion
            $newObject.ExternalEWSUrl          = $ExternalEWSUrl
            $newObject.HasMailBoxURL           = $HasMailBoxURL.ToBool()
            $newObject.HttpProtocol            = $HttpProtocol
            $newObject.IgnoreCertificate       = $IgnoreCertificate.ToBool()
            $newObject.IgnoreServerCertificate = $IgnoreServerCertificate.ToBool()
            $newObject.Impersonate             = $Impersonate.ToBool()
            $newObject.MailBoxURL              = $MailBoxURL
            $newObject.Passphrase              = $Passphrase
            $newObject.Password                = $Password
            $newObject.PollingInterval         = $PollingInterval
            $newObject.Port                    = $Port
            $newObject.ProtocolType            = $ProtocolType
            $newObject.ProxyPassword           = $ProxyPassword
            $newObject.ProxyPort               = $ProxyPort
            $newObject.ProxyServer             = $ProxyServer
            $newObject.ProxyType               = $ProxyType
            $newObject.ProxyUserName           = $ProxyUserName
            $newObject.Security                = $Security
            $newObject.Server                  = $Server
            $newObject.UseAutoDiscovery        = $UseAutoDiscovery.ToBool()
            $newObject.UseForm                 = $UseForm.ToBool()
            $newObject.UseHTTP                 = $UseHTTP.ToBool()
            $newObject.UseNTLM                 = $UseNTLM.ToBool()
            $newObject.UserAgent               = $UserAgent
            $newObject.UserName                = $UserName
            $newObject.WebDavAuthentication    = $WebDavAuthentication
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple Automate servers are connected, please specify which server to create the new condition on!" }
    }
}
