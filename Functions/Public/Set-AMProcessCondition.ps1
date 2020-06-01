function Set-AMProcessCondition {
    <#
        .SYNOPSIS
            Sets properties of an Automate process condition.

        .DESCRIPTION
            Set-AMProcessCondition modifies an existing process condition.

        .PARAMETER InputObject
            The condition to modify.

        .PARAMETER ProcessName
            The name of the process.

        .PARAMETER Action
            The state of the process to trigger on.

        .PARAMETER TriggerOnce
            Only trigger the first time the process is started or stopped.

        .PARAMETER Started
            Only trigger when the process was running prior to the condition and is then stopped.

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

        [ValidateNotNullOrEmpty()]
        [string]$ProcessName,

        [ValidateNotNullOrEmpty()]
        [AMProcessTriggerState]$Action = [AMProcessTriggerState]::StoppedResponding,
        [switch]$TriggerOnce = $false,
        [switch]$Started = $false,
        [switch]$Wait = $true,

        [ValidateNotNullOrEmpty()]
        [int]$Timeout = 0,

        [ValidateNotNullOrEmpty()]
        [AMTimeMeasure]$TimeoutUnit = [AMTimeMeasure]::Seconds,

        [ValidateNotNullOrEmpty()]
        [int]$TriggerAfter = 1,

        [AllowEmptyString()]
        [string]$Notes,

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::Process) {
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
