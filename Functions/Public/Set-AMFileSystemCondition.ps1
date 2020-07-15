function Set-AMFileSystemCondition {
    <#
        .SYNOPSIS
            Sets properties of an Automate file system condition.

        .DESCRIPTION
            Set-AMFileSystemCondition modifies an existing file system condition.

        .PARAMETER InputObject
            The condition to modify.

        .PARAMETER MonitorFolder
            The folder to monitor.

        .PARAMETER Subfolders
            Subfolders will be monitored in addition to the parent folder.

        .PARAMETER WaitForAccess
            No action is taken until a file is no longer in use and fully accessible.

        .PARAMETER UsePollingMode
            Use polling mode with a 5 second interval.

        .PARAMETER FileAdded
            Monitor for files added to the folder.

        .PARAMETER FileRemoved
            Monitor for files removed from the folder.

        .PARAMETER FileRenamed
            Monitor for files renamed in the folder.

        .PARAMETER FileModified
            Monitor for files modified in the folder.

        .PARAMETER FolderAdded
            Monitor for folders added to the folder.

        .PARAMETER FolderRemoved
            Monitor for folders removed from the folder.

        .PARAMETER FolderRenamed
            Monitor for folders renamed in the folder.

        .PARAMETER FolderModified
            Monitor for folders modified in the folder.

        .PARAMETER FileCount
            No action is taken until the number of files specified is met.

        .PARAMETER FolderCount
            No action is taken until the number of folders specified is met.

        .PARAMETER FileSize
            No action is taken until the size of files specified is met.

        .PARAMETER FolderSize
            No action is taken until the size of folders specified is met.

        .PARAMETER Include
            Specifies the filter(s) to be included in the search.

        .PARAMETER Exclude
            Specifies the filter(s) to be excluded from the search.

        .PARAMETER UserMode
            Specify to use the default agent user (DefaultUser) or a specified user (SpecifiedUser).

        .PARAMETER UserName
            The username used to authenticate with the database.

        .PARAMETER Password
            The password for the specified user.

        .PARAMETER Domain
            The domain for the specified user.

        .PARAMETER Wait
            Wait for the condition, or evaluate immediately.

        .PARAMETER Timeout
            If wait is specified, the amount of time before the condition times out.

        .PARAMETER TimeoutUnit
            The unit for Timeout (Seconds by default).

        .PARAMETER TriggerAfter
            The number of times the condition should occur before the trigger fires.

        .PARAMETER IgnoreExistingCondition
            Don't trigger on startup if condition is true.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMFileSystemCondition.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [string]$MonitorFolder,

        [switch]$Subfolders,
        [switch]$WaitForAccess,
        [switch]$UsePollingMode,
        [switch]$FileAdded,
        [switch]$FileRemoved,
        [switch]$FileRenamed,
        [switch]$FileModified,
        [switch]$FolderAdded,
        [switch]$FolderRemoved,
        [switch]$FolderRenamed,
        [switch]$FolderModified,

        [ValidateNotNullOrEmpty()]
        [int]$FileCount,

        [ValidateNotNullOrEmpty()]
        [int]$FolderCount,

        [ValidateNotNullOrEmpty()]
        [int]$FileSize,

        [ValidateNotNullOrEmpty()]
        [int]$FolderSize,

        [string]$Include,
        [string]$Exclude,

        [ValidateNotNullOrEmpty()]
        [AMConditionUserMode]$UserMode,
        [string]$UserName,
        #[string]$Password, API BUG: does not support setting password via REST call
        [string]$Domain,

        [ValidateNotNullOrEmpty()]
        [switch]$Wait,

        [ValidateNotNullOrEmpty()]
        [int]$Timeout,

        [ValidateNotNullOrEmpty()]
        [AMTimeMeasure]$TimeoutUnit,

        [ValidateNotNullOrEmpty()]
        [switch]$IgnoreExistingCondition,

        [ValidateNotNullOrEmpty()]
        [int]$TriggerAfter,

        [AllowEmptyString()]
        [string]$Notes,

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState
    )
    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::FileSystem) {
                $updateObject = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                $boundParameterKeys = $PSBoundParameters.Keys | Where-Object {($_ -ne "InputObject") -and `
                                                                              ($_ -notin [System.Management.Automation.PSCmdlet]::CommonParameters) -and `
                                                                              ($_ -notin [System.Management.Automation.PSCmdlet]::OptionalCommonParameters)}
                foreach ($boundParameterKey in $boundParameterKeys) {
                    $property = $boundParameterKey
                    $value = $PSBoundParameters[$property]

                    # Translate properties that have an argument name different from the API name
                    if ($property -eq "MonitorFolder") { $property = "Folder" }

                    if ($property -eq "UsePollingMode") {
                        if ((Get-AMConnection $updateObject.ConnectionAlias).Version -ge [Version]"11.1.20") {
                            if ($UsePollingMode.IsPresent) {
                                $property = "PollingInterval"
                                $value = 11
                            } else {
                                $property = "PollingInterval"
                                $value = 10
                            }
                        } else {
                            Write-Warning "Parameter -UsePollingMode is only supported on version 11.1.20 and later!"
                        }
                    }

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
