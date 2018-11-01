class AMObjectConstructv10 {
    [string]$__type         = [string]::Empty
    [string]$ID             = "{$((New-Guid).Guid)}"
    [string]$Name           = [string]::Empty
    [string]$ParentID       = [string]::Empty
    [string]$Path           = [string]::Empty
    [AMConstructType]$Type = [AMConstructType]::Undefined

    AMObjectConstructv10() {}
    AMObjectConstructv10([string]$ConnectionAlias) {
        if ($ConnectionAlias -notin $null,[string]::Empty) {
            $this | Add-Member -Name "ConnectionAlias" -MemberType NoteProperty -Value $ConnectionAlias
        }
    }
    AMObjectConstructv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) {
        $this.Name     = $Name
        $this.ParentID = $Folder.ID
        $this.Path     = Join-Path -Path $Folder.Path -ChildPath $Folder.Name
        if ($ConnectionAlias -notin $null,[string]::Empty) {
            $this | Add-Member -Name "ConnectionAlias" -MemberType NoteProperty -Value $ConnectionAlias
        }
    }
    AMObjectConstructv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) {
        $this.__type    = $PSCustomObject.___type
        $this.ID        = $PSCustomObject.ID
        $this.Name      = $PSCustomObject.Name
        $this.ParentID  = $PSCustomObject.ParentID
        $this.Path      = $PSCustomObject.Path
        $this.Type      = $PSCustomObject.Type
        if ($ConnectionAlias -notin $null,[string]::Empty) {
            $this | Add-Member -Name "ConnectionAlias" -MemberType NoteProperty -Value $ConnectionAlias
        }
    }
    [string]ToJson([int]$Depth, [bool]$Compress) {
        $json = ConvertTo-Json -InputObject $this -Depth $Depth -Compress:$Compress
        return $json
    }
    [string]ToJson() {
        return $this.ToJson(3, $true)
    }
}

class AMAutomationConstructv10 : AMObjectConstructv10 {
    [AMCompletionState]$CompletionState = [AMCompletionState]::Production
    [string]$CreatedBy                   = [string]::Empty
    [DateTime]$CreatedOn                 = (Get-Date)
    [bool]$Empty                         = $false
    [bool]$Enabled                       = $true
    [DateTime]$EndedOn                   = (New-Object DateTime 1900, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc))
    [Array]$ExclusionSchedules           = @()
    [string]$LockedBy                    = [string]::Empty
    [DateTime]$ModifiedOn                = (Get-Date)
    [string]$Notes                       = [string]::Empty
    [bool]$Removed                       = $false
    [AMRunResult]$ResultCode            = [AMRunResult]::Undefined
    [string]$ResultText                  = [string]::Empty
    [DateTime]$StartedOn                 = (New-Object DateTime 1900, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc))
    [int]$Version                        = 0
    [DateTime]$VersionDate               = (Get-Date)

    AMAutomationConstructv10() : Base() {}
    AMAutomationConstructv10([string]$ConnectionAlias) : Base($ConnectionAlias) {}
    AMAutomationConstructv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {}
    AMAutomationConstructv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.CompletionState    = $PSCustomObject.CompletionState
        $this.CreatedBy          = $PSCustomObject.CreatedBy
        $this.CreatedOn          = $PSCustomObject.CreatedOn.ToLocalTime()
        $this.Empty              = $PSCustomObject.Empty
        $this.Enabled            = $PSCustomObject.Enabled
        $this.EndedOn            = $PSCustomObject.EndedOn.ToLocalTime()
        $this.ExclusionSchedules = $PSCustomObject.ExclusionSchedules
        $this.LockedBy           = $PSCustomObject.LockedBy
        $this.ModifiedOn         = $PSCustomObject.ModifiedOn.ToLocalTime()
        $this.Notes              = $PSCustomObject.Notes
        $this.Removed            = $PSCustomObject.Removed
        $this.ResultCode         = $PSCustomObject.ResultCode
        $this.ResultText         = $PSCustomObject.ResultText
        $this.StartedOn          = $PSCustomObject.StartedOn.ToLocalTime()
        $this.Version            = $PSCustomObject.Version
        $this.VersionDate        = $PSCustomObject.VersionDate.ToLocalTime()
    }

    [AMUserv10]GetCreatedByUser() {
        return (Get-AMUser -ID $this.CreatedBy -Connection $this.ConnectionAlias)
    }
    [AMUserv10]GetLockedByUser() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.LockedBy)) {
            $return = Get-AMUser -ID $this.LockedBy -Connection $this.ConnectionAlias
        }
        return $return
    }
    [AMAutomationConstructv10]Refresh() {
        return (Get-AMObject -ID $this.ID -Types $this.Type -Connection $this.ConnectionAlias)
    }
}

class AMAgentv10 : AMAutomationConstructv10 {
    [AMAgentType]$AgentType               = [AMAgentType]::Unknown
    [AMAgentUpgradeStep]$AgentUpgradeStep = [AMAgentUpgradeStep]::Unknown
    [bool]$Blocked                         = $false
    [string]$ConditionFolderID             = [string]::Empty
    [string]$IDWhenLastConnected           = [string]::Empty
    [string]$MachineNameWhenLastConnected  = [string]::Empty
    [string]$ProcessFolderID               = [string]::Empty
    [string]$SubstitutionID                = [string]::Empty
    [string]$VersionWhenLastConnected      = [string]::Empty

    AMAgentv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type    = "AgentConstruct:#AutoMate.Constructs.v10"
        $this.Type      = [AMConstructType]::Agent
    }
    AMAgentv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.__type                       = "AgentConstruct:#AutoMate.Constructs.v10"
        $this.AgentType                    = $PSCustomObject.AgentType
        $this.AgentUpgradeStep             = $PSCustomObject.AgentUpgradeStep
        $this.Blocked                      = $PSCustomObject.Blocked
        $this.ConditionFolderID            = $PSCustomObject.ConditionFolderID
        $this.IDWhenLastConnected          = $PSCustomObject.IDWhenLastConnected
        $this.MachineNameWhenLastConnected = $PSCustomObject.MachineNameWhenLastConnected
        $this.ProcessFolderID              = $PSCustomObject.ProcessFolderID
        $this.SubstitutionID               = $PSCustomObject.SubstitutionID
        $this.VersionWhenLastConnected     = $PSCustomObject.VersionWhenLastConnected
        if ($PSCustomObject.PSObject.Properties.Name -contains "ActiveInstances") {
            $this | Add-Member -Name "ActiveInstances" -MemberType NoteProperty -Value $PSCustomObject.ActiveInstances
        }
        if ($PSCustomObject.PSObject.Properties.Name -contains "CpuPercentage") {
            $this | Add-Member -Name "CpuPercentage" -MemberType NoteProperty -Value $PSCustomObject.CpuPercentage
        }
        if ($PSCustomObject.PSObject.Properties.Name -contains "Handles") {
            $this | Add-Member -Name "Handles" -MemberType NoteProperty -Value $PSCustomObject.Handles
        }
        if ($PSCustomObject.PSObject.Properties.Name -contains "Online") {
            $this | Add-Member -Name "Online" -MemberType NoteProperty -Value $PSCustomObject.Online
        }
        if ($PSCustomObject.PSObject.Properties.Name -contains "PrivateMemory") {
            $this | Add-Member -Name "PrivateMemory" -MemberType NoteProperty -Value $PSCustomObject.PrivateMemory
        }
        if ($PSCustomObject.PSObject.Properties.Name -contains "Threads") {
            $this | Add-Member -Name "Threads" -MemberType NoteProperty -Value $PSCustomObject.Threads
        }
        if ($PSCustomObject.PSObject.Properties.Name -contains "TriggersMonitored") {
            $this | Add-Member -Name "TriggersMonitored" -MemberType NoteProperty -Value $PSCustomObject.TriggersMonitored
        }
    }
}

class AMAgentPropertyv10 : AMAutomationConstructv10 {
    [int]$AgentPort                                       = 9600
    [int]$AgentUpgradeTimeout                             = 2
    [AMConfigurationConstructv10]$ConfigurationConstruct
    [System.Collections.ArrayList]$Constants              = [System.Collections.ArrayList]::new()
    [string]$DefaultRunAsDomain                           = [string]::Empty
    [string]$DefaultRunAsPassword                         = [string]::Empty
    [string]$DefaultRunAsUserName                         = [string]::Empty
    [string]$DefaultUserPropertiesInheritancePath         = [string]::Empty
    [bool]$DefaultUserPropertiesSpecified                 = $false
    [bool]$DisableForegroundTimeout                       = $true
    [bool]$EnableSAS                                      = $false
    [AMEventMonitorAutoStartModeType]$EventMonitorAutoMateStartMode
    [string]$IndicatorsPropertiesInheritancePath          = [string]::Empty
    [bool]$IndicatorsPropertiesSpecified                  = $false
    [string]$InterruptHotkey                              = [string]::Empty
    [string]$LoadManagementPropertiesInheritancePath      = [string]::Empty
    [bool]$LoadManagementPropertiesSpecified              = $false
    [string]$LogonScript                                  = [string]::Empty
    [int]$LogonScriptKeystrokeDelay                       = 200
    [AMCompletionState]$LowestCompletionState             = [AMCompletionState]::InDevelopment
    [string]$MIBLocation                                  = [string]::Empty
    [int]$MaxRunningTasks                                 = 50
    [string]$PrelogonKeystrokes                           = [string]::Empty
    [string]$ProxyHost                                    = [string]::Empty
    [string]$ProxyPassword                                = [string]::Empty
    [int]$ProxyPort                                       = 1028
    [string]$ProxyPropertiesInheritancePath               = [string]::Empty
    [bool]$ProxyPropertiesSpecified                       = $false
    [string]$ProxyUserID                                  = [string]::Empty
    [bool]$RunningTaskOnTop                               = $true
    [bool]$RunningTaskWindowTransparent                   = $true
    [bool]$RunningTaskWindowWithTitleBar                  = $false
    [string]$SMTPPassword                                 = [string]::Empty
    [int]$SMTPPort                                        = 25
    [string]$SMTPPropertiesInheritancePath                = [string]::Empty
    [bool]$SMTPPropertiesSpecified                        = $false
    [string]$SMTPServer                                   = [string]::Empty
    [string]$SMTPUser                                     = [string]::Empty
    [string]$SNMPPropertiesInheritancePath                = [string]::Empty
    [bool]$SNMPPropertiesSpecified                        = $false
    [int]$SNMPTrapPort                                    = 162
    [bool]$ShowRunningTaskWindow                          = $true
    [AMPrefsShowTrayIcon]$ShowTrayIcon                    = [AMPrefsShowTrayIcon]::Always
    [bool]$ShowTrayIconMenu                               = $true
    [AMSocksType]$SocksType                               = [AMSocksType]::NoProxy
    [System.Collections.ArrayList]$SqlConnectionConstants = [System.Collections.ArrayList]::new()
    [string]$StagingPropertiesInheritancePath             = [string]::Empty
    [bool]$StagingPropertiesSpecified                     = $false
    [string]$SystemPropertiesInheritancePath              = [string]::Empty
    [bool]$SystemPropertiesSpecified                      = $false
    [string]$TaskCacheFilePath                            = [string]::Empty
    [AMTaskIsolation]$TaskIsolation                       = [AMTaskIsolation]::Always
    [string]$TaskIsolationPropertiesInheritancePath       = [string]::Empty
    [bool]$TaskIsolationPropertiesSpecified               = $false
    [int]$TaskTimeout                                     = -1
    [string]$TerminalServicesUser                         = [string]::Empty
    [string]$UnlockScript                                 = [string]::Empty
    [bool]$UseInterruptHotkey                             = $false
    [bool]$UseLowestCompletionState                       = $false

    AMAgentPropertyv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {$this.AgentPort = $PSCustomObject.AgentPort
        $this.AgentUpgradeTimeout                     = $PSCustomObject.AgentUpgradeTimeout
        $this.ConfigurationConstruct                  = [AMConfigurationConstructv10]::new($PSCustomObject.ConfigurationConstruct,$ConnectionAlias)
        $this.DefaultRunAsDomain                      = $PSCustomObject.DefaultRunAsDomain
        $this.DefaultRunAsPassword                    = $PSCustomObject.DefaultRunAsPassword
        $this.DefaultRunAsUserName                    = $PSCustomObject.DefaultRunAsUserName
        $this.DefaultUserPropertiesInheritancePath    = $PSCustomObject.DefaultUserPropertiesInheritancePath
        $this.DefaultUserPropertiesSpecified          = $PSCustomObject.DefaultUserPropertiesSpecified
        $this.DisableForegroundTimeout                = $PSCustomObject.DisableForegroundTimeout
        $this.EnableSAS                               = $PSCustomObject.EnableSAS
        $this.EventMonitorAutoMateStartMode           = $PSCustomObject.EventMonitorAutoMateStartMode
        $this.IndicatorsPropertiesInheritancePath     = $PSCustomObject.IndicatorsPropertiesInheritancePath
        $this.IndicatorsPropertiesSpecified           = $PSCustomObject.IndicatorsPropertiesSpecified
        $this.InterruptHotkey                         = $PSCustomObject.InterruptHotkey
        $this.LoadManagementPropertiesInheritancePath = $PSCustomObject.LoadManagementPropertiesInheritancePath
        $this.LoadManagementPropertiesSpecified       = $PSCustomObject.LoadManagementPropertiesSpecified
        $this.LogonScript                             = $PSCustomObject.LogonScript
        $this.LogonScriptKeystrokeDelay               = $PSCustomObject.LogonScriptKeystrokeDelay
        $this.LowestCompletionState                   = $PSCustomObject.LowestCompletionState
        $this.MIBLocation                             = $PSCustomObject.MIBLocation
        $this.MaxRunningTasks                         = $PSCustomObject.MaxRunningTasks
        $this.PrelogonKeystrokes                      = $PSCustomObject.PrelogonKeystrokes
        $this.ProxyHost                               = $PSCustomObject.ProxyHost
        $this.ProxyPassword                           = $PSCustomObject.ProxyPassword
        $this.ProxyPort                               = $PSCustomObject.ProxyPort
        $this.ProxyPropertiesInheritancePath          = $PSCustomObject.ProxyPropertiesInheritancePath
        $this.ProxyPropertiesSpecified                = $PSCustomObject.ProxyPropertiesSpecified
        $this.ProxyUserID                             = $PSCustomObject.ProxyUserID
        $this.RunningTaskOnTop                        = $PSCustomObject.RunningTaskOnTop
        $this.RunningTaskWindowTransparent            = $PSCustomObject.RunningTaskWindowTransparent
        $this.RunningTaskWindowWithTitleBar           = $PSCustomObject.RunningTaskWindowWithTitleBar
        $this.SMTPPassword                            = $PSCustomObject.SMTPPassword
        $this.SMTPPort                                = $PSCustomObject.SMTPPort
        $this.SMTPPropertiesInheritancePath           = $PSCustomObject.SMTPPropertiesInheritancePath
        $this.SMTPPropertiesSpecified                 = $PSCustomObject.SMTPPropertiesSpecified
        $this.SMTPServer                              = $PSCustomObject.SMTPServer
        $this.SMTPUser                                = $PSCustomObject.SMTPUser
        $this.SNMPPropertiesInheritancePath           = $PSCustomObject.SNMPPropertiesInheritancePath
        $this.SNMPPropertiesSpecified                 = $PSCustomObject.SNMPPropertiesSpecified
        $this.SNMPTrapPort                            = $PSCustomObject.SNMPTrapPort
        $this.ShowRunningTaskWindow                   = $PSCustomObject.ShowRunningTaskWindow
        $this.ShowTrayIcon                            = $PSCustomObject.ShowTrayIcon
        $this.ShowTrayIconMenu                        = $PSCustomObject.ShowTrayIconMenu
        $this.SocksType                               = $PSCustomObject.SocksType
        $this.StagingPropertiesInheritancePath        = $PSCustomObject.StagingPropertiesInheritancePath
        $this.StagingPropertiesSpecified              = $PSCustomObject.StagingPropertiesSpecified
        $this.SystemPropertiesInheritancePath         = $PSCustomObject.SystemPropertiesInheritancePath
        $this.SystemPropertiesSpecified               = $PSCustomObject.SystemPropertiesSpecified
        $this.TaskCacheFilePath                       = $PSCustomObject.TaskCacheFilePath
        $this.TaskIsolation                           = $PSCustomObject.TaskIsolation
        $this.TaskIsolationPropertiesInheritancePath  = $PSCustomObject.TaskIsolationPropertiesInheritancePath
        $this.TaskIsolationPropertiesSpecified        = $PSCustomObject.TaskIsolationPropertiesSpecified
        $this.TaskTimeout                             = $PSCustomObject.TaskTimeout
        $this.TerminalServicesUser                    = $PSCustomObject.TerminalServicesUser
        $this.UnlockScript                            = $PSCustomObject.UnlockScript
        $this.UseInterruptHotkey                      = $PSCustomObject.UseInterruptHotkey
        $this.UseLowestCompletionState                = $PSCustomObject.UseLowestCompletionState
        foreach ($constant in $PSCustomObject.Constants) {
            $this.Constants.Add([AMConstantv10]::new($constant, $ConnectionAlias))
        }
        foreach ($sqlConstant in $PSCustomObject.SqlConnectionConstants) {
            $this.SqlConnectionConstants.Add([AMConstantv10]::new($sqlConstant, $ConnectionAlias))
        }
    }
}

class AMAgentGroupv10 : AMAutomationConstructv10 {
    [System.Collections.ArrayList]$AgentIDs = [System.Collections.ArrayList]::new()

    AMAgentGroupv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type   = "AgentGroupConstruct:#AutoMate.Constructs.v10"
        $this.Type     = [AMConstructType]::AgentGroup
    }
    AMAgentGroupv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        foreach ($agentID in $PSCustomObject.AgentIDs) {
            $this.AgentIDs.Add($agentID)
        }
    }
    [AMAgentv10[]]GetAgents() {
        $return = $this | Get-AMAgent
        return $return
    }
}

class AMAuditEventv10 : AMObjectConstructv10 {
    [string]$Data
    [DateTime]$EventDateTime
    [string]$EventText
    [AMAuditEventType]$EventType
    [string]$PrimaryConstructID
    [long]$RowIndex
    [string]$SessionID
    [AMEventStatusType]$StatusType
    [string]$UserID

    AMAuditEventv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.Data               = $PSCustomObject.Data
        $this.EventDateTime      = $PSCustomObject.EventDateTime.ToLocalTime()
        $this.EventText          = $PSCustomObject.EventText
        $this.EventType          = $PSCustomObject.EventType
        $this.PrimaryConstructID = $PSCustomObject.PrimaryConstructID
        $this.RowIndex           = $PSCustomObject.RowIndex
        $this.SessionID          = $PSCustomObject.SessionID
        $this.StatusType         = $PSCustomObject.StatusType
        $this.UserID             = $PSCustomObject.UserID
    }

    [AMAutomationConstructv10]GetConstruct() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.PrimaryConstructID)) {
            $return = Get-AMObject -ID $this.PrimaryConstructID -Connection $this.ConnectionAlias
        }
        return $return
    }
    [AMUserv10]GetUser() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.UserID)) {
            $return = Get-AMUser -ID $this.UserID -Connection $this.ConnectionAlias
        }
        return $return
    }
}

class AMConfigurationConstructv10 {
    [string]$ID                           = "{$((New-Guid).Guid)}"
    [string]$Name                         = [string]::Empty
    [string]$ParentID                     = [string]::Empty
    [string]$Path                         = [string]::Empty
    [AMConstructType]$Type                = [AMConstructType]::Notification
    [AMEmailServerv10]$EmailServer
    [AMNotificationType]$NotificationType = [AMNotificationType]::Email

    AMConfigurationConstructv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) {
        $this.ID               = $PSCustomObject.ID
        $this.Name             = $PSCustomObject.Name
        $this.ParentID         = $PSCustomObject.ParentID
        $this.Path             = $PSCustomObject.Path
        $this.Type             = $PSCustomObject.Type
        $this.EmailServer      = [AMEmailServerv10]::new($PSCustomObject.EmailServer,$ConnectionAlias)
        $this.NotificationType = $PSCustomObject.NotificationType
        if ($ConnectionAlias -notin $null,[string]::Empty) {
            $this | Add-Member -Name "ConnectionAlias" -MemberType NoteProperty -Value $ConnectionAlias
        }
    }
}

class AMConstantv10 : AMObjectConstructv10 {
    [string]$ClearTextValue        = [string]::Empty
    [string]$Comment               = [string]::Empty
    [AMConstantType]$ConstantUsage = [AMConstantType]::Constant
    [bool]$Enabled                 = $true
    [bool]$Encrypted               = $false
    [bool]$Hidden                  = $false
    [string]$Value                 = [string]::Empty

    AMConstantv10([string]$ConnectionAlias) : Base($ConnectionAlias) {
        $this.__type = "ConstantConstruct:#AutoMate.Constructs.v10"
        $this.Type   = [AMConstructType]::Constant
    }
    AMConstantv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.ClearTextValue = $PSCustomObject.ClearTextValue
        $this.Comment        = $PSCustomObject.Comment
        $this.ConstantUsage  = $PSCustomObject.ConstantUsage
        $this.Enabled        = $PSCustomObject.Enabled
        $this.Encrypted      = $PSCustomObject.Encrypted
        $this.Value          = $PSCustomObject.Value
    }
}

class AMEmailServerv10 {
    [string]$AuthenticationType
    [string]$Certificate
    [bool]$DisableChunkingandPipelining
    [string]$DomainName
    [string]$EmailAddress
    [AMSendEmailProtocol]$EmailProtocol
    [bool]$IgnoreServerCertificate
    [bool]$Impersonate
    [string]$Passphrase
    [string]$Password
    [int]$Port
    [AMHttpProtocol]$Protocol
    [string]$ProxyPassword
    [int]$ProxyPort
    [string]$ProxyServer
    [AMProxyType]$ProxyType
    [string]$ProxyUsername
    [AMSecurityType]$Security
    [string]$Server
    [int]$Timeout
    [string]$Url
    [bool]$UseAutoDiscovery
    [string]$UserAgent
    [string]$UserName
    [AMEmailVersion]$Version

    AMEmailServerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) {
        $this.AuthenticationType           = $PSCustomObject.AuthenticationType
        $this.Certificate                  = $PSCustomObject.Certificate
        $this.DisableChunkingandPipelining = $PSCustomObject.DisableChunkingandPipelining
        $this.DomainName                   = $PSCustomObject.DomainName
        $this.EmailAddress                 = $PSCustomObject.EmailAddress
        $this.EmailProtocol                = $PSCustomObject.EmailProtocol
        $this.IgnoreServerCertificate      = $PSCustomObject.IgnoreServerCertificate
        $this.Impersonate                  = $PSCustomObject.Impersonate
        $this.Passphrase                   = $PSCustomObject.Passphrase
        $this.Password                     = $PSCustomObject.Password
        $this.Port                         = $PSCustomObject.Port
        $this.Protocol                     = $PSCustomObject.Protocol
        $this.ProxyPassword                = $PSCustomObject.ProxyPassword
        $this.ProxyPort                    = $PSCustomObject.ProxyPort
        $this.ProxyServer                  = $PSCustomObject.ProxyServer
        $this.ProxyType                    = $PSCustomObject.ProxyType
        $this.ProxyUsername                = $PSCustomObject.ProxyUsername
        $this.Security                     = $PSCustomObject.Security
        $this.Server                       = $PSCustomObject.Server
        $this.Timeout                      = $PSCustomObject.Timeout
        $this.Url                          = $PSCustomObject.Url
        $this.UseAutoDiscovery             = $PSCustomObject.UseAutoDiscovery
        $this.UserAgent                    = $PSCustomObject.UserAgent
        $this.UserName                     = $PSCustomObject.UserName
        $this.Version                      = $PSCustomObject.Version
    }
}

class AMExecutionEventv10 : AMObjectConstructv10 {
    [string]$AgentID
    [string]$ConstructID
    [DateTime]$EndDateTime
    [string]$InstanceID
    [int]$ResultCode
    [string]$ResultText
    [long]$RowIndex
    [DateTime]$StartDateTime
    [string]$TransactionID
    [string]$UserID
    [string]$WorkflowInstanceID

    AMExecutionEventv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.AgentID            = $PSCustomObject.AgentID
        $this.ConstructID        = $PSCustomObject.ConstructID
        $this.EndDateTime        = $PSCustomObject.EndDateTime.ToLocalTime()
        $this.InstanceID         = $PSCustomObject.InstanceID
        $this.ResultCode         = $PSCustomObject.ResultCode
        $this.ResultText         = $PSCustomObject.ResultText
        $this.RowIndex           = $PSCustomObject.RowIndex
        $this.StartDateTime      = $PSCustomObject.StartDateTime.ToLocalTime()
        $this.TransactionID      = $PSCustomObject.TransactionID
        $this.UserID             = $PSCustomObject.UserID
        $this.WorkflowInstanceID = $PSCustomObject.WorkflowInstanceID
    }

    [AMAgentv10]GetAgent() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.AgentID)) {
            $return = Get-AMAgent -ID $this.AgentID -Connection $this.ConnectionAlias
        }
        return $return
    }
    [AMAutomationConstructv10]GetConstruct() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.ConstructID)) {
            $return = Get-AMObject -ID $this.ConstructID -Types Workflow,Task,Process,Condition -Connection $this.ConnectionAlias
        }
        return $return
    }
    [AMUserv10]GetUser() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.UserID)) {
            $return = Get-AMUser -ID $this.UserID -Connection $this.ConnectionAlias
        }
        return $return
    }
}

class AMFolderv10 : AMAutomationConstructv10 {
    AMFolderv10([string]$ConnectionAlias) : Base($ConnectionAlias) {
        $this.__type = "FolderConstruct:#AutoMate.Constructs.v10"
        $this.Type   = [AMConstructType]::Folder
    }
    AMFolderv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type = "FolderConstruct:#AutoMate.Constructs.v10"
        $this.Type = [AMConstructType]::Folder
    }
    AMFolderv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {}
}

class AMInstancev10 : AMObjectConstructv10 {
    [string]$AgentID
    [string]$AgentName
    [string]$AgentPath
    [bool]$ConstructEnabled
    [string]$ConstructID
    [string]$ConstructName
    [string]$ConstructPath
    [AMConstructType]$ConstructType
    [string]$CurrentFunctionName
    [string]$CurrentStepDescription
    [int]$CurrentStepNumber
    [int]$DurationInSeconds
    [DateTime]$EndDateTime
    [string]$InstanceID
    [DateTime]$LastChanged
    [bool]$ManuallyRun
    [bool]$Reactive
    [int]$ResultCode
    [string]$ResultText
    [bool]$Scheduled
    [DateTime]$StartDateTime
    [AMInstanceStatus]$Status
    [string]$TransactionID
    [string]$TriggerID
    [string]$TriggerName
    [string]$TriggerPath
    [AMTriggerType]$TriggerType
    [bool]$Triggered
    [string]$UserID
    [string]$UserName
    [string]$UserPath
    [string]$WorkflowInstanceID
    AMInstancev10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.AgentID                = $PSCustomObject.AgentID
        $this.AgentName              = $PSCustomObject.AgentName
        $this.AgentPath              = $PSCustomObject.AgentPath
        $this.ConstructEnabled       = $PSCustomObject.ConstructEnabled
        $this.ConstructID            = $PSCustomObject.ConstructID
        $this.ConstructName          = $PSCustomObject.ConstructName
        $this.ConstructPath          = $PSCustomObject.ConstructPath
        $this.ConstructType          = $PSCustomObject.ConstructType
        $this.CurrentFunctionName    = $PSCustomObject.CurrentFunctionName
        $this.CurrentStepDescription = $PSCustomObject.CurrentStepDescription
        $this.CurrentStepNumber      = $PSCustomObject.CurrentStepNumber
        $this.DurationInSeconds      = $PSCustomObject.DurationInSeconds
        $this.EndDateTime            = $PSCustomObject.EndDateTime.ToLocalTime()
        $this.InstanceID             = $PSCustomObject.InstanceID
        $this.LastChanged            = $PSCustomObject.LastChanged.ToLocalTime()
        $this.ManuallyRun            = $PSCustomObject.ManuallyRun
        $this.Reactive               = $PSCustomObject.Reactive
        $this.ResultCode             = $PSCustomObject.ResultCode
        $this.ResultText             = $PSCustomObject.ResultText
        $this.Scheduled              = $PSCustomObject.Scheduled
        $this.StartDateTime          = $PSCustomObject.StartDateTime.ToLocalTime()
        $this.Status                 = $PSCustomObject.Status
        $this.TransactionID          = $PSCustomObject.TransactionID
        $this.TriggerID              = $PSCustomObject.TriggerID
        $this.TriggerName            = $PSCustomObject.TriggerName
        $this.TriggerPath            = $PSCustomObject.TriggerPath
        $this.TriggerType            = $PSCustomObject.TriggerType
        $this.Triggered              = $PSCustomObject.Triggered
        $this.UserID                 = $PSCustomObject.UserID
        $this.UserName               = $PSCustomObject.UserName
        $this.UserPath               = $PSCustomObject.UserPath
        $this.WorkflowInstanceID     = $PSCustomObject.WorkflowInstanceID
    }

    [AMAgentv10]GetAgent() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.AgentID)) {
            $return = Get-AMAgent -ID $this.AgentID -Connection $this.ConnectionAlias
        }
        return $return
    }
    [AMAutomationConstructv10]GetConstruct() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.ConstructID)) {
            $return = Get-AMObject -ID $this.ConstructID -Types $this.ConstructType -Connection $this.ConnectionAlias
        }
        return $return
    }
    [AMUserv10]GetTrigger() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.TriggerID)) {
            $return = Get-AMCondition -ID $this.TriggerID -Connection $this.ConnectionAlias
        }
        return $return
    }
    [AMUserv10]GetUser() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.UserID)) {
            $return = Get-AMUser -ID $this.UserID -Connection $this.ConnectionAlias
        }
        return $return
    }
}

class AMPermissionv10 : AMObjectConstructv10 {
    [bool]$AssignPermission      = $false
    [string]$ConstructID         = [string]::Empty
    [bool]$CreatePermission      = $false
    [bool]$DeletePermission      = $false
    [bool]$EditPermission        = $false
    [bool]$EnablePermission      = $false
    [bool]$ExportPermission      = $false
    [string]$GroupID             = [string]::Empty
    [bool]$ImportPermission      = $false
    [bool]$LockPermission        = $false
    [bool]$MovePermission        = $false
    [bool]$ReadPermission        = $false
    [bool]$ResumePermission      = $false
    [bool]$ResurrectPermission   = $false
    [bool]$RunFromHerePermission = $false
    [bool]$RunPermission         = $false
    [bool]$SecurityPermission    = $false
    [bool]$StagingPermission     = $false
    [bool]$StopPermission        = $false
    [bool]$UpgradePermission     = $false

    AMPermissionv10([AMAutomationConstructv10]$Construct, [AMAutomationConstructv10]$Principal, [string]$ConnectionAlias) : Base($ConnectionAlias) {
        $this.__type      = "ItemPermissionsConstruct:#AutoMate.Constructs.v10"
        $this.Type        = [AMConstructType]::Permission
        $this.ConstructID = $Construct.ID
        $this.GroupID     = $Principal.ID
    }
    AMPermissionv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.AssignPermission      = $PSCustomObject.AssignPermission
        $this.ConstructID           = $PSCustomObject.ConstructID
        $this.CreatePermission      = $PSCustomObject.CreatePermission
        $this.DeletePermission      = $PSCustomObject.DeletePermission
        $this.EditPermission        = $PSCustomObject.EditPermission
        $this.EnablePermission      = $PSCustomObject.EnablePermission
        $this.ExportPermission      = $PSCustomObject.ExportPermission
        $this.GroupID               = $PSCustomObject.GroupID
        $this.ImportPermission      = $PSCustomObject.ImportPermission
        $this.LockPermission        = $PSCustomObject.LockPermission
        $this.MovePermission        = $PSCustomObject.MovePermission
        $this.ReadPermission        = $PSCustomObject.ReadPermission
        $this.ResumePermission      = $PSCustomObject.ResumePermission
        $this.ResurrectPermission   = $PSCustomObject.ResurrectPermission
        $this.RunFromHerePermission = $PSCustomObject.RunFromHerePermission
        $this.RunPermission         = $PSCustomObject.RunPermission
        $this.SecurityPermission    = $PSCustomObject.SecurityPermission
        $this.StagingPermission     = $PSCustomObject.StagingPermission
        $this.StopPermission        = $PSCustomObject.StopPermission
        $this.UpgradePermission     = $PSCustomObject.UpgradePermission
    }

    [AMAutomationConstructv10]GetConstruct() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.ConstructID)) {
            $return = Get-AMObject -ID $this.ConstructID -Connection $this.ConnectionAlias
        }
        return $return
    }
    [AMAutomationConstructv10]GetUser() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.GroupID)) {
            $return = Get-AMObject -ID $this.GroupID -Types User,UserGroup -Connection $this.ConnectionAlias
        }
        return $return
    }
}

class AMProcessv10 : AMAutomationConstructv10 {
    [string]$CommandLine          = [string]::Empty
    [string]$EnvironmentVariables = [string]::Empty
    [AMRunProcessAs]$RunProcessAs = [AMRunProcessAs]::Default
    [string]$WorkingDirectory     = [string]::Empty

    AMProcessv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type = "ProcessConstruct:#AutoMate.Constructs.v10"
        $this.Type   = [AMConstructType]::Process
    }
    AMProcessv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.__type               = "ProcessConstruct:#AutoMate.Constructs.v10"
        $this.CommandLine          = $PSCustomObject.CommandLine
        $this.EnvironmentVariables = $PSCustomObject.EnvironmentVariables
        $this.RunProcessAs         = $PSCustomObject.RunProcessAs
        $this.WorkingDirectory     = $PSCustomObject.WorkingDirectory
        if ($PSCustomObject.PSObject.Properties.Name -contains "DurationInSeconds") {
            $this | Add-Member -Name "DurationInSeconds" -MemberType NoteProperty -Value $PSCustomObject.DurationInSeconds
        }
    }
}

class AMSystemPermissionv10 : AMObjectConstructv10 {
    [bool]$DeployPermission                = $false
    [bool]$EditDashboardPermission         = $false
    [bool]$EditDefaultPropertiesPermission = $false
    [bool]$EditLicensingPermission         = $false
    [bool]$EditPreferencesPermission       = $false
    [bool]$EditServerSettingsPermission    = $false
    [string]$GroupID                       = [string]::Empty
    [bool]$ToggleTriggeringPermission      = $false
    [bool]$ViewCalendarPermission          = $false
    [bool]$ViewDashboardPermission         = $false
    [bool]$ViewDefaultPropertiesPermission = $false
    [bool]$ViewLicensingPermission         = $false
    [bool]$ViewPreferencesPermission       = $false
    [bool]$ViewReportsPermission           = $false
    [bool]$ViewServerSettingsPermission    = $false

    AMSystemPermissionv10([string]$ConnectionAlias) : Base($ConnectionAlias) {
        $this.__type  = "SystemPermissionsConstruct:#AutoMate.Constructs.v10"
        $this.Type    = [AMConstructType]::SystemPermission
    }
    AMSystemPermissionv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.DeployPermission                = $PSCustomObject.DeployPermission
        $this.EditDashboardPermission         = $PSCustomObject.EditDashboardPermission
        $this.EditDefaultPropertiesPermission = $PSCustomObject.EditDefaultPropertiesPermission
        $this.EditLicensingPermission         = $PSCustomObject.EditLicensingPermission
        $this.EditPreferencesPermission       = $PSCustomObject.EditPreferencesPermission
        $this.EditServerSettingsPermission    = $PSCustomObject.EditServerSettingsPermission
        $this.GroupID                         = $PSCustomObject.GroupID
        $this.ToggleTriggeringPermission      = $PSCustomObject.ToggleTriggeringPermission
        $this.ViewCalendarPermission          = $PSCustomObject.ViewCalendarPermission
        $this.ViewDashboardPermission         = $PSCustomObject.ViewDashboardPermission
        $this.ViewDefaultPropertiesPermission = $PSCustomObject.ViewDefaultPropertiesPermission
        $this.ViewLicensingPermission         = $PSCustomObject.ViewLicensingPermission
        $this.ViewPreferencesPermission       = $PSCustomObject.ViewPreferencesPermission
        $this.ViewReportsPermission           = $PSCustomObject.ViewReportsPermission
        $this.ViewServerSettingsPermission    = $PSCustomObject.ViewServerSettingsPermission
    }

    [AMAutomationConstructv10]GetUser() {
        $return = $null
        if (-not [string]::IsNullOrEmpty($this.GroupID)) {
            $return = Get-AMObject -ID $this.GroupID -Types User,UserGroup -Connection $this.ConnectionAlias
        }
        return $return
    }
}

class AMTaskv10 : AMAutomationConstructv10 {
    [string]$AML = [string]::Empty

    AMTaskv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type = "TaskConstruct:#AutoMate.Constructs.v10"
        $this.Type   = [AMConstructType]::Task
    }
    AMTaskv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.__type = "TaskConstruct:#AutoMate.Constructs.v10"
        $this.AML    = $PSCustomObject.AML
        if ($PSCustomObject.PSObject.Properties.Name -contains "DurationInSeconds") {
            $this | Add-Member -Name "DurationInSeconds" -MemberType NoteProperty -Value $PSCustomObject.DurationInSeconds
        }
    }
}

class AMTaskPropertyv10 : AMAutomationConstructv10 {
    [bool]$CanStopTask
    [AMConcurrencyType]$ConcurrencyType
    [System.Collections.ArrayList]$Constants = [System.Collections.ArrayList]::new()
    [string]$ErrorNotificationPropertiesInheritancePath
    [bool]$ErrorNotificationPropertiesSpecified
    [string]$ErrorNotifyEmailFromAddress
    [string]$ErrorNotifyEmailToAddress
    [string]$ErrorRunTaskName
    [string]$ExecutionPropertiesInheritancePath
    [bool]$ExecutionPropertiesSpecified
    [AMTaskIsolation]$IsolationOverride
    [string]$IsolationPropertiesInheritancePath
    [bool]$IsolationPropertiesSpecified
    [string]$LogonDomain
    [string]$LogonPassword
    [string]$LogonPropertiesInheritancePath
    [bool]$LogonPropertiesSpecified
    [string]$LogonUsername
    [int]$MaxTaskInstances
    [AMRunAsUser]$OnLocked
    [AMRunAsUser]$OnLogged
    [AMRunAsUser]$OnLogoff
    [AMPriorityAction]$PriorityAction
    [string]$PriorityPropertiesInheritancePath
    [bool]$PriorityPropertiesSpecified
    [int]$PriorityWaitTimeOut
    [bool]$RunAsElevated
    [int]$TaskExecutionSpeed
    [AMTaskFailureAction]$TaskFailureAction
    [int]$TaskTimeout
    [bool]$UseLogonDefault

    AMTaskPropertyv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.CanStopTask                                = $PSCustomObject.CanStopTask
        $this.ConcurrencyType                            = $PSCustomObject.ConcurrencyType
        $this.ErrorNotificationPropertiesInheritancePath = $PSCustomObject.ErrorNotificationPropertiesInheritancePath
        $this.ErrorNotificationPropertiesSpecified       = $PSCustomObject.ErrorNotificationPropertiesSpecified
        $this.ErrorNotifyEmailFromAddress                = $PSCustomObject.ErrorNotifyEmailFromAddress
        $this.ErrorNotifyEmailToAddress                  = $PSCustomObject.ErrorNotifyEmailToAddress
        $this.ErrorRunTaskName                           = $PSCustomObject.ErrorRunTaskName
        $this.ExecutionPropertiesInheritancePath         = $PSCustomObject.ExecutionPropertiesInheritancePath
        $this.ExecutionPropertiesSpecified               = $PSCustomObject.ExecutionPropertiesSpecified
        $this.IsolationOverride                          = $PSCustomObject.IsolationOverride
        $this.IsolationPropertiesInheritancePath         = $PSCustomObject.IsolationPropertiesInheritancePath
        $this.IsolationPropertiesSpecified               = $PSCustomObject.IsolationPropertiesSpecified
        $this.LogonDomain                                = $PSCustomObject.LogonDomain
        $this.LogonPassword                              = $PSCustomObject.LogonPassword
        $this.LogonPropertiesInheritancePath             = $PSCustomObject.LogonPropertiesInheritancePath
        $this.LogonPropertiesSpecified                   = $PSCustomObject.LogonPropertiesSpecified
        $this.LogonUsername                              = $PSCustomObject.LogonUsername
        $this.MaxTaskInstances                           = $PSCustomObject.MaxTaskInstances
        $this.OnLocked                                   = $PSCustomObject.OnLocked
        $this.OnLogged                                   = $PSCustomObject.OnLogged
        $this.OnLogoff                                   = $PSCustomObject.OnLogoff
        $this.PriorityAction                             = $PSCustomObject.PriorityAction
        $this.PriorityPropertiesInheritancePath          = $PSCustomObject.PriorityPropertiesInheritancePath
        $this.PriorityPropertiesSpecified                = $PSCustomObject.PriorityPropertiesSpecified
        $this.PriorityWaitTimeOut                        = $PSCustomObject.PriorityWaitTimeOut
        $this.RunAsElevated                              = $PSCustomObject.RunAsElevated
        $this.TaskExecutionSpeed                         = $PSCustomObject.TaskExecutionSpeed
        $this.TaskFailureAction                          = $PSCustomObject.TaskFailureAction
        $this.TaskTimeout                                = $PSCustomObject.TaskTimeout
        $this.UseLogonDefault                            = $PSCustomObject.UseLogonDefault
        foreach ($constant in $PSCustomObject.Constants) {
            $this.Constants.Add([AMConstantv10]::new($constant, $ConnectionAlias))
        }
    }
}

class AMTriggerv10 : AMAutomationConstructv10 {
    [string]$Description           = [string]::Empty
    [bool]$IgnoreExistingCondition = $false
    [int]$Timeout                  = 0
    [AMTimeMeasure]$TimeoutUnit    = [AMTimeMeasure]::Seconds
    [int]$TriggerAfter             = 1
    [AMTriggerType]$TriggerType
    [bool]$Wait                    = $true

    AMTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.Type = [AMConstructType]::Condition
    }
    AMTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.Description             = $PSCustomObject.Description
        $this.IgnoreExistingCondition = $PSCustomObject.IgnoreExistingCondition
        $this.Timeout                 = $PSCustomObject.Timeout
        $this.TimeoutUnit             = $PSCustomObject.TimeoutUnit
        $this.TriggerAfter            = $PSCustomObject.TriggerAfter
        $this.TriggerType             = $PSCustomObject.TriggerType
        $this.Wait                    = $PSCustomObject.Wait
    }
}

class AMDatabaseTriggerv10 : AMTriggerv10 {
    [AMDatabaseTriggerType]$DatabaseType = [AMDatabaseTriggerType]::SQL
    [string]$Server        = [string]::Empty
    [int]$NotificationPort = -1
    [string]$Database      = [string]::Empty
    [string]$Table         = [string]::Empty
    [string]$UserName      = [string]::Empty
    [string]$Password      = [string]::Empty
    [bool]$Insert          = $true
    [bool]$Delete          = $false
    [bool]$Update          = $false
    [bool]$Drop            = $false
    [bool]$Alter           = $false

    AMDatabaseTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "DatabaseTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::Database
    }
    AMDatabaseTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.DatabaseType     = $PSCustomObject.DatabaseType
        $this.Server           = $PSCustomObject.Server
        $this.NotificationPort = $PSCustomObject.NotificationPort
        $this.Database         = $PSCustomObject.Database
        $this.Table            = $PSCustomObject.Table
        $this.UserName         = $PSCustomObject.UserName
        $this.Password         = $PSCustomObject.Password
        $this.Insert           = $PSCustomObject.Insert
        $this.Delete           = $PSCustomObject.Delete
        $this.Update           = $PSCustomObject.Update
        $this.Drop             = $PSCustomObject.Drop
        $this.Alter            = $PSCustomObject.Alter
    }
}

class AMEventLogTriggerv10 : AMTriggerv10 {
    [string]$EventCategory                 = [string]::Empty
    [string]$EventDescription              = [string]::Empty
    [string]$EventSource                   = [string]::Empty
    [AMEventLogTriggerEventType]$EventType = [AMEventLogTriggerEventType]::Any
    [string]$LogType                       = [string]::Empty

    AMEventLogTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "EventLogTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::EventLog
    }
    AMEventLogTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.EventCategory    = $PSCustomObject.EventCategory
        $this.EventDescription = $PSCustomObject.EventDescription
        $this.EventSource      = $PSCustomObject.EventSource
        $this.EventType        = $PSCustomObject.EventType
        $this.LogType          = $PSCustomObject.LogType
    }
}

class AMFileSystemTriggerv10 : AMTriggerv10 {
    [string]$Domain       = [string]::Empty
    [string]$Exclude      = [string]::Empty
    [bool]$FileAdded      = $true
    [int]$FileCount       = -1
    [bool]$FileModified   = $false
    [bool]$FileRemoved    = $false
    [bool]$FileRenamed    = $false
    [int]$FileSize        = -1
    [string]$Folder       = [string]::Empty
    [bool]$FolderAdded    = $false
    [int]$FolderCount     = -1
    [bool]$FolderModified = $false
    [bool]$FolderRemoved  = $false
    [bool]$FolderRenamed  = $false
    [int]$FolderSize      = -1
    [string]$Include      = [string]::Empty
    [string]$Password     = [string]::Empty
    [int]$PollingInterval = 10
    [bool]$SubFolders     = $false
    [AMConditionUserMode]$UserMode = [AMConditionUserMode]::NoUser
    [string]$UserName     = [string]::Empty
    [bool]$WaitForAccess  = $false

    AMFileSystemTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "FileTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::FileSystem
    }
    AMFileSystemTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.Domain          = $PSCustomObject.Domain
        $this.Exclude         = $PSCustomObject.Exclude
        $this.FileAdded       = $PSCustomObject.FileAdded
        $this.FileCount       = $PSCustomObject.FileCount
        $this.FileModified    = $PSCustomObject.FileModified
        $this.FileRemoved     = $PSCustomObject.FileRemoved
        $this.FileRenamed     = $PSCustomObject.FileRenamed
        $this.FileSize        = $PSCustomObject.FileSize
        $this.Folder          = $PSCustomObject.Folder
        $this.FolderAdded     = $PSCustomObject.FolderAdded
        $this.FolderCount     = $PSCustomObject.FolderCount
        $this.FolderModified  = $PSCustomObject.FolderModified
        $this.FolderRemoved   = $PSCustomObject.FolderRemoved
        $this.FolderRenamed   = $PSCustomObject.FolderRenamed
        $this.FolderSize      = $PSCustomObject.FolderSize
        $this.Include         = $PSCustomObject.Include
        $this.Password        = $PSCustomObject.Password
        $this.PollingInterval = $PSCustomObject.PollingInterval
        $this.SubFolders      = $PSCustomObject.SubFolders
        $this.UserMode        = $PSCustomObject.UserMode
        $this.UserName        = $PSCustomObject.UserName
        $this.WaitForAccess   = $PSCustomObject.WaitForAccess
    }
}

class AMIdleTriggerv10 : AMTriggerv10 {
    [int]$Delay             = 1
    [AMTimeMeasure]$Measure = [AMTimeMeasure]::Minutes

    AMIdleTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "IdleTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::Idle
    }
    AMIdleTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.Delay   = $PSCustomObject.Delay
        $this.Measure = $PSCustomObject.Measure
    }
}

class AMKeyboardTriggerv10 : AMTriggerv10 {
    [bool]$EraseText                     = $false
    [bool]$Foreground                    = $false
    [AMKeyboardConditionKeyType]$KeyType = [AMKeyboardConditionKeyType]::Hotkey
    [string]$Keys                        = [string]::Empty
    [bool]$PassThrough                   = $false
    [string]$Process                     = [string]::Empty

    AMKeyboardTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "KeyTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::Keyboard
    }
    AMKeyboardTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.EraseText   = $PSCustomObject.EraseText
        $this.Foreground  = $PSCustomObject.Foreground
        $this.KeyType     = $PSCustomObject.KeyType
        $this.Keys        = $PSCustomObject.Keys
        $this.PassThrough = $PSCustomObject.PassThrough
        $this.Process     = $PSCustomObject.Process
    }
}

class AMLogonTriggerv10 : AMTriggerv10 {
    [System.Collections.ArrayList]$User = [System.Collections.ArrayList]::new()

    AMLogonTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "StartupTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::Logon
    }
    AMLogonTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        foreach ($u in $PSCustomObject.User) {
            $this.User.Add($u)
        }
    }
}

class AMPerformanceTriggerv10 : AMTriggerv10 {
    [long]$Amount                         = 10
    [bool]$AnyProcessInApplication        = $true
    [bool]$AnyThreadInProcess             = $true
    [bool]$AnyThreadInstanceInApplication = $true
    [string]$CategoryName                 = [string]::Empty
    [string]$CounterName                  = [string]::Empty
    [string]$InstanceName                 = [string]::Empty
    [string]$MachineName                  = [string]::Empty
    [AMPerformanceOperator]$Operator      = [AMPerformanceOperator]::Below
    [int]$TimePeriod                      = 3
    [AMTimeMeasure]$TimePeriodUnit        = [AMTimeMeasure]::Milliseconds

    AMPerformanceTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "PerformanceTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::Performance
    }
    AMPerformanceTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.Amount                         = $PSCustomObject.Amount
        $this.AnyProcessInApplication        = $PSCustomObject.AnyProcessInApplication
        $this.AnyThreadInProcess             = $PSCustomObject.AnyThreadInProcess
        $this.AnyThreadInstanceInApplication = $PSCustomObject.AnyThreadInstanceInApplication
        $this.CategoryName                   = $PSCustomObject.CategoryName
        $this.CounterName                    = $PSCustomObject.CounterName
        $this.InstanceName                   = $PSCustomObject.InstanceName
        $this.MachineName                    = $PSCustomObject.MachineName
        $this.Operator                       = $PSCustomObject.Operator
        $this.TimePeriod                     = $PSCustomObject.TimePeriod
        $this.TimePeriodUnit                 = $PSCustomObject.TimePeriodUnit
    }
}

class AMProcessTriggerv10 : AMTriggerv10 {
    [AMProcessTriggerState]$Action = [AMProcessTriggerState]::StoppedResponding
    [string]$Exclude               = [string]::Empty
    [string]$ProcessName           = "*"
    [bool]$Started                 = $false
    [bool]$TriggerOnce             = $false


    AMProcessTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "ProcessTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::Process
    }
    AMProcessTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.Action      = $PSCustomObject.Action
        $this.Exclude     = $PSCustomObject.Exclude
        $this.ProcessName = $PSCustomObject.ProcessName
        $this.Started     = $PSCustomObject.Started
        $this.TriggerOnce = $PSCustomObject.TriggerOnce
    }
}

class AMScheduleTriggerv10 : AMTriggerv10 {
    [System.Collections.ArrayList]$Day         = [System.Collections.ArrayList]::new()
    [string]$End                               = [string]::Empty
    [string]$Frequency                         = "1"
    [System.Collections.ArrayList]$HolidayList = [System.Collections.ArrayList]::new()
    [string]$LastLaunchDate                    = [string]::Empty
    [AMScheduleMeasure]$Measure                = [AMScheduleMeasure]::Day
    [System.Collections.ArrayList]$Month       = [System.Collections.ArrayList]::new()
    [int]$MonthInterval                        = 1
    [string]$NextLaunchDate                    = [string]::Empty
    [AMOnTaskLateRescheduleOption]$OnTaskLate  = [AMOnTaskLateRescheduleOption]::RunImmediately
    [bool]$Possible                            = $true
    [AMRescheduleOption]$Reschedule            = [AMRescheduleOption]::RelativeToOriginalTime
    [AMScheduleType]$ScheduleType              = [AMScheduleType]::DayInterval
    [string]$StartTime                         = [string]::Empty

    AMScheduleTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "ScheduleTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::Schedule
    }
    AMScheduleTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.End            = $PSCustomObject.End
        $this.Frequency      = $PSCustomObject.Frequency
        $this.LastLaunchDate = $PSCustomObject.LastLaunchDate
        $this.Measure        = $PSCustomObject.Measure
        $this.MonthInterval  = $PSCustomObject.MonthInterval
        $this.NextLaunchDate = $PSCustomObject.NextLaunchDate
        $this.OnTaskLate     = $PSCustomObject.OnTaskLate
        $this.Possible       = $PSCustomObject.Possible
        $this.Reschedule     = $PSCustomObject.Reschedule
        $this.ScheduleType   = $PSCustomObject.ScheduleType
        $this.StartTime      = $PSCustomObject.StartTime
        foreach ($d in $PSCustomObject.Day) {
            $this.Day.Add($d)
        }
        foreach ($h in $PSCustomObject.HolidayList) {
            $this.HolidayList.Add($h)
        }
        foreach ($m in $PSCustomObject.Month) {
            $this.Month.Add($m)
        }
    }
}

class AMServiceTriggerv10 : AMTriggerv10 {
    [AMServiceTriggerState]$Action = [AMServiceTriggerState]::StoppedResponding
    [string]$Exclude               = [string]::Empty
    [string]$ServiceName           = [string]::Empty
    [bool]$Started                 = $false

    AMServiceTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "ServiceTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::Service
    }
    AMServiceTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.Action      = $PSCustomObject.Action
        $this.Exclude     = $PSCustomObject.Exclude
        $this.ServiceName = $PSCustomObject.ServiceName
        $this.Started     = $PSCustomObject.Started
    }
}

class AMSharePointTriggerv10 : AMTriggerv10 {
    [string]$Domain                = [string]::Empty
    [bool]$EmailReceived           = $false
    [bool]$FieldAdded              = $false
    [bool]$FieldDeleted            = $false
    [bool]$FieldUpdated            = $false
    [bool]$GroupAdded              = $false
    [bool]$GroupDeleted            = $false
    [bool]$GroupUpdated            = $false
    [bool]$GroupUserAdded          = $false
    [bool]$GroupUserDeleted        = $false
    [bool]$ItemAdded               = $true
    [bool]$ItemAttachmentAdded     = $false
    [bool]$ItemAttachmentDeleted   = $false
    [bool]$ItemCheckedIn           = $false
    [bool]$ItemCheckedOut          = $false
    [bool]$ItemDeleted             = $false
    [bool]$ItemFileMoved           = $false
    [bool]$ItemUncheckedOut        = $false
    [bool]$ItemUpdated             = $false
    [string]$List                  = [string]::Empty
    [bool]$ListAdded               = $false
    [bool]$ListDeleted             = $false
    [string]$Password              = [string]::Empty
    [bool]$RoleAssignmentAdded     = $false
    [bool]$RoleAssignmentDeleted   = $false
    [bool]$RoleDefinitionAdded     = $false
    [bool]$RoleDefinitionDeleted   = $false
    [bool]$RoleDefinitionUpdated   = $false
    [AMSharePointScope]$Scope      = [AMSharePointScope]::Web
    [string]$SiteURL               = [string]::Empty
    [AMConditionUserMode]$UserMode = [AMConditionUserMode]::DefaultUser
    [string]$UserName              = [string]::Empty
    [bool]$WorkflowCompleted       = $false
    [bool]$WorkflowPostponed       = $false
    [bool]$WorkflowStarted         = $false

    AMSharePointTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "SharePointTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::SharePoint
    }
    AMSharePointTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.Domain                = $PSCustomObject.Domain
        $this.EmailReceived         = $PSCustomObject.EmailReceived
        $this.FieldAdded            = $PSCustomObject.FieldAdded
        $this.FieldDeleted          = $PSCustomObject.FieldDeleted
        $this.FieldUpdated          = $PSCustomObject.FieldUpdated
        $this.GroupAdded            = $PSCustomObject.GroupAdded
        $this.GroupDeleted          = $PSCustomObject.GroupDeleted
        $this.GroupUpdated          = $PSCustomObject.GroupUpdated
        $this.GroupUserAdded        = $PSCustomObject.GroupUserAdded
        $this.GroupUserDeleted      = $PSCustomObject.GroupUserDeleted
        $this.ItemAdded             = $PSCustomObject.ItemAdded
        $this.ItemAttachmentAdded   = $PSCustomObject.ItemAttachmentAdded
        $this.ItemAttachmentDeleted = $PSCustomObject.ItemAttachmentDeleted
        $this.ItemCheckedIn         = $PSCustomObject.ItemCheckedIn
        $this.ItemCheckedOut        = $PSCustomObject.ItemCheckedOut
        $this.ItemDeleted           = $PSCustomObject.ItemDeleted
        $this.ItemFileMoved         = $PSCustomObject.ItemFileMoved
        $this.ItemUncheckedOut      = $PSCustomObject.ItemUncheckedOut
        $this.ItemUpdated           = $PSCustomObject.ItemUpdated
        $this.List                  = $PSCustomObject.List
        $this.ListAdded             = $PSCustomObject.ListAdded
        $this.ListDeleted           = $PSCustomObject.ListDeleted
        $this.Password              = $PSCustomObject.Password
        $this.RoleAssignmentAdded   = $PSCustomObject.RoleAssignmentAdded
        $this.RoleAssignmentDeleted = $PSCustomObject.RoleAssignmentDeleted
        $this.RoleDefinitionAdded   = $PSCustomObject.RoleDefinitionAdded
        $this.RoleDefinitionDeleted = $PSCustomObject.RoleDefinitionDeleted
        $this.RoleDefinitionUpdated = $PSCustomObject.RoleDefinitionUpdated
        $this.Scope                 = $PSCustomObject.Scope
        $this.SiteURL               = $PSCustomObject.SiteURL
        $this.UserMode              = $PSCustomObject.UserMode
        $this.UserName              = $PSCustomObject.UserName
        $this.WorkflowCompleted     = $PSCustomObject.WorkflowCompleted
        $this.WorkflowPostponed     = $PSCustomObject.WorkflowPostponed
        $this.WorkflowStarted       = $PSCustomObject.WorkflowStarted
    }
}

class AMSNMPTriggerv10 : AMTriggerv10 {
    [bool]$AcceptUnathenticatedTrap            = $false
    [string]$Community                         = "Any"
    [System.Collections.ArrayList]$Credentials = [System.Collections.ArrayList]::new()
    [string]$Enterprise                        = "Any"
    [AMSnmpGenericType]$GenericType            = [AMSnmpGenericType]::Any
    [string]$IPEnd                             = "Any"
    [string]$IPStart                           = "Any"
    [bool]$OIDStringNotation                   = $true
    [string]$SpecificType                      = "Any"
    [bool]$TimetickStringNotation              = $false


    AMSNMPTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "SNMPTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::SNMPTrap
    }
    AMSNMPTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.AcceptUnathenticatedTrap = $PSCustomObject.AcceptUnathenticatedTrap
        $this.Community                = $PSCustomObject.Community
        $this.Enterprise               = $PSCustomObject.Enterprise
        $this.GenericType              = $PSCustomObject.GenericType
        $this.IPEnd                    = $PSCustomObject.IPEnd
        $this.IPStart                  = $PSCustomObject.IPStart
        $this.OIDStringNotation        = $PSCustomObject.OIDStringNotation
        $this.SpecificType             = $PSCustomObject.SpecificType
        $this.TimetickStringNotation   = $PSCustomObject.TimetickStringNotation
        foreach ($credential in $PSCustomObject.Credentials) {
            $this.Credentials.Add([AMSNMPTriggerCredentialv10]::new($credential, $this, $ConnectionAlias))
        }
    }
}

class AMSNMPTriggerCredentialv10 {
    [string]$__type                             = [string]::Empty
    [string]$ID                                 = [string]::Empty
    [string]$AuthenticationPassword             = [string]::Empty
    [AMEncryptionAlgorithm]$EncryptionAlgorithm = [AMEncryptionAlgorithm]::NoEncryption
    [string]$PrivacyPassword                    = [string]::Empty
    [string]$User                               = [string]::Empty
    AMSNMPTriggerCredentialv10() {
        $this.__type = "SNMPCredential:#AutoMate.Constructs.v10"
        $this.ID     = "{$((New-Guid).Guid)}"
    }
    AMSNMPTriggerCredentialv10([PSCustomObject]$PSCustomObject, [AMSNMPTriggerv10]$Trigger, [string]$ConnectionAlias) {
        $this.__type                 = "SNMPCredential:#AutoMate.Constructs.v10"
        $this.ID                     = $PSCustomObject.ID
        $this.AuthenticationPassword = $PSCustomObject.AuthenticationPassword
        $this.EncryptionAlgorithm    = $PSCustomObject.EncryptionAlgorithm
        $this.PrivacyPassword        = $PSCustomObject.PrivacyPassword
        $this.User                   = $PSCustomObject.User
        if ($ConnectionAlias -notin $null,[string]::Empty) {
            $this | Add-Member -Name "ConnectionAlias" -MemberType NoteProperty -Value $ConnectionAlias
        }
        $this | Add-Member -Name Trigger -MemberType NoteProperty -Value $Trigger
    }
}

class AMWindowTriggerv10 : AMTriggerv10 {
    [AMWindowAction]$Action = [AMWindowAction]::Open
    [bool]$CheckClass       = $false
    [bool]$CheckHandle      = $false
    [bool]$CheckTitle       = $false
    [bool]$CheckWindow      = $false
    [bool]$ChildWindow      = $false
    [string]$Class          = "*"
    [bool]$ContainsControls = $false
    [int]$Delay             = 1000
    [int]$Handle            = 0
    [bool]$HoldFocus        = $true
    [string]$Title          = "*"
    [bool]$TriggerOnce      = $false
    [System.Collections.ArrayList]$WindowControl = [System.Collections.ArrayList]::new()
    [string]$WindowParams   = [string]::Empty

    AMWindowTriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "WindowTriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::Window
    }
    AMWindowTriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.Action           = $PSCustomObject.Action
        $this.CheckClass       = $PSCustomObject.CheckClass
        $this.CheckHandle      = $PSCustomObject.CheckHandle
        $this.CheckTitle       = $PSCustomObject.CheckTitle
        $this.CheckWindow      = $PSCustomObject.CheckWindow
        $this.ChildWindow      = $PSCustomObject.ChildWindow
        $this.Class            = $PSCustomObject.Class
        $this.ContainsControls = $PSCustomObject.ContainsControls
        $this.Delay            = $PSCustomObject.Delay
        $this.Handle           = $PSCustomObject.Handle
        $this.HoldFocus        = $PSCustomObject.HoldFocus
        $this.Title            = $PSCustomObject.Title
        $this.TriggerOnce      = $PSCustomObject.TriggerOnce
        $this.WindowParams     = $PSCustomObject.WindowParams
        foreach ($control in $PSCustomObject.WindowControl) {
            $this.WindowControl.Add([AMWindowTriggerControlv10]::new($control, $this, $ConnectionAlias))
        }
    }
}

class AMWindowTriggerControlv10 {
    [string]$__type      = [string]::Empty
    [string]$ID          = [string]::Empty
    [string]$Name        = [string]::Empty
    [string]$Class       = [string]::Empty
    [string]$Value       = [string]::Empty
    [string]$Type        = [string]::Empty
    [string]$Xpos        = [string]::Empty
    [string]$Ypos        = [string]::Empty
    [bool]$CheckName     = $false
    [bool]$CheckClass    = $false
    [bool]$CheckValue    = $false
    [bool]$CheckType     = $false
    [bool]$CheckPosition = $false
    AMWindowTriggerControlv10() {
        $this.__type = "WindowControl:#AutoMate.Constructs.v10"
        $this.ID     = "{$((New-Guid).Guid)}"
    }
    AMWindowTriggerControlv10([PSCustomObject]$PSCustomObject, [AMWindowTriggerv10]$Trigger, [string]$ConnectionAlias) {
        $this.__type        = "WindowControl:#AutoMate.Constructs.v10"
        $this.ID            = $PSCustomObject.ID
        $this.Name          = $PSCustomObject.Name
        $this.Class         = $PSCustomObject.Class
        $this.Value         = $PSCustomObject.Value
        $this.Type          = $PSCustomObject.Type
        $this.Xpos          = $PSCustomObject.Xpos
        $this.Ypos          = $PSCustomObject.Ypos
        $this.CheckName     = $PSCustomObject.CheckName
        $this.CheckClass    = $PSCustomObject.CheckClass
        $this.CheckValue    = $PSCustomObject.CheckValue
        $this.CheckType     = $PSCustomObject.CheckType
        $this.CheckPosition = $PSCustomObject.CheckPosition
        if ($ConnectionAlias -notin $null,[string]::Empty) {
            $this | Add-Member -Name "ConnectionAlias" -MemberType NoteProperty -Value $ConnectionAlias
        }
        $this | Add-Member -Name Trigger -MemberType NoteProperty -Value $Trigger
    }
}

class AMWMITriggerv10 : AMTriggerv10 {
    [int]$IntervalInSeconds = 1
    [string]$MachineName    = [string]::Empty
    [string]$Namespace      = [string]::Empty
    [string]$Password       = [string]::Empty
    [string]$Username       = [string]::Empty
    [string]$WQLQuery       = [string]::Empty

    AMWMITriggerv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type      = "WMITriggerConstruct:#AutoMate.Constructs.v10"
        $this.TriggerType = [AMTriggerType]::WMI
    }
    AMWMITriggerv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.IntervalInSeconds = $PSCustomObject.IntervalInSeconds
        $this.MachineName       = $PSCustomObject.MachineName
        $this.Namespace         = $PSCustomObject.Namespace
        $this.Password          = $PSCustomObject.Password
        $this.Username          = $PSCustomObject.Username
        $this.WQLQuery          = $PSCustomObject.WQLQuery
    }
}

class AMUserv10 : AMAutomationConstructv10 {
    [string]$CipherPassword    = [string]::Empty
    [string]$ConditionFolderID = [string]::Empty
    [DateTime]$LockedOutOn     = (New-Object DateTime 1900, 1, 1, 0, 0, 0, ([DateTimeKind]::Utc))
    [string]$Password          = [string]::Empty
    [string]$ProcessFolderID   = [string]::Empty
    [AMUserRole]$Role          = [AMUserRole]::Developer
    [string]$TaskFolderID      = [string]::Empty
    [string]$Username          = [string]::Empty
    [string]$WorkflowFolderID  = [string]::Empty

    AMUserv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type = "UserConstruct:#AutoMate.Constructs.v10"
        $this.Type   = [AMConstructType]::User
    }
    AMUserv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.CipherPassword    = $PSCustomObject.CipherPassword
        $this.ConditionFolderID = $PSCustomObject.ConditionFolderID
        $this.LockedOutOn       = $PSCustomObject.LockedOutOn.ToLocalTime()
        $this.Password          = $PSCustomObject.Password
        $this.ProcessFolderID   = $PSCustomObject.ProcessFolderID
        $this.Role              = $PSCustomObject.Role
        $this.TaskFolderID      = $PSCustomObject.TaskFolderID
        $this.Username          = $PSCustomObject.Username
        $this.WorkflowFolderID  = $PSCustomObject.WorkflowFolderID
    }

    [AMFolderv10]GetConditionFolder() {
        $return = Get-AMFolder -ID $this.ConditionFolderID -Connection $this.ConnectionAlias
        return $return
    }
    [AMFolderv10]GetProcessFolder() {
        $return = Get-AMFolder -ID $this.ProcessFolderID -Connection $this.ConnectionAlias
        return $return
    }
    [AMFolderv10]GetTaskFolder() {
        $return = Get-AMFolder -ID $this.TaskFolderID -Connection $this.ConnectionAlias
        return $return
    }
    [AMFolderv10]GetWorkflowFolder() {
        $return = Get-AMFolder -ID $this.WorkflowFolderID -Connection $this.ConnectionAlias
        return $return
    }
}

class AMUserGroupv10 : AMAutomationConstructv10 {
    [System.Collections.ArrayList]$UserIDs = [System.Collections.ArrayList]::new()

    AMUserGroupv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type = "UserGroupConstruct:#AutoMate.Constructs.v10"
        $this.Type   = [AMConstructType]::UserGroup
    }
    AMUserGroupv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        foreach ($userID in $PSCustomObject.UserIDs) {
            $this.UserIDs.Add($userID)
        }
    }
    [AMUserv10[]]GetUsers() {
        $return = $this | Get-AMUser
        return $return
    }
}

class AMWorkflowv10 : AMAutomationConstructv10 {
    [System.Collections.ArrayList]$Items     = [System.Collections.ArrayList]::new()
    [System.Collections.ArrayList]$Links     = [System.Collections.ArrayList]::new()
    [AMLinkLayout]$LinkType                  = [AMLinkLayout]::Elbow
    [System.Collections.ArrayList]$Triggers  = [System.Collections.ArrayList]::new()
    [System.Collections.ArrayList]$Variables = [System.Collections.ArrayList]::new()
    [int]$ZoomFactor                         = 100

    AMWorkflowv10([string]$Name, [AMFolderv10]$Folder, [string]$ConnectionAlias) : Base($Name, $Folder, $ConnectionAlias) {
        $this.__type    = "WorkFlowConstruct:#AutoMate.Constructs.v10"
        $this.Type      = [AMConstructType]::Workflow
    }
    AMWorkflowv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.__type     = "WorkFlowConstruct:#AutoMate.Constructs.v10"
        $this.LinkType   = $PSCustomObject.LinkType
        $this.ZoomFactor = $PSCustomObject.ZoomFactor
        foreach ($variable in $PSCustomObject.Variables) {
            $this.Variables.Add([AMWorkflowVariablev10]::new($variable, $this, $ConnectionAlias))
        }
        foreach ($link in $PSCustomObject.Links) {
            $this.Links.Add([AMWorkflowLinkv10]::new($link, $this, $ConnectionAlias))
        }
        foreach ($trigger in $PSCustomObject.Triggers) {
            $this.Triggers.Add([AMWorkflowTriggerv10]::new($trigger, $this, $ConnectionAlias))
        }
        foreach ($item in $PSCustomObject.Items) {
            if ($item.___type -like "WorkFlowConditionConstruct*") {
                $this.Items.Add([AMWorkflowConditionv10]::new($item, $this, $ConnectionAlias))
            } else {
                $this.Items.Add([AMWorkflowItemv10]::new($item, $this, $ConnectionAlias))
            }
        }
        if ($PSCustomObject.PSObject.Properties.Name -contains "DurationInSeconds") {
            $this | Add-Member -Name "DurationInSeconds" -MemberType NoteProperty -Value $PSCustomObject.DurationInSeconds
        }
        if ($PSCustomObject.PSObject.Properties.Name -contains "Reactive") {
            $this | Add-Member -Name "Reactive" -MemberType NoteProperty -Value $PSCustomObject.Reactive
        }
        if ($PSCustomObject.PSObject.Properties.Name -contains "Scheduled") {
            $this | Add-Member -Name "Scheduled" -MemberType NoteProperty -Value $PSCustomObject.Scheduled
        }
    }
}

class AMWorkflowVariablev10 : AMObjectConstructv10 {
    [string]$CurrentValue            = [string]::Empty
    [AMWorkflowVarDataType]$DataType = [AMWorkflowVarDataType]::Variable
    [string]$Description             = [string]::Empty
    [string]$InitalValue             = [string]::Empty
    [bool]$Parameter                 = $false
    [bool]$Private                   = $false
    [AMWorkflowVarType]$VariableType = [AMWorkflowVarType]::Auto

    AMWorkflowVariablev10([string]$ConnectionAlias) : Base($ConnectionAlias) {
        $this.__type = "VariableConstruct:#AutoMate.Constructs.v10"
        $this.Type   = [AMConstructType]::WorkflowVariable
    }
    AMWorkflowVariablev10([PSCustomObject]$PSCustomObject, $Workflow, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.CurrentValue = $PSCustomObject.CurrentValue
        $this.DataType     = $PSCustomObject.DataType
        $this.Description  = $PSCustomObject.Description
        $this.InitalValue  = $PSCustomObject.InitalValue
        $this.Parameter    = $PSCustomObject.Parameter
        $this.Private      = $PSCustomObject.Private
        $this.VariableType = $PSCustomObject.VariableType
        $this | Add-Member -Name Workflow -MemberType NoteProperty -Value $Workflow
    }
}

class AMWorkflowLinkv10 : AMObjectConstructv10 {
    [string]$DestinationID             = [string]::Empty
    [PSCustomObject]$DestinationPoint = [PSCustomObject]@{X = 0; Y = 0}
    [AMLinkType]$LinkType             = [AMLinkType]::Blank
    [AMLinkResultType]$ResultType     = [AMLinkResultType]::Default
    [string]$SourceID                 = [string]::Empty
    [PSCustomObject]$SourcePoint      = [PSCustomObject]@{X = 0; Y = 0}
    [string]$Value                    = [string]::Empty
    [string]$WorkflowID               = [string]::Empty

    AMWorkflowLinkv10([string]$ConnectionAlias) : Base($ConnectionAlias) {
        $this.__type = "WorkFlowLinkConstruct:#AutoMate.Constructs.v10"
        $this.Type   = [AMConstructType]::WorkflowLink
    }
    AMWorkflowLinkv10([PSCustomObject]$PSCustomObject, $Workflow, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.DestinationID    = $PSCustomObject.DestinationID
        $this.DestinationPoint = $PSCustomObject.DestinationPoint
        $this.LinkType         = $PSCustomObject.LinkType
        $this.ResultType       = $PSCustomObject.ResultType
        $this.SourceID         = $PSCustomObject.SourceID
        $this.SourcePoint      = $PSCustomObject.SourcePoint
        $this.Value            = $PSCustomObject.Value
        $this.WorkflowID       = $PSCustomObject.WorkflowID
        $this | Add-Member -Name Workflow -MemberType NoteProperty -Value $Workflow
    }
    [AMWorkflowItemv10]GetSourceItem() {
        return ($this.Workflow.Items | Where-Object {$_.ID -eq $this.SourceID})
    }
    [AMWorkflowItemv10]GetDestinationItem() {
        return ($this.Workflow.Items | Where-Object {$_.ID -eq $this.DestinationID})
    }
}

class AMWorkflowItemv10 : AMObjectConstructv10 {
    [string]$AgentID                = [string]::Empty
    [string]$ConstructID            = [string]::Empty
    [AMConstructType]$ConstructType = [AMConstructType]::Undefined
    [bool]$Enabled                  = $true
    [int]$Height                    = 12
    [string]$Label                  = "Enter label here"
    [bool]$UseLabel                 = $false
    [int]$Width                     = 12
    [string]$WorkflowID             = [string]::Empty
    [int]$X                         = 0
    [int]$Y                         = 0

    AMWorkflowItemv10([string]$ConnectionAlias) : Base($ConnectionAlias) {
        $this.__type = "WorkFlowItemConstruct:#AutoMate.Constructs.v10"
        $this.Type   = [AMConstructType]::WorkflowItem
    }
    AMWorkflowItemv10([PSCustomObject]$PSCustomObject, $Workflow, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.AgentID       = $PSCustomObject.AgentID
        $this.ConstructID   = $PSCustomObject.ConstructID
        $this.ConstructType = $PSCustomObject.ConstructType
        $this.Enabled       = $PSCustomObject.Enabled
        $this.Height        = $PSCustomObject.Height
        $this.Label         = $PSCustomObject.Label
        $this.UseLabel      = $PSCustomObject.UseLabel
        $this.Width         = $PSCustomObject.Width
        $this.WorkflowID    = $PSCustomObject.WorkflowID
        $this.X             = $PSCustomObject.X
        $this.Y             = $PSCustomObject.Y
        $this | Add-Member -Name Workflow -MemberType NoteProperty -Value $Workflow
    }
    [AMAutomationConstructv10]GetAgent() {
        $return = Get-AMObject -ID $this.AgentID -Types Agent,AgentGroup -Connection $this.ConnectionAlias
        return $return
    }
    [AMAutomationConstructv10]GetConstruct() {
        $return = Get-AMObject -ID $this.ConstructID -Types $this.ConstructType -Connection $this.ConnectionAlias
        return $return
    }
}

class AMWorkflowTriggerv10 : AMWorkflowItemv10 {
    [AMTriggerType]$TriggerType

    AMWorkflowTriggerv10([string]$ConnectionAlias) : Base($ConnectionAlias) {
        $this.__type = "WorkFlowTriggerConstruct:#AutoMate.Constructs.v10"
    }
    AMWorkflowTriggerv10([PSCustomObject]$PSCustomObject, $Workflow, [string]$ConnectionAlias) : Base($PSCustomObject, $Workflow, $ConnectionAlias) {
        $this.TriggerType = $PSCustomObject.TriggerType
    }
}

class AMWorkflowConditionv10 : AMWorkflowItemv10 {
    [string]$Expression

    AMWorkflowConditionv10([string]$ConnectionAlias) : Base($ConnectionAlias) {
        $this.__type        = "WorkFlowConditionConstruct:#AutoMate.Constructs.v10"
        $this.ConstructType = [AMConstructType]::Evaluation
    }
    AMWorkflowConditionv10([PSCustomObject]$PSCustomObject, $Workflow, [string]$ConnectionAlias) : Base($PSCustomObject, $Workflow, $ConnectionAlias) {
        $this.Expression = $PSCustomObject.Expression
    }
}

class AMWorkflowPropertyv10 : AMAutomationConstructv10 {
    [System.Collections.ArrayList]$Constants            = [System.Collections.ArrayList]::new()
    [string]$DefaultAgentID                             = [string]::Empty
    [string]$DefaultAgentPropertiesInheritancePath      = [string]::Empty
    [bool]$DefaultAgentPropertiesSpecified              = $false
    [bool]$DisableOnFailure                             = $false
    [string]$ErrorNotificationPropertiesInheritancePath = [string]::Empty
    [bool]$ErrorNotificationPropertiesSpecified         = $false
    [string]$ErrorNotifyEmailFromAddress                = [string]::Empty
    [string]$ErrorNotifyEmailToAddress                  = [string]::Empty
    [string]$ErrorRunTaskName                           = [string]::Empty
    [bool]$ResumeFromFailure                            = $false
    [int]$Timeout                                       = 0
    [bool]$TimeoutEnabled                               = $false
    [string]$TimeoutPropertiesInheritancePath           = [string]::Empty
    [bool]$TimeoutPropertiesSpecified                   = $false
    [AMTimeMeasure]$TimeoutUnit                         = [AMTimeMeasure]::Minutes

    AMWorkflowPropertyv10([PSCustomObject]$PSCustomObject, [string]$ConnectionAlias) : Base($PSCustomObject, $ConnectionAlias) {
        $this.Constants                                  = $PSCustomObject.Constants
        $this.DefaultAgentID                             = $PSCustomObject.DefaultAgentID
        $this.DefaultAgentPropertiesInheritancePath      = $PSCustomObject.DefaultAgentPropertiesInheritancePath
        $this.DefaultAgentPropertiesSpecified            = $PSCustomObject.DefaultAgentPropertiesSpecified
        $this.DisableOnFailure                           = $PSCustomObject.DisableOnFailure
        $this.ErrorNotificationPropertiesInheritancePath = $PSCustomObject.ErrorNotificationPropertiesInheritancePath
        $this.ErrorNotificationPropertiesSpecified       = $PSCustomObject.ErrorNotificationPropertiesSpecified
        $this.ErrorNotifyEmailFromAddress                = $PSCustomObject.ErrorNotifyEmailFromAddress
        $this.ErrorNotifyEmailToAddress                  = $PSCustomObject.ErrorNotifyEmailToAddress
        $this.ErrorRunTaskName                           = $PSCustomObject.ErrorRunTaskName
        $this.ResumeFromFailure                          = $PSCustomObject.ResumeFromFailure
        $this.Timeout                                    = $PSCustomObject.Timeout
        $this.TimeoutEnabled                             = $PSCustomObject.TimeoutEnabled
        $this.TimeoutPropertiesInheritancePath           = $PSCustomObject.TimeoutPropertiesInheritancePath
        $this.TimeoutPropertiesSpecified                 = $PSCustomObject.TimeoutPropertiesSpecified
        $this.TimeoutUnit                                = $PSCustomObject.TimeoutUnit
        foreach ($constant in $PSCustomObject.Constants) {
            $this.Constants.Add([AMConstantv10]::new($constant, $ConnectionAlias))
        }
    }
}