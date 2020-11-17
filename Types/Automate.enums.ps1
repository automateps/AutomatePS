#region Construct Types
enum AMConstructType {
    Undefined         = 0
    Folder            = 1
    Task              = 2
    Workflow          = 3
    Condition         = 4
    RootContainer     = 5
    UserPreference    = 7
    Agent             = 8
    MachineConnection = 9
    User              = 10
    AgentGroup        = 11
    UserGroup         = 12
    Evaluation        = 13
    Comment           = 14
    AuditEvent        = 16
    ExecutionEvent    = 17
    Connection        = 18
    Wait              = 19
    Joiner            = 20
    Exclusion         = 21
    ServerProperty    = 22
    WorkflowProperty  = 23
    AgentProperty     = 24
    TaskProperty      = 25
    Constant          = 26
    Package           = 27
    AMSystem          = 30
    Permission        = 34
    SystemPermission  = 35
    Process           = 40
    WorkflowItemProperty = 46
    WorkflowItem      = 47
    WorkflowTrigger   = 470 # Also 47, but we only use this in Get-AMObjectType
    WorkflowCondition = 471 # Also 47, but we only use this in Get-AMObjectType
    WorkflowLink      = 48
    WorkflowVariable  = 49
    ExecutionServerProperty = 50
    ManagementServerProperty = 51
    ManagedTaskProperty = 54
    Snapshot          = 58
    ExclusionPeriod   = 61
    SnapshotInfo      = 63
    Notification      = 64
    Instance          = 65
    ApiPermission     = 66
    SNMPCredential    = 67
    WindowsControl    = 68
    SystemAgent       = 100 # Used for parameter auto-completion only, not an API type
}

enum AMTriggerType {
    All         = -1
    Undefined   = 0
    Logon       = 1
    Window      = 2
    Schedule    = 3
    Keyboard    = 4
    Idle        = 5
    Performance = 6
    EventLog    = 7
    FileSystem  = 8
    Process     = 9
    Service     = 10
    SNMPTrap    = 11
    WMI         = 12
    Time        = 13
    Database    = 14
    SharePoint  = 15
    Email       = 16
}

enum AMAgentType {
    All          = -1
    Unknown      = 0
    TaskAgent    = 1
    ProcessAgent = 2
}

enum AMAgentUpgradeStep {
    Unknown       = 0
    Normal        = 1
    Upgrading     = 2
    UpgradeFailed = 3
}

enum AMConstantType {
    Constant      = 1
    SQLConnection = 2
}

enum AMEventMonitorAutoStartModeType {
    FirstComeFirstServed = 0
    ConsoleOnly          = 1
    TerminalServiceUser  = 2
    Off                  = 3
}

enum AMPrefsShowTrayIcon {
    Always  = 1
    Never   = 2
    RunOnly = 3
}

enum AMProxyType {
    NoProxy = 0
    Socks4  = 1
    Socks4a = 2
    Socks5  = 3
    HTTP    = 4
}

enum AMSocksType {
    NoProxy = 1
    Socks4  = 2
    Socks4a = 3
    Socks5  = 4
    HTTP    = 5
}

enum AMSecurityType {
    None     = 0
    Explicit = 1
    Implicit = 2
}

enum AMHttpProtocol {
    HTTPS = 0
    HTTP  = 1
}

enum AMCountLimitationType {
    AlwaysRun    = 1
    SameInstance = 2
    AnyInstance  = 3
    RunAlone     = 4
}

enum AMNotificationType {
    Email    = 0
    IM       = 1
    Facebook = 2
    Twitter  = 3
}

enum AMRunAsUser {
    LoggedonUser   = 1
    SpecifiedUser  = 2
    BackgroundUser = 3
    DoNotRun       = 4
}

enum AMUserRole {
    Guest         = 0
    Developer     = 100
    Administrator = 999
    Manager       = 2000
}
#endregion

#region Workflow types
enum AMWorkflowVarType {
    Auto   = 1
    Text   = 2
    Number = 3
}

enum AMLinkType {
    Blank   = 1
    Success = 2
    Failure = 3
    Result  = 4
}

enum AMLinkResultType {
    Default = 0
    True    = 1
    False   = 2
    Value   = 3
}

enum AMLinkLayout {
    Straight = 1
    Elbow    = 2
}

enum AMWorkflowVarDataType {
    Variable = 1
    Array    = 2
    Dataset  = 3
}
#endregion

#region Task types
enum AMTaskFailureAction {
    Success = 1
    Failure = 2
    ReturnResult = 3
}

enum AMTaskIsolation {
    Default = 0
    Always  = 1
    Never   = 2
}

enum AMConcurrencyType {
    AlwaysRun                      = 1
    RunningInstancesBelowThreshold = 2
    RunningTasksBelowThreshold     = 3
    RunWithNoOtherTasks            = 4
}

enum AMPriorityAction {
    Hold               = 1
    DoNotRun           = 2
    HoldInterrupt      = 3
    HoldTimeout        = 4
    InterruptTasks     = 5
    InterruptInstances = 6
}
#endregion

#region Process types
enum AMRunProcessAs {
    Default = 1
    SH      = 2
    Bash    = 3
}
#endregion

#region Condition types
enum AMConditionUserMode {
    NoUser        = 1
    DefaultUser   = 2
    SpecifiedUser = 3
}
#endregion

#region Schedule Condition types
enum AMScheduleType {
    Custom         = 0
    SecondInterval = 1
    MinuteInterval = 2
    HourInterval   = 3
    DayInterval    = 4
    WeekInterval   = 5
    MonthInterval  = 6
    Holidays       = 7
}

enum AMScheduleMeasure {
    Day       = 0
    WorkDay   = 1
    Monday    = 2
    Tuesday   = 3
    Wednesday = 4
    Thursday  = 5
    Friday    = 6
    Saturday  = 7
    Sunday    = 8
}

enum AMOnTaskLateRescheduleOption {
    RunImmediately      = 0
    IgnoreAndReschedule = 1
    DisableTrigger      = 3
}

enum AMRescheduleOption {
    RelativeToOriginalTime  = 0
    RelativeToTriggeredTime = 1
    DisableTrigger          = 2
}
#endregion

#region Keyboard Condition types
enum AMKeyboardConditionKeyType {
    Hotkey = 1
    Text   = 2
}
#endregion

#region Window Condition types
enum AMWindowAction {
    Open       = 0
    Close      = 1
    Focus      = 2
    Background = 3
}
#endregion

#region Logon Condition types
enum AMLogonAction {
    RunAsLoggedOnUser   = 1
    LogonSpecifiedUser  = 2 # Same as unlock
    RunAsBackgroundUser = 3
    DoNotRun            = 4
}
#endregion

#region Event Log Condition types
enum AMEventLogTriggerEventType {
    Information  = 0
    Warning      = 1
    Error        = 2
    SuccessAudit = 3
    FailAudit    = 4
    Any          = 5
}
#endregion

#region Database Condition types
enum AMDatabaseTriggerType {
    SQL    = 0
    Oracle = 1
}
#endregion

#region Performance Condition types
enum AMPerformanceOperator {
    Below = 0
    Above = 1
}
#endregion

#region Process Condition types
enum AMProcessTriggerState {
    Started           = 1
    Ended             = 2
    StoppedResponding = 3
}
#endregion

#region Service Condition types
enum AMServiceTriggerState {
    StoppedResponding = 0
    Started           = 1
    Stopped           = 2
    Resumed           = 3
    Paused            = 4
    Installed         = 5
    Removed           = 6
}
#endregion

#region SNMP Condition types
enum AMSnmpGenericType {
    Any                   = 0
    ColdStart             = 1
    WarmStart             = 2
    LinkDown              = 3
    LinkUp                = 4
    AuthenticationFailure = 5
    EGPNeighborLoss       = 6
    EnterpriseSpecific    = 7
}
#endregion

#region SharePoint Condition types
enum AMSharePointScope {
    Web  = 0
    List = 1
}
#endregion

#region Email Condition types
enum AMEmailFilterType {
    Sent     = 0
    Received = 1
}

enum AMGetEmailProtocol {
    Webdav = 2
    EWS    = 3
}

enum AMSendEmailProtocol {
    SMTP   = 0
    Webdav = 1
    EWS    = 2
}

enum AMWebDavAuthentication {
    Basic   = 0
    Default = 1
    Form    = 2
}

enum AMEmailVersion {
    Exchange2007SP1 = 0
    Exchange2010    = 1
    Exchange2010SP1 = 2
    Exchange2010SP2 = 3
    Exchange2013    = 4
}
#endregion

#region Instance types
enum AMInstanceStatus {
    All       = -1
    Completed = -2
    Unknown   = 0
    Success   = 1
    Failed    = 2
    Aborted   = 3
    Stopped   = 4
	TimedOut  = 7
    Paused    = 9
    Queued    = 11
    Running   = 12
    ResumedFromFailure = 13
    #Error = ?
}
#endregion

#region Generic types
enum AMTimeMeasure {
    Seconds      = 0
    Minutes      = 1
    Hours        = 2
    Days         = 3
    Milliseconds = 4
}

enum AMEncryptionAlgorithm {
    NoEncryption = 0
    DES          = 1
    AES          = 2
    TripleDES    = 3
}

enum AMRunResult {
    Undefined = 0
    Success = 1
    Failure = 2
    Aborted = 3
    Stopped = 4
    NotAvailable = 14
}

enum AMCompletionState {
    InDevelopment = 0
    Testing       = 1
    Production    = 2
    Archive       = 3
}

enum AMConnectionType {
    System  = 0
    Host    = 1
    Session = 2
}
#endregion

enum AMAuditEventType {
    All = -1

    # Workflow event types
    WorkflowCreated  = 1000
    WorkflowRemoved  = 1001
    WorkflowEdited   = 1002
    WorkflowEnabled  = 1003
    WorkflowDisabled = 1004
    WorkflowRenamed  = 1005
    WorkflowMoved    = 1006
    WorkflowPropertiesModified  = 1007
    WorkflowExported = 1008
    WorkflowImported = 1009
    WorkflowPermissionsModified = 1010

    # Task event types
    TaskCreated  = 1100
    TaskRemoved  = 1101
    TaskEdited   = 1102
    TaskEnabled  = 1103
    TaskDisabled = 1104
    TaskRenamed  = 1105
    TaskMoved    = 1106
    TaskPropertiesModified = 1107
    TaskExported = 1108
    TaskImported = 1109
    TaskPermissionsModified = 1110

    # Condition event types
    ConditionCreated  = 1200
    ConditionRemoved  = 1201
    ConditionEdited   = 1202
    ConditionEnabled  = 1203
    ConditionDisabled = 1204
    ConditionRenamed  = 1205
    ConditionMoved    = 1206
    ConditionPropertiesModified = 1207
    ConditionExported = 1208
    ConditionImported = 1209
    ConditionPermissionsModified = 1210

    # Process event types
    ProcessCreated  = 1900
    ProcessRemoved  = 1901
    ProcessEdited   = 1902
    ProcessEnabled  = 1903
    ProcessDisabled = 1904
    ProcessRenamed  = 1905
    ProcessMoved    = 1906
    ProcessPropertiesModified = 1907
    ProcessExported = 1908
    ProcessImported = 1909
    ProcessPermissionsModified = 1910

    # Agent event types
    AgentConnected            = 300
    AgentDisconnected         = 301
    AgentDisconnectedByServer = 302
    TaskAgentUpgrading        = 303
    TaskAgentConnected        = 304
    ProcessAgentConnected     = 305
    TaskAgentDisconnected     = 308
    ProcessAgentDisconnected  = 309
    AgentRegistered           = 1400
    AgentRemoved              = 1401
    AgentEnabled              = 1402
    AgentDisabled             = 1403
    AgentMoved                = 1404
    AgentPropertiesModified   = 1405
    AgentRenamed              = 1406
    AgentPermissionsModified  = 1407

    # Agent group event types
    AgentGroupCreated  = 1700
    AgentGroupRemoved  = 1701
    AgentGroupEdited   = 1702
    AgentGroupEnabled  = 1703
    AgentGroupDisabled = 1704
    AgentGroupRenamed  = 1705
    AgentGroupMoved    = 1706
    AgentGroupPropertiesModified = 1707
    AgentGroupPermissionsModified = 1708

    # User event types
    UserLoggedOn        = 200
    UserLogonDenied     = 201
    UserLoggedOff       = 202
    UserConnectedSMC    = 306
    UserConnectedWFD    = 307
    UserDisconnectedSMC = 310
    UserDisconnectedWFD = 311
    UserConnectedWebSMC = 312
    UserDisconnectedWebSMC = 313
    UserCreated         = 1300
    UserRemoved         = 1301
    UserEdited          = 1302
    UserEnabled         = 1303
    UserDisabled        = 1304
    UserMoved           = 1305
    UserPropertiesModified = 1306
    UserPermissionsModified = 1307

    # User group event types
    UserGroupCreated  = 1800
    UserGroupRemoved  = 1801
    UserGroupEdited   = 1802
    UserGroupEnabled  = 1803
    UserGroupDisabled = 1804
    UserGroupRenamed  = 1805
    UserGroupMoved    = 1806
    UserGroupPropertiesModified = 1807
    UserGroupPermissionsModified = 1808

    # Folder event types
    FolderCreated = 1600
    FolderRemoved = 1601
    FolderRenamed = 1602
    FolderMoved   = 1603
    FolderPropertiesModified = 1604
    FolderPermissionsModified = 1605
    FolderExported = 1606
    FolderImported = 1607

    # Revision management event types
    RevisionUpdated            = 2000
    RevisionDeleted            = 2001
    RevisionRestored           = 2002
    RevisionDeletedRecycleBin  = 2003
    RevisionRestoredRecycleBin = 2004

    # Credential event types
    CredentialCreated  = 2100
    CredentialModified = 2101
    CredentialRemoved  = 2102

    # Server event types
    LicenseAdded             = 400
    LicenseRemoved           = 401
    ServerPropertiesModified = 1500
    ServerPermissionsModifed = 1501
    ApiPermissionsModified   = 1502
    RevisionManagementPropertiesModified = 1503

    # Miscellaneous
    ConnectionOpened               = 100
    ConnectionClosed               = 101
    SkybotConnected                = 314
    SkybotDisconnected             = 315
    AMExecuteConnected             = 316
    AMExecuteDisconnected          = 317
    InterMapperConnected           = 318
    InterMapperDisconnected        = 319
    ScheduleEnterpriseConnected    = 320
    ScheduleEnterpriseDisconnected = 321
}

enum AMEventStatusType {
    Success = 0
    Failure = 1
    Warning = 2
    Denied  = 3
}

enum AMCalendarType {
    Gregorian = 0
    Islamic   = 6
    Hebrew    = 8
}