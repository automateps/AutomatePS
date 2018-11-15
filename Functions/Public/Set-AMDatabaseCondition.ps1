function Set-AMDatabaseCondition {
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise database condition.

        .DESCRIPTION
            Set-AMDatabaseCondition modifies an existing database condition.

        .PARAMETER InputObject
            The condition to modify.

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

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName="Default",SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [AMDatabaseTriggerType]$DatabaseType = [AMDatabaseTriggerType]::SQL,

        [ValidateNotNullOrEmpty()]
        [string]$Server,

        [ValidateNotNullOrEmpty()]
        [int]$NotificationPort = -1,

        [ValidateNotNullOrEmpty()]
        [string]$Database,

        [ValidateNotNullOrEmpty()]
        [string]$Table,

        [string]$UserName,

        #[string]$Password,
        [switch]$Insert,
        [switch]$Delete,
        [switch]$Update,
        [switch]$Drop,
        [switch]$Alter,

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
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::Database) {
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
