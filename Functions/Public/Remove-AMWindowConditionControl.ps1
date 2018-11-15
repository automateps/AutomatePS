function Remove-AMWindowConditionControl {
    <#
        .SYNOPSIS
            Removes a control from an AutoMate Enterprise window condition.

        .DESCRIPTION
            Remove-AMWindowConditionControl removes a control from an AutoMate Enterprise window condition.

        .PARAMETER InputObject
            The window condition object to remove the control from.

        .PARAMETER ID
            The ID of the window control.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Condition

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMCondition "window" | Remove-AMWindowConditionControl -ID "{5ccaab49-012a-48db-b186-696061e20a2c}"

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
            if (($obj.Type -eq "Condition") -and ($obj.TriggerType -eq [AMTriggerType]::Window)) {
                $updateObject = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                if ((($updateObject.WindowControl | Where-Object {$_.ID -ne $ID}) | Measure-Object).Count -gt 0) {
                    $updateObject.WindowControl = @($updateObject.WindowControl | Where-Object {$_.ID -ne $ID})
                } else {
                    $updateObject.WindowControl = @()
                }
                if ($updateObject.WindowControl.Count -eq 0) {
                    $updateObject.ContainsControls = $false
                }
                $updateObject | Set-AMObject
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}