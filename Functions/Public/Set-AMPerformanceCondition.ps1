function Set-AMPerformanceCondition {
    <#
        .SYNOPSIS
            Sets properties of an Automate performance condition.

        .DESCRIPTION
            Set-AMPerformanceCondition modifies an existing performance condition.

        .PARAMETER InputObject
            The condition to modify.

        .PARAMETER MachineName
            The computer to check performance counters on.

        .PARAMETER CategoryName
            The system category in which to monitor (i.e. Processor, Memory, Paging File, etc.). A category catalogues performance counters in a logical unit.

        .PARAMETER CounterName
            The type of counter related to the category in which to monitor. Performance counters are combined together under categories. They are used to measure various aspects of performance, such as transfer rates for disks or, for processors, the amount of processor time consumed. Specific counters are populated in this section depending on the performance category selected.

        .PARAMETER InstanceName
            The instance related to the category in which to monitor. A performance counter can be divided into instances, such as processes, threads, or physical units.

        .PARAMETER Operator
            Above or Below.

        .PARAMETER Amount
            The threshold to trigger on.

        .PARAMETER TimePeriod
            The amount of time to wait before triggering.

        .PARAMETER TimePeriodUnit
            The unit of time for TriggerWhenTimePeriod.

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
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [string]$MachineName = "",

        [ValidateNotNullOrEmpty()]
        [string]$CategoryName,

        [ValidateNotNullOrEmpty()]
        [string]$CounterName,

        [ValidateNotNullOrEmpty()]
        [string]$InstanceName,

        [ValidateNotNullOrEmpty()]
        [AMPerformanceOperator]$Operator,

        [ValidateNotNullOrEmpty()]
        [int]$Amount,

        [ValidateNotNullOrEmpty()]
        [int]$TimePeriod,

        [ValidateNotNullOrEmpty()]
        [AMTimeMeasure]$TimePeriodUnit,

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
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::Performance) {
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
