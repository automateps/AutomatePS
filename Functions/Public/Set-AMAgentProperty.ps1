function Set-AMAgentProperty {
    <#
        .SYNOPSIS
            Sets the properties of an AutoMate Enterprise agent.

        .DESCRIPTION
            Set-AMAgentProperty modifies agent properties.

        .PARAMETER InputObject
            The agent property to modify.

		.PARAMETER DefaultUserPropertiesSpecified
			Whether the default user settings are specified (true) or inherited (false) from the server.

		.PARAMETER DefaultRunAsUserName
			The default user name that agents should use when automatically logging onto or unlocking a workstation.

		.PARAMETER DefaultRunAsPassword
			The default password to be used with the user name specified.

		.PARAMETER DefaultRunAsDomain
			The domain or machine name associated with the user. This parameter can be left blank if the user is not a member of a domain or if there is only one workgroup for the machine.

		.PARAMETER LogonScript
			The keystrokes to use in order for an agent to successfully log onto the workstation when a user is not present. Automate will simulate a user entering these keystrokes onto the Windows Logon screen.

		.PARAMETER UnlockScript
			The keystrokes to use in order for the agent to successfully unlock the workstation. Automate will simulate a user entering these keystrokes in order to successfully unlock a machine.

		.PARAMETER LogonScriptKeystrokeDelay
			The number of milliseconds to pause between each keystroke. By default, Automate will press each key of the key sequence every 200 milliseconds. Adjust this number if keystrokes appear to be missing during the logon or unlock process, which may indicate that they are being typed too quickly.

		.PARAMETER IndicatorsPropertiesSpecified
			Whether the indicator settings are specified (true) or inherited (false) from the server.

		.PARAMETER ShowTrayIcon
			Indicates whether the Automate "A" icon should be displayed in the system tray of the agent machine.

		.PARAMETER ShowTrayIconMenu
			If enabled, allows right-clicks to be performed on the tray icon in order to display a context menu.

		.PARAMETER ShowRunningTaskWindow
			If enabled, the agent computer displays a small indicator window in the lower right-hand corner of the desktop during task execution.

		.PARAMETER RunningTaskWindowWithTitleBar
			If enabled, a title bar is displayed on the Running Task Indicator window.

		.PARAMETER RunningTaskOnTop
			If enabled, puts the Running Task Indicator window on top of all other open windows on the desktop.

		.PARAMETER RunningTaskWindowTransparent
			If enabled, the Running Task Indicator window appears transparent.

		.PARAMETER UseInterruptHotkey
			If enabled, activates the Task interruption hotkey parameter which allows entry of a specific hotkey combination used to interrupt running tasks.

		.PARAMETER InterruptHotkey
			Specifies the hot-key combination to enter in order to suspend one or more running tasks and invoke the a Running Tasks dialog.

		.PARAMETER StagingPropertiesSpecified
			Whether the staging settings are specified (true) or inherited (false) from the server.

		.PARAMETER UseLowestCompletionState
			If enabled, tasks and conditions will execute on the agent only if the completion state is equal to or higher than the one specified.

		.PARAMETER LowestCompletionState
			InDevelopment (default) - Tells the system to run all tasks and conditions currently in development stage (lowest stage) or higher, which basically indicates all tasks and conditions.
            Testing - Tells the system to run all tasks and conditions that are currently in the testing stage or higher.
            Production - Tells the system to run all tasks and conditions currently in the production stage or higher.
            Archive - Tells the system to run all tasks and conditions currently in the archive stage.

		.PARAMETER LoadManagementPropertiesSpecified
			Whether the load management settings are specified (true) or inherited (false) from the server.

		.PARAMETER MaxRunningTasks
			Specifies the maximum number of tasks that should run simultaneously on a given agent.

		.PARAMETER ProxyPropertiesSpecified
			Whether the proxy settings are specified (true) or inherited (false) from the server.

		.PARAMETER SocksType
			The proxy protocol that the proxy server uses to accept requests from Automate Enterprise.

		.PARAMETER ProxyHost
			The host name or host address of the proxy to use.

		.PARAMETER ProxyPort
			The port on the proxy server to use.

		.PARAMETER ProxyUserID
			The user name to authenticate proxy requests.

		.PARAMETER ProxyPassword
			The password to authenticate proxy requests.

		.PARAMETER SNMPPropertiesSpecified
			Whether the SNMP settings are specified (true) or inherited (false) from the server.

		.PARAMETER MIBLocation
			Indicates the directory location of the MIB (Management Information Base) files.

		.PARAMETER SNMPTrapPort
			The port that Automate Enterprise will use to listen for traps using the SNMP Trap Condition.

		.PARAMETER EmailPropertiesSpecified
			Whether the email settings are specified (true) or inherited (false) from the server.

        .PARAMETER EmailProtocol
            The email protocol to communicate with.

		.PARAMETER EmailServer
			The name of the mail server that will send emails generated by Automate Enterprise.

		.PARAMETER EmailPort
			The default port that the mail server uses.

		.PARAMETER EmailAuthenticationType
			Specifies the authentication type to administer.

		.PARAMETER EmailUserName
			Specifies the username that the server authenticates with.

		.PARAMETER EmailPassword
			Specifies the password matching the username that the server authenticates with.

		.PARAMETER EmailSecurity
			The type of security that this action should use.

		.PARAMETER EmailCertificate
			The full path and file name of the certificate (.cer or .pfx extension) used to authenticate with.

		.PARAMETER EmailCertificatePassphrase
			The passphrase used to authenticate the SSL/TLS private key file.

		.PARAMETER EmailIgnoreServerCertificate
			Invalid or expired SSL server certificates that are detected will be ignored.

		.PARAMETER EmailAddress
			The Exchange server email address to use for email transactions.

		.PARAMETER EmailUseAutoDiscovery
			Automatically discover the server based on the email address entered in the EmailAddress parameter.

		.PARAMETER EmailExchangeProtocol
			The protocol to use for email transactions.

		.PARAMETER EmailUrl
			The URL for the email server.

		.PARAMETER EmailDomainName
			The domain name to authenticate with.

		.PARAMETER EmailVersion
			The email server version.

		.PARAMETER EmailProxyType
			The proxy protocol used.

		.PARAMETER EmailProxyServer
			The hostname or IP address of the proxy server.

		.PARAMETER EmailProxyPort
			The port used to communicate with the proxy server.

		.PARAMETER EmailProxyUsername
			The username used to authenticate connection to the proxy server.

		.PARAMETER EmailProxyPassword
			The password used to authenticate the username specified.

		.PARAMETER SystemPropertiesSpecified
			Whether the system settings are specified (true) or inherited (false) from the server.

		.PARAMETER AgentPort
			Specifies the default port that connected agents should use to communicate with the server component.

		.PARAMETER TaskCacheFilePath
			The path to cache task files on the agent.

		.PARAMETER EventMonitorAutoMateStartMode
			The event monitor user context.

		.PARAMETER DisableForegroundTimeout
			If this option is enabled, Windows Foreground Timeout functionality is turned off, allowing Automate to properly bring specific windows into the foreground.

		.PARAMETER EventMonitorUser
			The user to run the event monitor as.

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        # Default User
        [ValidateNotNullOrEmpty()]
        [switch]$DefaultUserPropertiesSpecified,

        [ValidateNotNull()]
        [string]$DefaultRunAsUserName,

        [ValidateNotNull()]
        [string]$DefaultRunAsPassword,

        [ValidateNotNull()]
        [string]$DefaultRunAsDomain,

        [ValidateNotNull()]
        [string]$LogonScript,

        [ValidateNotNull()]
        [string]$UnlockScript,

        [ValidateNotNullOrEmpty()]
        [int]$LogonScriptKeystrokeDelay,

        # Indicator
        [switch]$IndicatorsPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [AMPrefsShowTrayIcon]$ShowTrayIcon,

        [ValidateNotNullOrEmpty()]
        [switch]$ShowTrayIconMenu,

        [ValidateNotNullOrEmpty()]
        [switch]$ShowRunningTaskWindow,

        [ValidateNotNullOrEmpty()]
        [switch]$RunningTaskWindowWithTitleBar,

        [ValidateNotNullOrEmpty()]
        [switch]$RunningTaskOnTop,

        [ValidateNotNullOrEmpty()]
        [switch]$RunningTaskWindowTransparent,

        [ValidateNotNullOrEmpty()]
        [switch]$UseInterruptHotkey,

        [ValidateNotNull()]
        [string]$InterruptHotkey,

        # Staging
        [ValidateNotNullOrEmpty()]
        [switch]$StagingPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [switch]$UseLowestCompletionState,

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$LowestCompletionState,

        # Load Management
        [ValidateNotNullOrEmpty()]
        [switch]$LoadManagementPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [int]$MaxRunningTasks,

        # Proxy
        [ValidateNotNullOrEmpty()]
        [switch]$ProxyPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [AMSocksType]$SocksType,

        [ValidateNotNull()]
        [string]$ProxyHost,

        [ValidateNotNullOrEmpty()]
        [int]$ProxyPort,

        [ValidateNotNull()]
        [string]$ProxyUserID,

        [ValidateNotNull()]
        [string]$ProxyPassword,

        # SNMP
        [ValidateNotNullOrEmpty()]
        [switch]$SNMPPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [string]$MIBLocation,

        [ValidateNotNullOrEmpty()]
        [int]$SNMPTrapPort,

        # Email

        [ValidateNotNullOrEmpty()]
        [switch]$EmailPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [AMSendEmailProtocol]$EmailProtocol,

        [ValidateNotNullOrEmpty()]
        [string]$EmailServer,

        [ValidateNotNullOrEmpty()]
        [int]$EmailPort,

        [ValidateSet("None","Auto","Plain","DigestMD5","CramMD5","Login","Ntlm","GssApi","Basic","Form")]
        [string]$EmailAuthenticationType,

        [ValidateNotNullOrEmpty()]
        [string]$EmailUserName,

        [ValidateNotNullOrEmpty()]
        [string]$EmailPassword,

        [ValidateNotNullOrEmpty()]
        [AMSecurityType]$EmailSecurity,

        [ValidateNotNullOrEmpty()]
        [string]$EmailCertificate,

        [ValidateNotNullOrEmpty()]
        [string]$EmailCertificatePassphrase,

        [ValidateNotNullOrEmpty()]
        [switch]$EmailIgnoreServerCertificate,

        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,

        [ValidateNotNullOrEmpty()]
        [switch]$EmailUseAutoDiscovery,

        [ValidateNotNullOrEmpty()]
        [AMHttpProtocol]$EmailExchangeProtocol,

        [ValidateNotNullOrEmpty()]
        [string]$EmailUrl,

        [ValidateNotNullOrEmpty()]
        [string]$EmailDomainName,

        [ValidateNotNullOrEmpty()]
        [AMEmailVersion]$EmailVersion,

        [ValidateNotNullOrEmpty()]
        [AMProxyType]$EmailProxyType,

        [ValidateNotNullOrEmpty()]
        [string]$EmailProxyServer,

        [ValidateNotNullOrEmpty()]
        [int]$EmailProxyPort,

        [ValidateNotNullOrEmpty()]
        [string]$EmailProxyUsername,

        [ValidateNotNullOrEmpty()]
        [string]$EmailProxyPassword,

        # Miscellaneous
        [ValidateNotNullOrEmpty()]
        [switch]$SystemPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [int]$AgentPort,

        [ValidateNotNullOrEmpty()]
        [string]$TaskCacheFilePath,

        [ValidateNotNullOrEmpty()]
        [AMEventMonitorAutoStartModeType]$EventMonitorAutoMateStartMode,

        [ValidateNotNullOrEmpty()]
        [switch]$DisableForegroundTimeout,

        [ValidateNotNull()]
        [string]$EventMonitorUser
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "AgentProperty") {
                $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
                $parent = Get-AMAgent -ID $obj.ParentID -Connection $obj.ConnectionAlias
                $updateObject = $parent | Get-AMObjectProperty
                $shouldUpdate = $false
                if ($PSBoundParameters.ContainsKey("DefaultRunAsUserName") -and ($updateObject.DefaultRunAsUserName -ne $DefaultRunAsUserName)) {
                    $updateObject.DefaultRunAsUserName = $DefaultRunAsUserName
                    if (-not [string]::IsNullOrEmpty($DefaultRunAsUserName)) {
                        $updateObject.DefaultUserPropertiesSpecified = $true
                    }
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("DefaultRunAsPassword") -and ($updateObject.DefaultRunAsPassword -ne $DefaultRunAsPassword)) {
                    $updateObject.DefaultRunAsPassword = $DefaultRunAsPassword
                    if (-not [string]::IsNullOrEmpty($DefaultRunAsPassword)) {
                        $updateObject.DefaultUserPropertiesSpecified = $true
                    }
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("DefaultRunAsDomain") -and ($updateObject.DefaultRunAsDomain -ne $DefaultRunAsDomain)) {
                    $updateObject.DefaultRunAsDomain = $DefaultRunAsDomain
                    if (-not [string]::IsNullOrEmpty($DefaultRunAsDomain)) {
                        $updateObject.DefaultUserPropertiesSpecified = $true
                    }
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("LogonScript") -and ($updateObject.LogonScript -ne $LogonScript)) {
                    $updateObject.LogonScript = $LogonScript
                    $updateObject.DefaultUserPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("UnlockScript") -and ($updateObject.UnlockScript -ne $UnlockScript)) {
                    $updateObject.UnlockScript = $UnlockScript
                    $updateObject.DefaultUserPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("LogonScriptKeystrokeDelay") -and ($updateObject.LogonScriptKeystrokeDelay -ne $LogonScriptKeystrokeDelay)) {
                    $updateObject.LogonScriptKeystrokeDelay = $LogonScriptKeystrokeDelay
                    $updateObject.DefaultUserPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("DefaultUserPropertiesSpecified") -and ($updateObject.DefaultUserPropertiesSpecified -ne $DefaultUserPropertiesSpecified.ToBool())) {
                    $updateObject.DefaultUserPropertiesSpecified = $DefaultUserPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ShowTrayIcon") -and ($updateObject.ShowTrayIcon -ne $ShowTrayIcon)) {
                    $updateObject.ShowTrayIcon = $ShowTrayIcon
                    $updateObject.IndicatorsPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ShowTrayIconMenu") -and ($updateObject.ShowTrayIconMenu -ne $ShowTrayIconMenu.ToBool())) {
                    $updateObject.ShowTrayIconMenu = $ShowTrayIconMenu.ToBool()
                    $updateObject.IndicatorsPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ShowRunningTaskWindow") -and ($updateObject.ShowRunningTaskWindow -ne $ShowRunningTaskWindow.ToBool())) {
                    $updateObject.ShowRunningTaskWindow = $ShowRunningTaskWindow.ToBool()
                    $updateObject.IndicatorsPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("RunningTaskWindowWithTitleBar") -and ($updateObject.RunningTaskWindowWithTitleBar -ne $RunningTaskWindowWithTitleBar.ToBool())) {
                    $updateObject.RunningTaskWindowWithTitleBar = $RunningTaskWindowWithTitleBar.ToBool()
                    $updateObject.IndicatorsPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("RunningTaskOnTop") -and ($updateObject.RunningTaskOnTop -ne $RunningTaskOnTop.ToBool())) {
                    $updateObject.RunningTaskOnTop = $RunningTaskOnTop.ToBool()
                    $updateObject.IndicatorsPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("RunningTaskWindowTransparent") -and ($updateObject.RunningTaskWindowTransparent -ne $RunningTaskWindowTransparent.ToBool())) {
                    $updateObject.RunningTaskWindowTransparent = $RunningTaskWindowTransparent.ToBool()
                    $updateObject.IndicatorsPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("UseInterruptHotkey") -and ($updateObject.UseInterruptHotkey -ne $UseInterruptHotkey.ToBool())) {
                    $updateObject.UseInterruptHotkey = $UseInterruptHotkey.ToBool()
                    $updateObject.IndicatorsPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("InterruptHotkey") -and ($updateObject.InterruptHotkey -ne $InterruptHotkey)) {
                    $updateObject.InterruptHotkey = $InterruptHotkey
                    $updateObject.IndicatorsPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("IndicatorsPropertiesSpecified") -and ($updateObject.IndicatorsPropertiesSpecified -ne $IndicatorsPropertiesSpecified.ToBool())) {
                    $updateObject.IndicatorsPropertiesSpecified = $IndicatorsPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("UseLowestCompletionState") -and ($updateObject.UseLowestCompletionState -ne $UseLowestCompletionState.ToBool())) {
                    $updateObject.UseLowestCompletionState = $UseLowestCompletionState.ToBool()
                    $updateObject.StagingPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("LowestCompletionState") -and ($updateObject.LowestCompletionState -ne $LowestCompletionState)) {
                    $updateObject.LowestCompletionState = $LowestCompletionState
                    $updateObject.StagingPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("StagingPropertiesSpecified") -and ($updateObject.StagingPropertiesSpecified -ne $StagingPropertiesSpecified.ToBool())) {
                    $updateObject.StagingPropertiesSpecified = $StagingPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("MaxRunningTasks") -and ($updateObject.MaxRunningTasks -ne $MaxRunningTasks)) {
                    $updateObject.MaxRunningTasks = $MaxRunningTasks
                    $updateObject.LoadManagementPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("LoadManagementPropertiesSpecified") -and ($updateObject.LoadManagementPropertiesSpecified -ne $LoadManagementPropertiesSpecified.ToBool())) {
                    $updateObject.LoadManagementPropertiesSpecified = $LoadManagementPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("SocksType") -and ($updateObject.SocksType -ne $SocksType)) {
                    $updateObject.SocksType = $SocksType
                    $updateObject.ProxyPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ProxyHost") -and ($updateObject.ProxyHost -ne $ProxyHost)) {
                    $updateObject.ProxyHost = $ProxyHost
                    $updateObject.ProxyPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ProxyPort") -and ($updateObject.ProxyPort -ne $ProxyPort)) {
                    $updateObject.ProxyPort = $ProxyPort
                    $updateObject.ProxyPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ProxyUserID") -and ($updateObject.ProxyUserID -ne $ProxyUserID)) {
                    $updateObject.ProxyUserID = $ProxyUserID
                    $updateObject.ProxyPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ProxyPassword") -and ($updateObject.ProxyPassword -ne $ProxyPassword)) {
                    $updateObject.ProxyPassword = $ProxyPassword
                    $updateObject.ProxyPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ProxyPropertiesSpecified") -and ($updateObject.ProxyPropertiesSpecified -ne $ProxyPropertiesSpecified.ToBool())) {
                    $updateObject.ProxyPropertiesSpecified = $ProxyPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("MIBLocation") -and ($updateObject.MIBLocation -ne $MIBLocation)) {
                    $updateObject.MIBLocation = $MIBLocation
                    $updateObject.SNMPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("SNMPTrapPort") -and ($updateObject.SNMPTrapPort -ne $SNMPTrapPort)) {
                    $updateObject.SNMPTrapPort = $SNMPTrapPort
                    $updateObject.SNMPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("SNMPPropertiesSpecified") -and ($updateObject.SNMPPropertiesSpecified -ne $SNMPPropertiesSpecified.ToBool())) {
                    $updateObject.SNMPPropertiesSpecified = $SNMPPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailProtocol") -and ($updateObject.ConfigurationConstruct.EmailServer.EmailProtocol -ne $EmailProtocol)) {
                    $updateObject.ConfigurationConstruct.EmailServer.EmailProtocol = $EmailProtocol
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailServer") -and ($updateObject.ConfigurationConstruct.EmailServer.Server -ne $EmailServer)) {
                    $updateObject.ConfigurationConstruct.EmailServer.Server = $EmailServer
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailPort") -and ($updateObject.ConfigurationConstruct.EmailServer.Port -ne $EmailPort)) {
                    $updateObject.ConfigurationConstruct.EmailServer.EmailPort = $EmailPort
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailAuthenticationType") -and ($updateObject.ConfigurationConstruct.EmailServer.AuthenticationType -ne $EmailAuthenticationType)) {
                    $updateObject.ConfigurationConstruct.EmailServer.AuthenticationType = $EmailAuthenticationType
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailAddress") -and ($updateObject.ConfigurationConstruct.EmailServer.EmailAddress -ne $EmailAddress)) {
                    $updateObject.ConfigurationConstruct.EmailServer.EmailAddress = $EmailAddress
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailUserName") -and ($updateObject.ConfigurationConstruct.EmailServer.UserName -ne $EmailUserName)) {
                    $updateObject.ConfigurationConstruct.EmailServer.UserName = $EmailUserName
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailPassword") -and ($updateObject.ConfigurationConstruct.EmailServer.Password -ne $EmailPassword)) {
                    $updateObject.ConfigurationConstruct.EmailServer.Password = $EmailPassword
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailSecurity") -and ($updateObject.ConfigurationConstruct.EmailServer.Security -ne $EmailSecurity)) {
                    $updateObject.ConfigurationConstruct.EmailServer.Security = $EmailSecurity
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailCertificate") -and ($updateObject.ConfigurationConstruct.EmailServer.Certificate -ne $EmailCertificate)) {
                    $updateObject.ConfigurationConstruct.EmailServer.Certificate = $EmailCertificate
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailCertificatePassphrase") -and ($updateObject.ConfigurationConstruct.EmailServer.Passphrase -ne $EmailCertificatePassphrase)) {
                    $updateObject.ConfigurationConstruct.EmailServer.Passphrase = $EmailCertificatePassphrase
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailIgnoreServerCertificate") -and ($updateObject.ConfigurationConstruct.EmailServer.IgnoreServerCertificate -ne $EmailIgnoreServerCertificate.ToBool())) {
                    $updateObject.ConfigurationConstruct.EmailServer.IgnoreServerCertificate = $EmailIgnoreServerCertificate.ToBool()
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailUseAutoDiscovery") -and ($updateObject.ConfigurationConstruct.EmailServer.UseAutoDiscovery -ne $EmailUseAutoDiscovery.ToBool())) {
                    $updateObject.ConfigurationConstruct.EmailServer.UseAutoDiscovery = $EmailUseAutoDiscovery.ToBool()
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailExchangeProtocol") -and ($updateObject.ConfigurationConstruct.EmailServer.Protocol -ne $EmailExchangeProtocol)) {
                    $updateObject.ConfigurationConstruct.EmailServer.Protocol = $EmailExchangeProtocol
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailUrl") -and ($updateObject.ConfigurationConstruct.EmailServer.Url -ne $EmailUrl)) {
                    $updateObject.ConfigurationConstruct.EmailServer.Url = $EmailUrl
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailDomainName") -and ($updateObject.ConfigurationConstruct.EmailServer.DomainName -ne $EmailDomainName)) {
                    $updateObject.ConfigurationConstruct.EmailServer.DomainName = $EmailDomainName
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailVersion") -and ($updateObject.ConfigurationConstruct.EmailServer.Version -ne $EmailVersion)) {
                    $updateObject.ConfigurationConstruct.EmailServer.Version = $EmailVersion
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailProxyType") -and ($updateObject.ConfigurationConstruct.EmailServer.ProxyType -ne $EmailProxyType)) {
                    $updateObject.ConfigurationConstruct.EmailServer.ProxyType = $EmailProxyType
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailProxyServer") -and ($updateObject.ConfigurationConstruct.EmailServer.ProxyServer -ne $EmailProxyServer)) {
                    $updateObject.ConfigurationConstruct.EmailServer.ProxyServer = $EmailProxyServer
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailProxyPort") -and ($updateObject.ConfigurationConstruct.EmailServer.ProxyPort -ne $EmailProxyPort)) {
                    $updateObject.ConfigurationConstruct.EmailServer.ProxyPort = $EmailProxyPort
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailProxyUsername") -and ($updateObject.ConfigurationConstruct.EmailServer.ProxyUsername -ne $EmailProxyUsername)) {
                    $updateObject.ConfigurationConstruct.EmailServer.ProxyUsername = $EmailProxyUsername
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailProxyPassword") -and ($updateObject.ConfigurationConstruct.EmailServer.ProxyPassword -ne $EmailProxyPassword)) {
                    $updateObject.ConfigurationConstruct.EmailServer.ProxyPassword = $EmailProxyPassword
                    $updateObject.SMTPPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EmailPropertiesSpecified") -and ($updateObject.SMTPPropertiesSpecified -ne $EmailPropertiesSpecified.ToBool())) {
                    $updateObject.SMTPPropertiesSpecified = $EmailPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("AgentPort") -and ($updateObject.AgentPort -ne $AgentPort)) {
                    $updateObject.AgentPort = $AgentPort
                    $updateObject.SystemPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("TaskCacheFilePath") -and ($updateObject.TaskCacheFilePath -ne $TaskCacheFilePath)) {
                    $updateObject.TaskCacheFilePath = $TaskCacheFilePath
                    $updateObject.SystemPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EventMonitorAutoMateStartMode") -and ($updateObject.EventMonitorAutoMateStartMode -ne $EventMonitorAutoMateStartMode)) {
                    $updateObject.EventMonitorAutoMateStartMode = $EventMonitorAutoMateStartMode
                    $updateObject.SystemPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("DisableForegroundTimeout") -and ($updateObject.DisableForegroundTimeout -ne $DisableForegroundTimeout.ToBool())) {
                    $updateObject.AgentPort = $DisableForegroundTimeout.ToBool()
                    $updateObject.SystemPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("EventMonitorUser") -and ($updateObject.TerminalServicesUser -ne $EventMonitorUser)) {
                    $updateObject.TerminalServicesUser = $EventMonitorUser
                    $updateObject.SystemPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("SystemPropertiesSpecified") -and ($updateObject.SystemPropertiesSpecified -ne $SystemPropertiesSpecified.ToBool())) {
                    $updateObject.SystemPropertiesSpecified = $SystemPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($shouldUpdate) {
                    $splat = @{
                        Resource = "agents/$($obj.ParentID)/properties/update"
                        RestMethod = "Post"
                        Body = $updateObject.ToJson()
                        Connection = $updateObject.ConnectionAlias
                    }
                    if ($PSCmdlet.ShouldProcess($connection.Name, "Modifying $($obj.Type) for $($parent.Type): $(Join-Path -Path $parent.Path -ChildPath $parent.Name)")) {
                        Invoke-AMRestMethod @splat | Out-Null
                        Write-Verbose "Modified $($obj.Type) for $($parent.Type): $(Join-Path -Path $parent.Path -ChildPath $parent.Name)."
                    }
                } else {
                    Write-Verbose "$($obj.Type) for $($parent.Type) '$($parent.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
