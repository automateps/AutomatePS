function Set-AMAgentProperty {
    <#
        .SYNOPSIS
            Sets the properties of an AutoMate Enterprise agent.

        .DESCRIPTION
            Set-AMAgentProperty modifies agent properties.

        .PARAMETER InputObject
            The agent property to modify.

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/27/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
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
                    Invoke-AMRestMethod @splat | Out-Null
                    Write-Verbose "Modified $($obj.Type) for $($parent.Type): $(Join-Path -Path $parent.Path -ChildPath $parent.Name)."
                } else {
                    Write-Verbose "$($obj.Type) for $($parent.Type) '$($parent.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
