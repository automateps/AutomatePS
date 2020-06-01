function Set-AMSnmpCondition {
    <#
        .SYNOPSIS
            Sets properties of an Automate SNMP condition.

        .DESCRIPTION
            Set-AMSnmpCondition modifies an existing SNMP condition.

        .PARAMETER InputObject
            The condition to modify.

        .PARAMETER IPStart
            The starting IP address to filter SNMP requests from. Use "Any" for any IP address (default).

        .PARAMETER IPEnd
            The ending IP address to filter SNMP requests from. Use "Any" for any IP address (default).

        .PARAMETER Community
            Specifies whether the condition will start the task when a trap is received from a device from any community (default) or only devices within a specific community.

        .PARAMETER Enterprise
            Specifies whether the condition will start the task when a trap is received from any Enterprise OID device (default) or only devices within a specific Enterprise OID.

        .PARAMETER GenericType
            Specifies that the condition will filter out traps that are not intended for a specific generic type and act on traps received only from a specific generic type.

        .PARAMETER OIDStringNotation
            If specified, IODs will be entered as string notations.

        .PARAMETER TimetickStringNotation
            If specified, timetick values will be entered as string notations.

        .PARAMETER AcceptUnathenticatedTrap
            If specified, version 3 traps will be accepted.

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

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="Default",SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [string]$IPStart,
        [string]$IPEnd,
        [string]$Community,
        [string]$Enterprise,

        [ValidateNotNullOrEmpty()]
        [AMSnmpGenericType]$GenericType,
        [switch]$OIDStringNotation,
        [switch]$TimetickStringNotation,
        [switch]$AcceptUnathenticatedTrap,

        [ValidateNotNullOrEmpty()]
        [switch]$Wait,

        [ValidateNotNullOrEmpty()]
        [int]$Timeout,

        [ValidateNotNullOrEmpty()]
        [AMTimeMeasure]$TimeoutUnit,

        [ValidateNotNullOrEmpty()]
        [int]$TriggerAfter,

        [AllowEmptyString()]
        [string]$Notes,

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::SNMPTrap) {
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
