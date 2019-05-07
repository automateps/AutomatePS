function Remove-AMEmailConditionFilter {
    <#
        .SYNOPSIS
            Removes an email filter from an AutoMate Enterprise Email condition.

        .DESCRIPTION
            Remove-AMEmailConditionFilter removes an email filter from an AutoMate Enterprise Email condition.

        .PARAMETER InputObject
            The Email condition object to remove the filter from.

        .PARAMETER ID
            The ID of the email filter.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Condition

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMCondition "email" | Remove-AMEmailConditionFilter -ID "{5ccaab49-012a-48db-b186-696061e20a2c}"

        .LINK
            https://github.com/AutomatePS/AutomatePS
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
                if ((($updateObject.EmailFilters | Where-Object {$_.ID -ne $ID}) | Measure-Object).Count -gt 0) {
                    $updateObject.EmailFilters = @($updateObject.EmailFilters | Where-Object {$_.ID -ne $ID})
                } else {
                    $updateObject.EmailFilters = @()
                }
                $updateObject | Set-AMObject
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}