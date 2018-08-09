function New-AMWindowCondition {    
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise window condition.

        .DESCRIPTION
            New-AMWindowCondition creates a new window condition.

        .PARAMETER Name
            The name of the new object.

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

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [AMWindowAction]$Action = [AMWindowAction]::Open,
        [switch]$TriggerOnce = $false,
        [switch]$HoldFocus = $true,
        [string]$Title = "*",
        [string]$Class = "*",
        [string]$Handle = "0",
        [switch]$ChildWindow = $false,
        [int]$Delay = 1000,

        [switch]$Wait = $true,
        [int]$Timeout = 0,
        [AMTimeMeasure]$TimeoutUnit = [AMTimeMeasure]::Seconds,
        [int]$TriggerAfter = 1,

        [string]$Notes = "",

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState = [AMCompletionState]::Production,

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    if (($Connection | Measure-Object).Count -gt 1) {
        throw "Multiple AutoMate Servers are connected, please specify which server to create the new window condition on!"
    }

    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
    if (-not $Folder) {
        # Place the task in the users condition folder
        $Folder = $user | Get-AMFolder -Type CONDITIONS
    }

    switch ($Connection.Version.Major) {
        10      { $newObject = [AMWindowTriggerv10]::new($Name, $Folder, $Connection.Alias) }
        11      { $newObject = [AMWindowTriggerv11]::new($Name, $Folder, $Connection.Alias) }
        default { throw "Unsupported server major version: $_!" }
    }
    $newObject.CompletionState = $CompletionState
    $newObject.CreatedBy       = $user.ID
    $newObject.Notes           = $Notes
    $newObject.Wait            = $Wait.ToBool()
    if ($newObject.Wait) {
        $newObject.Timeout      = $Timeout
        $newObject.TimeoutUnit  = $TimeoutUnit
        $newObject.TriggerAfter = $TriggerAfter
    }
    $newObject.Action      = $Action
    $newObject.TriggerOnce = $TriggerOnce.ToBool()
    $newObject.HoldFocus   = $HoldFocus.ToBool()
    $newObject.Title       = $Title
    $newObject.Class       = $Class
    $newObject.Handle      = $Handle
    $newObject.ChildWindow = $ChildWindow.ToBool()
    $newObject.Delay       = $Delay
    $newObject | New-AMObject -Connection $Connection
    Get-AMCondition -ID $newObject.ID -Connection $Connection
}
