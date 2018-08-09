function Set-AMWindowCondition {    
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise window condition.

        .DESCRIPTION
            Set-AMWindowCondition modifies an existing window condition.

        .PARAMETER InputObject
            The condition to modify.

        .PARAMETER Action
            Specifies the window state to monitor.

        .PARAMETER TriggerOnce
            If enabled, specifies that the action to be performed on the window being monitored will occur only once when that window first opens and ignore other instances.

        .PARAMETER HoldFocus
            If specified, holds the window in focus.

        .PARAMETER Title
            Specifies the title of the window to monitor. The value is not case sensitive.

        .PARAMETER Class
            Specifies the class of the window to monitor.

        .PARAMETER Handle
            Specifies the handle of the window to monitor. A window handle is code that uniquely identifies an open window (disabled by default).

        .PARAMETER ChildWindow
            If enabled, specifies that the window to monitor is a child window. A child window is normally a secondary window on screen that is displayed within the main overall window of the application. This option is available only when the Action parameter is set to Wait for window to be focused or Wait for window to not be focused.

        .PARAMETER Delay
            Use a delay (in milliseconds) to prevent this condition from checking a window's condition immediately.

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

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium',DefaultParameterSetName='Default')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [AMWindowAction]$Action,
        [switch]$TriggerOnce,
        [switch]$HoldFocus,
        [string]$Title,
        [string]$Class,
        [string]$Handle,
        [switch]$ChildWindow,

        [ValidateNotNullOrEmpty()]
        [int]$Delay,

        [switch]$Wait,

        [ValidateNotNullOrEmpty()]
        [int]$Timeout,

        [ValidateNotNullOrEmpty()]
        [AMTimeMeasure]$TimeoutUnit,

        [ValidateNotNullOrEmpty()]
        [int]$TriggerAfter,

        [string]$Notes,

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::Window) {
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
