function Remove-AMSnmpConditionCredential {
    <#
        .SYNOPSIS
            Removes a credential from an Automate SNMP condition.

        .DESCRIPTION
            Remove-AMSnmpConditionCredential removes a credential from an Automate SNMP condition.

        .PARAMETER InputObject
            The SNMP condition object to remove the credential from.

        .PARAMETER ID
            The ID of the credential.

        .INPUTS
            The following Automate object types can be modified by this function:
            Condition

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMCondition "snmp" | Remove-AMSnmpConditionCredential -ID "{5ccaab49-012a-48db-b186-696061e20a2c}"

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMSnmpConditionCredential.md
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
            if (($obj.Type -eq "Condition") -and ($obj.TriggerType -eq [AMTriggerType]::SNMPTrap)) {
                $updateObject = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                if ((($updateObject.Credentials | Where-Object {$_.ID -ne $ID}) | Measure-Object).Count -gt 0) {
                    $updateObject.Credentials = @($updateObject.Credentials | Where-Object {$_.ID -ne $ID})
                } else {
                    $updateObject.Credentials = @()
                }
                $updateObject | Set-AMObject
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}