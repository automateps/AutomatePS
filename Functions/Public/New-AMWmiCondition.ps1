function New-AMWmiCondition {
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise WMI condition.

        .DESCRIPTION
            New-AMWmiCondition creates a new WMI condition.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER Computer
            The computer name, IP address or host name of the remote machine.  Do not specify this parameter to use the local computer.

        .PARAMETER Namespace
            Specifies the WMI namespace to execute the query under (i.e. root\CIMV2).

        .PARAMETER WQLQuery
            Specifies the WMI query that should be executed.

        .PARAMETER UserName
            The user to connect to the computer.

        .PARAMETER Password
            The password for the specified user.

        .PARAMETER PollIntervalSeconds
            Determines how often this condition monitors for the resource value.

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

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [string]$Computer = "",
        [string]$Namespace = "root\CIMV2",
        [string]$WQLQuery,
        [string]$UserName,
        #[string]$Password, API BUG: does not support setting password via REST call
        [int]$PollIntervalSeconds = 1,

        [ValidateNotNullOrEmpty()]
        [switch]$Wait = $true,
        [int]$Timeout = 0,
        [AMTimeMeasure]$TimeoutUnit = [AMTimeMeasure]::Seconds,
        [int]$TriggerAfter = 1,

        [string]$Notes = "",

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    switch (($Connection | Measure-Object).Count) {
        1 {
            $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
            if (-not $Folder) { $Folder = $user | Get-AMFolder -Type CONDITIONS } # Place the condition in the users condition folder
            switch ($Connection.Version.Major) {
                10      { $newObject = [AMWMITriggerv10]::new($Name, $Folder, $Connection.Alias) }
                11      { $newObject = [AMWMITriggerv11]::new($Name, $Folder, $Connection.Alias) }
                default { throw "Unsupported server major version: $_!" }
            }
            $newObject.CreatedBy       = $user.ID
            $newObject.Notes           = $Notes
            $newObject.Wait            = $Wait.ToBool()
            if ($newObject.Wait) {
                $newObject.Timeout      = $Timeout
                $newObject.TimeoutUnit  = $TimeoutUnit
                $newObject.TriggerAfter = $TriggerAfter
            }
            $newObject.MachineName       = $Computer
            $newObject.Namespace         = $Namespace
            $newObject.WQLQuery          = $WQLQuery
            $newObject.Username          = $UserName
            #$newObject.Password         = $Password
            $newObject.IntervalInSeconds = $PollIntervalSeconds
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple AutoMate servers are connected, please specify which server to create the new condition on!" }
    }
}