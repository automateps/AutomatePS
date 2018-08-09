function Add-AMSnmpConditionCredential {    
    <#
        .SYNOPSIS
            Adds a credential to an AutoMate Enterprise SNMP condition.

        .DESCRIPTION
            Add-AMSnmpConditionCredential adds a credential to an AutoMate Enterprise SNMP condition.

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
            The following AutoMate object types can be modified by this function:
            Condition

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMCondition "snmp" | Add-AMSnmpConditionCredential -User david

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
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
                switch ((Get-AMConnection $obj.ConnectionAlias).Version.Major) {
                    10      { $credential = [AMSNMPTriggerCredentialv10]::new() }
                    11      { $credential = [AMSNMPTriggerCredentialv11]::new() }
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
