function Set-AMEmailCondition {
    <#
        .SYNOPSIS
            Sets properties of an Automate Email condition.

        .DESCRIPTION
            Set-AMEmailCondition modifies an existing Email condition.

        .PARAMETER InputObject
            The condition to modify.

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

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMEmailCondition.md
    #>
    [CmdletBinding(DefaultParameterSetName="Default",SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [switch]$Wait,

        [ValidateNotNullOrEmpty()]
        [int]$Timeout,

        [ValidateNotNullOrEmpty()]
        [AMTimeMeasure]$TimeoutUnit,

        [ValidateNotNullOrEmpty()]
        [int]$TriggerAfter,

        [switch]$AllowRedirection,
        [string]$AuthType,
        [string]$AuthenticationType,
        [switch]$AutoDiscover,
        [string]$Certificate,
        [string]$CertificatePath,
        [AMConnectionType]$ConnectionType,
        [string]$CurrentFolder,
        [string]$DomainName,
        [switch]$EWSUseDefault,
        [string]$EmailAddress,
        [AMEmailFilterType]$EmailFilterType,
        [string]$ExchangeVersion,
        [string]$ExternalEWSUrl,
        [switch]$HasMailBoxURL,
        [AMHttpProtocol]$HttpProtocol,
        [switch]$IgnoreCertificate,
        [switch]$IgnoreServerCertificate,
        [switch]$Impersonate,
        [string]$MailBoxURL,
        #[string]$Passphrase,
        #[string]$Password,
        [int]$PollingInterval,
        [string]$Port,
        [AMGetEmailProtocol]$ProtocolType,
        #[string]$ProxyPassword,
        [string]$ProxyPort,
        [string]$ProxyServer,
        [AMProxyType]$ProxyType,
        [string]$ProxyUserName,
        [AMSecurityType]$Security,
        [string]$Server,
        [switch]$UseAutoDiscovery,
        [switch]$UseForm,
        [switch]$UseHTTP,
        [switch]$UseNTLM,
        [string]$UserAgent,
        [string]$UserName,
        [AMWebDavAuthentication]$WebDavAuthentication,

        [AllowEmptyString()]
        [string]$Notes,

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::Email) {
                $updateObject = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                $boundParameterKeys = $PSBoundParameters.Keys | Where-Object {($_ -ne "InputObject") -and `
                                                                              ($_ -notin [System.Management.Automation.PSCmdlet]::CommonParameters) -and `
                                                                              ($_ -notin [System.Management.Automation.PSCmdlet]::OptionalCommonParameters)}
                foreach ($boundParameterKey in $boundParameterKeys) {
                    $property = $boundParameterKey
                    $value = $PSBoundParameters[$property]

                    # Handle special property types
                    if ($value -is [System.Management.Automation.SwitchParameter]) { $value = $value.ToBool() }

                    # Compare and change properties
                    if ($updateObject."$property" -ne $value) {
                        $updateObject."$property" = $value
                        $shouldUpdate = $true
                    }
                }

                if ($shouldUpdate) {
                    $updateObject | Set-AMObject
                } else {
                    Write-Verbose "$($obj.Type) '$($obj.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}
