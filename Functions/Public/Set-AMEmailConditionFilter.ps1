function Set-AMEmailConditionFilter {
    <#
        .SYNOPSIS
            Modifies an AutoMate Enterprise Email condition filter.

        .DESCRIPTION
            Set-AMEmailConditionFilter modifies a filter in an AutoMate Enterprise Email condition.

        .PARAMETER InputObject
            The SNMP condition object to add the credential to.

        .PARAMETER ID
            The ID of the credential.

        .EXAMPLE
            Get-AMCondition "window" | Set-AMSnmpConditionCredential -ID "{0cee39da-1f6c-424b-a9bd-eeaf17cbd1f2}" -User david

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName="Default",SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $ID
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if (($obj.Type -eq "Condition") -and ($obj.TriggerType -eq [AMTriggerType]::Email)) {
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
