function New-AMEmailCondition {
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise Email condition.

        .DESCRIPTION
            New-AMEmailCondition creates a new Email condition.

        .PARAMETER Name
            The name of the new object.

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

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param(
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

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState = [AMCompletionState]::Production,

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    if (($Connection | Measure-Object).Count -gt 1) {
        throw "Multiple AutoMate Servers are connected, please specify which server to create the new email condition on!"
    }

    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
    if (-not $Folder) {
        # Place the task in the users condition folder
        $Folder = $user | Get-AMFolder -Type CONDITIONS
    }

    switch ($Connection.Version.Major) {
        11      { $newObject = [AMEmailTriggerv11]::new($Name, $Folder, $Connection.Alias) }
        default { throw "Unsupported server major version: $_!" }
    }
    $newObject.CompletionState = $CompletionState
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
    Get-AMCondition -ID $newObject.ID -Connection $Connection
}
