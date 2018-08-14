function New-AMSnmpCondition {    
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise SNMP condition.

        .DESCRIPTION
            New-AMSnmpCondition creates a new SNMP condition.

        .PARAMETER Name
            The name of the new object.

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

        [string]$IPStart = "Any",
        [string]$IPEnd = "Any",
        [string]$Community = "Any",
        [string]$Enterprise = "Any",
        [AMSnmpGenericType]$GenericType = [AMSnmpGenericType]::Any,
        [switch]$OIDStringNotation = $false,
        [switch]$TimetickStringNotation = $false,
        [switch]$AcceptUnathenticatedTrap = $false,

        [switch]$Wait = $true,
        [int]$Timeout = 0,
        [AMTimeMeasure]$TimeoutUnit = [AMTimeMeasure]::Seconds,
        [int]$TriggerAfter = 1,

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
        throw "Multiple AutoMate Servers are connected, please specify which server to create the new SNMP condition on!"
    }

    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
    if (-not $Folder) {
        # Place the task in the users condition folder
        $Folder = $user | Get-AMFolder -Type CONDITIONS
    }

    switch ($Connection.Version.Major) {
        10      { $newObject = [AMSNMPTriggerv10]::new($Name, $Folder, $Connection.Alias) }
        11      { $newObject = [AMSNMPTriggerv11]::new($Name, $Folder, $Connection.Alias) }
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
    $newObject.IPStart                  = $IPStart
    $newObject.IPEnd                    = $IPEnd
    $newObject.Community                = $Community
    $newObject.Enterprise               = $Enterprise
    $newObject.GenericType              = $GenericType
    $newObject.OIDStringNotation        = $OIDStringNotation.ToBool()
    $newObject.TimetickStringNotation   = $TimetickStringNotation.ToBool()
    $newObject.AcceptUnathenticatedTrap = $AcceptUnathenticatedTrap.ToBool()
    $newObject | New-AMObject -Connection $Connection
    Get-AMCondition -ID $newObject.ID -Connection $Connection
}
