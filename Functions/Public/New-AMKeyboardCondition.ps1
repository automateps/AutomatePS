function New-AMKeyboardCondition {    
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise keyboard condition.

        .DESCRIPTION
            New-AMKeyboardCondition creates a new keyboard condition.

        .PARAMETER Name
            The name of the new object.

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

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/14/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(ParameterSetName="Hotkey")]
        [string]$Hotkey,

        [Parameter(ParameterSetName="Hotkey")]
        [switch]$HotkeyPassthrough = $false,

        [Parameter(ParameterSetName="Text")]
        [string]$Text,

        [Parameter(ParameterSetName="Text")]
        [switch]$EraseText = $false,

        [string]$Process,
        [switch]$ProcessFocused = $false,

        [string]$Notes = "",

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
        throw "Multiple AutoMate Servers are connected, please specify which server to create the new keyboard condition on!"
    }

    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
    if (-not $Folder) {
        # Place the task in the users condition folder
        $Folder = $user | Get-AMFolder -Type CONDITIONS
    }

    switch ($Connection.Version.Major) {
        10      { $newObject = [AMKeyboardTriggerv10]::new($Name, $Folder, $Connection.Alias) }
        11      { $newObject = [AMKeyboardTriggerv11]::new($Name, $Folder, $Connection.Alias) }
        default { throw "Unsupported server major version: $_!" }
    }
    $newObject.CreatedBy       = $user.ID
    $newObject.Notes           = $Notes
    $newObject.Process         = $Process
    $newObject.Foreground      = $ProcessFocused.ToBool()
    switch ($PSCmdlet.ParameterSetName) {
        "Hotkey" {
            $newObject.KeyType     = [AMKeyboardConditionKeyType]::Hotkey
            $newObject.Keys        = $Hotkey
            $newObject.PassThrough = $HotkeyPassthrough.ToBool()
        }
        "Text" {
            $newObject.KeyType   = [AMKeyboardConditionKeyType]::Text
            $newObject.Keys      = $Text
            $newObject.EraseText = $EraseText.ToBool()
        }
    }
    $newObject | New-AMObject -Connection $Connection
    Get-AMCondition -ID $newObject.ID -Connection $Connection
}
