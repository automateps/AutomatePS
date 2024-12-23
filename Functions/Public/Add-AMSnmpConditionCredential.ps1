function Add-AMSnmpConditionCredential {
    <#
        .SYNOPSIS
            Adds a credential to an Automate SNMP condition.

        .DESCRIPTION
            Add-AMSnmpConditionCredential adds a credential to an Automate SNMP condition.

        .PARAMETER InputObject
            The SNMP condition object to add the credential to.

        .PARAMETER User
            The username used to accept authenticated traps.

        .PARAMETER AuthenticationPassword
            The password for the specified user.

        .PARAMETER EncryptionAlgorithm
            The type encryption to use.

        .PARAMETER PrivacyPassword
            The encryption password.

        .INPUTS
            The following Automate object types can be modified by this function:
            Condition

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMCondition "snmp" | Add-AMSnmpConditionCredential -User john

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Add-AMSnmpConditionCredential.md
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        $User,
        #$AuthenticationPassword,
        [AMEncryptionAlgorithm]$EncryptionAlgorithm = [AMEncryptionAlgorithm]::NoEncryption
        #$PrivacyPassword
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if (($obj.Type -eq "Condition") -and ($obj.TriggerType -eq [AMTriggerType]::SNMPTrap)) {
                $updateObject = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                switch ((Get-AMConnection -ConnectionAlias $obj.ConnectionAlias).Version.Major) {
                    10                   { $credential = [AMSNMPTriggerCredentialv10]::new() }
                    {$_ -in 11,22,23,24} { $credential = [AMSNMPTriggerCredentialv11]::new() }
                    default { throw "Unsupported server major version: $_!" }
                }
                if ($PSBoundParameters.ContainsKey("User")) {
                    $credential.User = $User
                }
                <#if ($PSBoundParameters.ContainsKey("AuthenticationPassword")) {
                    $credential.AuthenticationPassword = $AuthenticationPassword
                }#>
                if ($PSBoundParameters.ContainsKey("EncryptionAlgorithm")) {
                    $credential.EncryptionAlgorithm = $EncryptionAlgorithm
                }
                <#if ($PSBoundParameters.ContainsKey("PrivacyPassword")) {
                    $credential.PrivacyPassword = $PrivacyPassword
                }#>
                $updateObject.Credentials += $credential
                $updateObject | Set-AMObject
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}
