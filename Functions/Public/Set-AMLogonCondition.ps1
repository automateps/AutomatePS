function Set-AMLogonCondition {
    <#
        .SYNOPSIS
            Sets properties of an Automate logon condition.

        .DESCRIPTION
            Set-AMLogonCondition modifies an existing logon condition.

        .PARAMETER InputObject
            The condition to modify.

        .PARAMETER User
            The user(s) to wait to logon.  Use $null for all users.

        .PARAMETER Wait
            Wait for the condition, or evaluate immediately.

        .PARAMETER Timeout
            If wait is specified, the amount of time before the condition times out.

        .PARAMETER TimeoutUnit
            The unit for Timeout (Seconds by default).

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMLogonCondition.md
    #>
    [CmdletBinding(DefaultParameterSetName="Default",SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [string[]]$User = @(),

        [ValidateNotNullOrEmpty()]
        [switch]$Wait,

        [ValidateNotNullOrEmpty()]
        [int]$Timeout,

        [ValidateNotNullOrEmpty()]
        [AMTimeMeasure]$TimeoutUnit,

        [AllowEmptyString()]
        [string]$Notes,

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::Logon) {
                $update = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                if ($PSBoundParameters.ContainsKey("User")) {
                    if (($User.Count -eq 1) -and ($User[0] -like "*;*")) {
                        $User = $User[0].Split(";")
                    } elseif ($null -eq $User) {
                        $User = @()
                    }
                    if ((($update.User | Sort-Object) -join ",") -ne (($User | Sort-Object) -join ",")) {
                        $update.User = $User
                        $shouldUpdate = $true
                    }
                }
                if (($PSBoundParameters.ContainsKey("Wait")) -and ($update.Wait -ne $Wait.ToBool())) {
                    $update.Wait = $Wait.ToBool()
                    $shouldUpdate = $true
                }
                if (($PSBoundParameters.ContainsKey("Timeout")) -and ($update.Timeout -ne $Timeout)) {
                    $update.Timeout = $Timeout
                    $shouldUpdate = $true
                }
                if (($PSBoundParameters.ContainsKey("TimeoutUnit")) -and ($update.TimeoutUnit -ne $TimeoutUnit)) {
                    $update.TimeoutUnit = $TimeoutUnit
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
