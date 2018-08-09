function Set-AMEmailCondition {
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise Email condition.

        .DESCRIPTION
            Set-AMEmailCondition modifies an existing Email condition.

        .PARAMETER InputObject
            The condition to modify.

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

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium',DefaultParameterSetName='Default')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
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
