function Set-AMSnmpConditionCredential {
    <#
        .SYNOPSIS
            Modifies an Automate SNMP condition credential.

        .DESCRIPTION
            Set-AMSnmpConditionCredential modifies a credential in an Automate SNMP condition.

        .PARAMETER InputObject
            The SNMP condition object to add the credential to.

        .PARAMETER ID
            The ID of the credential.

        .PARAMETER User
            The username used to accept authenticated traps.

        .PARAMETER AuthenticationPassword
            The password for the specified user.

        .PARAMETER EncryptionAlgorithm
            The type encryption to use.

        .PARAMETER PrivacyPassword
            The encryption password.

        .EXAMPLE
            Get-AMCondition "window" | Set-AMSnmpConditionCredential -ID "{0cee39da-1f6c-424b-a9bd-eeaf17cbd1f2}" -User john

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMSnmpConditionCredential.md
    #>
    [CmdletBinding(DefaultParameterSetName="Default",SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true)]
        $ID,

        $User,
        #$AuthenticationPassword,
        [AMEncryptionAlgorithm]$EncryptionAlgorithm = [AMEncryptionAlgorithm]::NoEncryption
        #$PrivacyPassword
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if (($obj.Type -eq "Condition") -and ($obj.TriggerType -eq [AMTriggerType]::SNMPTrap)) {
                $updateObject = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                foreach ($credential in $updateObject.Credentials | Where-Object {$_.ID -eq $ID}) {
                    if ($PSBoundParameters.ContainsKey("User") -and ($credential.User -ne $User)) {
                        $credential.User = $User
                        $shouldUpdate = $true
                    }
                    <#if ($PSBoundParameters.ContainsKey("AuthenticationPassword") -and ($credential.AuthenticationPassword -ne $AuthenticationPassword)) {
                        $credential.AuthenticationPassword = $AuthenticationPassword
                        $shouldUpdate = $true
                    }#>
                    if ($PSBoundParameters.ContainsKey("EncryptionAlgorithm") -and ($credential.EncryptionAlgorithm -ne $EncryptionAlgorithm)) {
                        $credential.EncryptionAlgorithm = $EncryptionAlgorithm
                        $shouldUpdate = $true
                    }
                    <#if ($PSBoundParameters.ContainsKey("PrivacyPassword") -and ($credential.PrivacyPassword -ne $PrivacyPassword)) {
                        $credential.PrivacyPassword = $PrivacyPassword
                        $shouldUpdate = $true
                    }#>
                }
                if ($shouldUpdate) {
                    $updateObject | Set-AMObject
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}
