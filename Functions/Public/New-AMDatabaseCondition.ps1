function New-AMDatabaseCondition {
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise database condition.

        .DESCRIPTION
            New-AMDatabaseCondition creates a new database condition.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER DatabaseType
            The type of database to monitor: SQL (Microsoft) or Oracle.

        .PARAMETER Server
            The name of the database server to be monitored.

        .PARAMETER NotificationPort
            Indicates the port number that the notification listener listens on for database notifications. If the port number is set to -1 (default), a random port number is assigned to the listener when started.

        .PARAMETER Database
            The name of the database to be monitored.

        .PARAMETER Table
            The database table which holds the data element(s) to be monitored. This value must include the schema name and table name separated by a dot (.) entered in the following format (minus the brackets): [Schema_Name].[Table_Name].

        .PARAMETER UserName
            The username used to authenticate with the database.

        .PARAMETER Password
            The password for the specified user.

        .PARAMETER Insert
            If set, the condition evaluates to TRUE when an INSERT is performed on the specified database.

        .PARAMETER Delete
            If set, the condition evaluates to TRUE when an DELETE is performed on the specified database.

        .PARAMETER Update
            If set, the condition evaluates to TRUE when an UPDATE is performed on the specified database.

        .PARAMETER Drop
            If set, the condition evaluates to TRUE when an DROP is performed on the specified database.

        .PARAMETER Alter
            If set, the condition evaluates to TRUE when an ALTER is performed on the specified database.

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

        [AMDatabaseTriggerType]$DatabaseType = [AMDatabaseTriggerType]::SQL,
        [string]$Server,
        [int]$NotificationPort = -1,
        [string]$Database,
        [string]$Table,
        [string]$UserName,
        #[string]$Password,
        [switch]$Insert,
        [switch]$Delete,
        [switch]$Update,
        [switch]$Drop,
        [switch]$Alter,

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
        throw "Multiple AutoMate Servers are connected, please specify which server to create the new database condition on!"
    }

    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
    if (-not $Folder) {
        # Place the task in the users condition folder
        $Folder = $user | Get-AMFolder -Type CONDITIONS
    }

    if ($DatabaseType -ne [AMDatabaseTriggerType]::Oracle) { $NotificationPort = -1 } # Notification port is an Oracle only setting

    switch ($Connection.Version.Major) {
        10      { $newObject = [AMDatabaseTriggerv10]::new($Name, $Folder, $Connection.Alias) }
        11      { $newObject = [AMDatabaseTriggerv11]::new($Name, $Folder, $Connection.Alias) }
        default { throw "Unsupported server major version: $_!" }
    }
    $newObject.CreatedBy        = $user.ID
    $newObject.Notes            = $Notes
    $newObject.Wait             = $Wait.ToBool()
    if ($newObject.Wait) {
        $newObject.Timeout      = $Timeout
        $newObject.TimeoutUnit  = $TimeoutUnit
        $newObject.TriggerAfter = $TriggerAfter
    }
    $newObject.DatabaseType     = $DatabaseType
    $newObject.Server           = $Server
    $newObject.NotificationPort = $NotificationPort
    $newObject.Database         = $Database
    $newObject.Table            = $Table
    $newObject.Username         = $UserName
    #$newObject.Password        = $Password
    $newObject.Insert           = $Insert.ToBool()
    $newObject.Delete           = $Delete.ToBool()
    $newObject.Update           = $Update.ToBool()
    $newObject.Drop             = $Drop.ToBool()
    $newObject.Alter            = $Alter.ToBool()
    $newObject | New-AMObject -Connection $Connection
    Get-AMCondition -ID $newObject.ID -Connection $Connection
}
