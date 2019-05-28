function Set-AMKeyboardCondition {
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise keyboard condition.

        .DESCRIPTION
            Set-AMKeyboardCondition modifies an existing keyboard condition.

        .PARAMETER InputObject
            The condition to modify.

        .PARAMETER Hotkey
            The hotkey to trigger the condition.

        .PARAMETER HotkeyPassthrough
            Allow hotkey to continue to the application.

        .PARAMETER Text
            The text to trigger the condition.

        .PARAMETER EraseText
            Erase text afterwards.

        .PARAMETER Process
            Only run when the specified process is active.

        .PARAMETER ProcessFocused
            The process window must be focused.

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

        [Parameter(ParameterSetName="Hotkey")]
        [ValidateNotNullOrEmpty()]
        [string]$Hotkey,

        [Parameter(ParameterSetName="Hotkey")]
        [switch]$HotkeyPassthrough,

        [Parameter(ParameterSetName="Text")]
        [ValidateNotNullOrEmpty()]
        [string]$Text,

        [Parameter(ParameterSetName="Text")]
        [switch]$EraseText,

        [ValidateNotNullOrEmpty()]
        [string]$Process,
        [switch]$ProcessFocused,

        [AllowEmptyString()]
        [string]$Notes,

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::Keyboard) {
                $update = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                switch ($PSCmdlet.ParameterSetName) {
                    "Hotkey" {
                        $update.KeyType = [AMKeyboardConditionKeyType]::Hotkey
                        if (($PSBoundParameters.ContainsKey("Hotkey")) -and ($update.Keys -ne $Hotkey)) {
                            $update.Keys = $Hotkey
                            $shouldUpdate = $true
                        }
                        if (($PSBoundParameters.ContainsKey("HotkeyPassthrough")) -and ($update.PassThrough -ne $HotkeyPassthrough.ToBool())) {
                            $update.PassThrough = $HotkeyPassthrough.ToBool()
                            $shouldUpdate = $true
                        }
                    }
                    "Text" {
                        $update.KeyType = [AMKeyboardConditionKeyType]::Text
                        if (($PSBoundParameters.ContainsKey("Text")) -and ($update.Keys -ne $Text)) {
                            $update.Keys = $Text
                            $shouldUpdate = $true
                        }
                        if (($PSBoundParameters.ContainsKey("EraseText")) -and ($update.EraseText -ne $EraseText.ToBool())) {
                            $update.EraseText = $EraseText.ToBool()
                            $shouldUpdate = $true
                        }
                    }
                }
                if (($PSBoundParameters.ContainsKey("Process")) -and ($update.Process -ne $Process)) {
                    $update.Process = $Process
                    $shouldUpdate = $true
                }
                if (($PSBoundParameters.ContainsKey("ProcessFocused")) -and ($update.Foreground -ne $ProcessFocused.ToBool())) {
                    $update.Foreground = $ProcessFocused.ToBool()
                    $shouldUpdate = $true
                }
                if (($PSBoundParameters.ContainsKey("Notes")) -and ($update.Notes -ne $Notes)) {
                    $update.Notes = $Notes
                    $shouldUpdate = $true
                }
                if (($PSBoundParameters.ContainsKey("CompletionState")) -and ($update.CompletionState -ne $CompletionState)) {
                    $update.CompletionState = $CompletionState
                    $shouldUpdate = $true
                }

                if ($shouldUpdate) {
                    $update | Set-AMObject
                } else {
                    Write-Verbose "$($obj.Type) '$($obj.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' and trigger type '$($obj.TriggerType)' encountered!" -TargetObject $obj
            }
        }
    }
}
