function Set-AMTaskProperty {
    <#
        .SYNOPSIS
            Sets the task properties of an AutoMate Enterprise task.

        .DESCRIPTION
            Set-AMTaskProperty modifies task properties.

        .PARAMETER InputObject
            The workflow property to modify.

        .PARAMETER ErrorNotificationPropertiesSpecified
            Override the error property inheritance.

        .PARAMETER ErrorNotifyEmailFromAddress
            The error email sender.

        .PARAMETER ErrorNotifyEmailToAddress
            The error email recipient.

        .PARAMETER ExecutionPropertiesSpecified
            Override the execution property inheritance.

        .PARAMETER TaskExecutionSpeed
            The speed in milliseconds that the the task should wait between steps.

        .PARAMETER CanStopTask
            Whether a user can stop the running task.

        .PARAMETER IsolationPropertiesSpecified
            Override the isolation property inheritance.

        .PARAMETER Isolation
            The task isolation level.

        .PARAMETER LogonPropertiesSpecified
            Override the logon property inheritance.

        .PARAMETER OnLocked
            The action to take when the workstation is locked.

        .PARAMETER OnLogged
            The action to take when the workstation is logged on.

        .PARAMETER OnLogoff
            The action to take when the workstation is logged off.

        .PARAMETER UseLogonDefault
            Whether the task should run as the default agent user, or the specified user.

        .PARAMETER LogonUsername
            The username to login as.

        .PARAMETER LogonPassword
            The password for the specified user.

        .PARAMETER LogonDomain
            The domain for the specified user.

        .PARAMETER RunAsElevated
            Whether the task should run with elevated rights.

        .PARAMETER PriorityPropertiesSpecified
            Override the priority property inheritance.

        .PARAMETER Priority
            The task priority level.

        .PARAMETER PriorityAction
            The action to take if the priority level is not met.

        .PARAMETER MaxTaskInstances
            The task instance threshold for the priority action specified.

        .PARAMETER PriorityWaitTimeOut
            The timeout in minutes to use if the priority action allows for timeout.

        .PARAMETER TaskFailureAction
            If the priority is not met, the status to set on the task.

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/27/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [switch]$ErrorNotificationPropertiesSpecified,

        [ValidateNotNull()]
        [string]$ErrorNotifyEmailFromAddress,

        [ValidateNotNull()]
        [string]$ErrorNotifyEmailToAddress,

        [ValidateNotNullOrEmpty()]
        [switch]$ExecutionPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [int]$TaskExecutionSpeed,

        [ValidateNotNullOrEmpty()]
        [switch]$CanStopTask,

        [ValidateNotNullOrEmpty()]
        [switch]$IsolationPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [AMTaskIsolation]$Isolation,

        [ValidateNotNullOrEmpty()]
        [switch]$LogonPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [AMRunAsUser]$OnLocked,

        [ValidateNotNullOrEmpty()]
        [AMRunAsUser]$OnLogged,

        [ValidateNotNullOrEmpty()]
        [AMRunAsUser]$OnLogoff,

        [ValidateNotNullOrEmpty()]
        [switch]$UseLogonDefault,

        [ValidateNotNull()]
        [string]$LogonUsername,

        [ValidateNotNull()]
        [string]$LogonPassword,

        [ValidateNotNull()]
        [string]$LogonDomain,

        [ValidateNotNullOrEmpty()]
        [switch]$RunAsElevated,

        [ValidateNotNullOrEmpty()]
        [switch]$PriorityPropertiesSpecified,

        [ValidateNotNullOrEmpty()]
        [AMConcurrencyType]$Priority,

        [ValidateNotNullOrEmpty()]
        [AMPriorityAction]$PriorityAction,

        [ValidateNotNullOrEmpty()]
        [int]$MaxTaskInstances,

        [ValidateNotNullOrEmpty()]
        [int]$PriorityWaitTimeOut,

        [ValidateNotNullOrEmpty()]
        [AMTaskFailureAction]$TaskFailureAction
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "TaskProperty") {
                $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
                $parent = Get-AMTask -ID $obj.ParentID -Connection $obj.ConnectionAlias
                $updateObject = $parent | Get-AMObjectProperty
                $shouldUpdate = $false
                if ($PSBoundParameters.ContainsKey("ErrorNotifyEmailFromAddress") -and ($updateObject.ErrorNotifyEmailFromAddress -ne $ErrorNotifyEmailFromAddress)) {
                    $updateObject.ErrorNotifyEmailFromAddress = $ErrorNotifyEmailFromAddress
                    if (-not [string]::IsNullOrEmpty($ErrorNotifyEmailFromAddress)) {
                        $updateObject.ErrorNotificationPropertiesSpecified = $true
                    }
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ErrorNotifyEmailToAddress") -and ($updateObject.ErrorNotifyEmailToAddress -ne $ErrorNotifyEmailToAddress)) {
                    $updateObject.ErrorNotifyEmailToAddress = $ErrorNotifyEmailToAddress
                    if (-not [string]::IsNullOrEmpty($ErrorNotifyEmailToAddress)) {
                        $updateObject.ErrorNotificationPropertiesSpecified = $true
                    }
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ErrorNotificationPropertiesSpecified") -and ($updateObject.ErrorNotificationPropertiesSpecified -ne $ErrorNotificationPropertiesSpecified.ToBool())) {
                    $updateObject.ErrorNotificationPropertiesSpecified = $ErrorNotificationPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("TaskExecutionSpeed") -and ($updateObject.TaskExecutionSpeed -ne $TaskExecutionSpeed)) {
                    $updateObject.TaskExecutionSpeed = $TaskExecutionSpeed
                    $updateObject.ExecutionPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("CanStopTask") -and ($updateObject.CanStopTask -ne $CanStopTask.ToBool())) {
                    $updateObject.CanStopTask = $CanStopTask.ToBool()
                    $updateObject.ExecutionPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("ExecutionPropertiesSpecified") -and ($updateObject.ExecutionPropertiesSpecified -ne $ExecutionPropertiesSpecified.ToBool())) {
                    $updateObject.ExecutionPropertiesSpecified = $ExecutionPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("Isolation") -and ($updateObject.IsolationOverride -ne $Isolation)) {
                    $updateObject.IsolationOverride = $Isolation
                    $updateObject.IsolationPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("IsolationPropertiesSpecified") -and ($updateObject.IsolationPropertiesSpecified -ne $IsolationPropertiesSpecified.ToBool())) {
                    $updateObject.IsolationPropertiesSpecified = $IsolationPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("OnLocked") -and ($updateObject.OnLocked -ne $OnLocked)) {
                    $updateObject.OnLocked = $OnLocked
                    $updateObject.LogonPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("OnLogged") -and ($updateObject.OnLogged -ne $OnLogged)) {
                    $updateObject.OnLogged = $OnLogged
                    $updateObject.LogonPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("OnLogoff") -and ($updateObject.OnLogoff -ne $OnLogoff)) {
                    $updateObject.OnLogoff = $OnLogoff
                    $updateObject.LogonPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("LogonUsername") -and ($updateObject.LogonUsername -ne $LogonUsername)) {
                    $updateObject.LogonUsername = $LogonUsername
                    if (-not [string]::IsNullOrEmpty($LogonUsername)) {
                        $updateObject.UseLogonDefault = $false
                        $updateObject.LogonPropertiesSpecified = $true
                    }
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("LogonPassword") -and ($updateObject.LogonPassword -ne $LogonPassword)) {
                    $updateObject.LogonPassword = $LogonPassword
                    if (-not [string]::IsNullOrEmpty($LogonPassword)) {
                        $updateObject.UseLogonDefault = $false
                        $updateObject.LogonPropertiesSpecified = $true
                    }
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("LogonDomain") -and ($updateObject.LogonDomain -ne $LogonDomain)) {
                    $updateObject.LogonDomain = $LogonDomain
                    if (-not [string]::IsNullOrEmpty($LogonDomain)) {
                        $updateObject.UseLogonDefault = $false
                        $updateObject.LogonPropertiesSpecified = $true
                    }
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("RunAsElevated") -and ($updateObject.RunAsElevated -ne $RunAsElevated.ToBool())) {
                    $updateObject.RunAsElevated = $RunAsElevated.ToBool()
                    $updateObject.LogonPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("UseLogonDefault") -and ($updateObject.UseLogonDefault -ne $UseLogonDefault.ToBool())) {
                    $updateObject.UseLogonDefault = $UseLogonDefault.ToBool()
                    $updateObject.LogonPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("LogonPropertiesSpecified") -and ($updateObject.LogonPropertiesSpecified -ne $LogonPropertiesSpecified.ToBool())) {
                    $updateObject.LogonPropertiesSpecified = $LogonPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("Priority") -and ($updateObject.ConcurrencyType -ne $Priority)) {
                    $updateObject.ConcurrencyType = $Priority
                    $updateObject.PriorityPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("PriorityAction") -and ($updateObject.PriorityAction -ne $PriorityAction)) {
                    $updateObject.PriorityAction = $PriorityAction
                    $updateObject.PriorityPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("MaxTaskInstances") -and ($updateObject.MaxTaskInstances -ne $MaxTaskInstances)) {
                    $updateObject.MaxTaskInstances = $MaxTaskInstances
                    $updateObject.PriorityPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("PriorityWaitTimeOut") -and ($updateObject.PriorityWaitTimeOut -ne $PriorityWaitTimeOut)) {
                    $updateObject.PriorityWaitTimeOut = $PriorityWaitTimeOut
                    $updateObject.PriorityPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("TaskFailureAction") -and ($updateObject.TaskFailureAction -ne $TaskFailureAction)) {
                    $updateObject.TaskFailureAction = $TaskFailureAction
                    $updateObject.PriorityPropertiesSpecified = $true
                    $shouldUpdate = $true
                }
                if ($PSBoundParameters.ContainsKey("PriorityPropertiesSpecified") -and ($updateObject.PriorityPropertiesSpecified -ne $PriorityPropertiesSpecified.ToBool())) {
                    $updateObject.PriorityPropertiesSpecified = $PriorityPropertiesSpecified.ToBool()
                    $shouldUpdate = $true
                }
                if ($shouldUpdate) {
                    $splat = @{
                        Resource = "tasks/$($obj.ParentID)/properties/update"
                        RestMethod = "Post"
                        Body = $updateObject.ToJson()
                        Connection = $updateObject.ConnectionAlias
                    }
                    if ($PSCmdlet.ShouldProcess($connection.Name, "Modifying $($obj.Type) for $($parent.Type): $(Join-Path -Path $parent.Path -ChildPath $parent.Name)")) {
                        Invoke-AMRestMethod @splat | Out-Null
                        Write-Verbose "Modified $($obj.Type) for $($parent.Type): $(Join-Path -Path $parent.Path -ChildPath $parent.Name)."
                    }
                } else {
                    Write-Verbose "$($obj.Type) for $($parent.Type) '$($parent.Name)' already contains the specified values."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
