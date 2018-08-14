function New-AMLogonCondition {    
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise logon condition.

        .DESCRIPTION
            New-AMLogonCondition creates a new idle condition.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER User
            The user(s) to configure the condition to monitor for.

        .PARAMETER IdlePeriod
            The duration the agent must be idle before triggering this condition.

        .PARAMETER IdlePeriodUnit
            The unit for IdlePeriod (Minutes by default).

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

        [string[]]$User = @(),

        [switch]$Wait = $true,
        [int]$Timeout = 0,
        [AMTimeMeasure]$TimeoutUnit = [AMTimeMeasure]::Seconds,

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
        throw "Multiple AutoMate Servers are connected, please specify which server to create the new logon condition on!"
    }

    $AMUser = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
    if (-not $Folder) {
        # Place the task in the users condition folder
        $Folder = $AMUser | Get-AMFolder -Type CONDITIONS
    }

    switch ($Connection.Version.Major) {
        10      { $newObject = [AMLogonTriggerv10]::new($Name, $Folder, $Connection.Alias) }
        11      { $newObject = [AMLogonTriggerv11]::new($Name, $Folder, $Connection.Alias) }
        default { throw "Unsupported server major version: $_!" }
    }
    $newObject.CreatedBy       = $AMUser.ID
    $newObject.Notes           = $Notes
    $newObject.Wait            = $Wait.ToBool()
    if ($newObject.Wait) {
        $newObject.Timeout     = $Timeout
        $newObject.TimeoutUnit = $TimeoutUnit
    }
    if (($User.Count -eq 1) -and ($User[0] -like "*;*")) {
        $newObject.User = $User[0].Split(";")
    } elseif ($User -is [string[]]) {
        $newObject.User = $User
    } else {
        $newObject.User = @()
    }
    $newObject | New-AMObject -Connection $Connection
    Get-AMCondition -ID $newObject.ID -Connection $Connection
}
