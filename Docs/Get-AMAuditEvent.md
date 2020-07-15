---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMAuditEvent.md
schema: 2.0.0
---

# Get-AMAuditEvent

## SYNOPSIS
Gets Automate audit events.

## SYNTAX

### All (Default)
```
Get-AMAuditEvent [-StartDate <DateTime>] [-EndDate <DateTime>] [-EventType <AMAuditEventType>]
 [-FilterSet <Hashtable[]>] [-FilterSetMode <String>] [-SortProperty <String[]>] [-SortDescending]
 [-Connection <Object>] [<CommonParameters>]
```

### ByPipeline
```
Get-AMAuditEvent [[-InputObject] <Object>] [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-EventType <AMAuditEventType>] [-FilterSet <Hashtable[]>] [-FilterSetMode <String>]
 [-SortProperty <String[]>] [-SortDescending] [-AuditUserActivity] [-Connection <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMAuditEvent gets audit events for Automate objects.

## EXAMPLES

### EXAMPLE 1
```
# Get events for workflow "My Workflow"
Get-AMWorkflow "My Workflow" | Get-AMAuditEvent
```

### EXAMPLE 2
```
# Get audit events using filter sets
Get-AMAuditEvent -FilterSet @{Property = 'EventText'; Operator = 'contains'; Value = 'connection from IP 10.1.1.10'}
```

## PARAMETERS

### -InputObject
The object(s) to retrieve audit events for.

```yaml
Type: Object
Parameter Sets: ByPipeline
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -StartDate
The first date of events to retrieve (Default: 1 day ago).

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).AddDays(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The last date of events to retrieve (Default: now).

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventType
The type of event(s) to be retrieved. 
Use auto-complete or see types.ps1 for a full list.

```yaml
Type: AMAuditEventType
Parameter Sets: (All)
Aliases:
Accepted values: ConnectionOpened, ConnectionClosed, UserLoggedOn, UserLogonDenied, UserLoggedOff, AgentConnected, AgentDisconnected, AgentDisconnectedByServer, TaskAgentUpgrading, TaskAgentConnected, ProcessAgentConnected, UserConnectedSMC, UserConnectedWFD, TaskAgentDisconnected, ProcessAgentDisconnected, UserDisconnectedSMC, UserDisconnectedWFD, UserConnectedWebSMC, UserDisconnectedWebSMC, SkybotConnected, SkybotDisconnected, AMExecuteConnected, AMExecuteDisconnected, InterMapperConnected, InterMapperDisconnected, ScheduleEnterpriseConnected, ScheduleEnterpriseDisconnected, LicenseAdded, LicenseRemoved, WorkflowCreated, WorkflowRemoved, WorkflowEdited, WorkflowEnabled, WorkflowDisabled, WorkflowRenamed, WorkflowMoved, WorkflowPropertiesModified, WorkflowExported, WorkflowImported, WorkflowPermissionsModified, TaskCreated, TaskRemoved, TaskEdited, TaskEnabled, TaskDisabled, TaskRenamed, TaskMoved, TaskPropertiesModified, TaskExported, TaskImported, TaskPermissionsModified, ConditionCreated, ConditionRemoved, ConditionEdited, ConditionEnabled, ConditionDisabled, ConditionRenamed, ConditionMoved, ConditionPropertiesModified, ConditionExported, ConditionImported, ConditionPermissionsModified, UserCreated, UserRemoved, UserEdited, UserEnabled, UserDisabled, UserMoved, UserPropertiesModified, UserPermissionsModified, AgentRegistered, AgentRemoved, AgentEnabled, AgentDisabled, AgentMoved, AgentPropertiesModified, AgentRenamed, AgentPermissionsModified, ServerPropertiesModified, ServerPermissionsModifed, ApiPermissionsModified, RevisionManagementPropertiesModified, FolderCreated, FolderRemoved, FolderRenamed, FolderMoved, FolderPropertiesModified, FolderPermissionsModified, FolderExported, FolderImported, AgentGroupCreated, AgentGroupRemoved, AgentGroupEdited, AgentGroupEnabled, AgentGroupDisabled, AgentGroupRenamed, AgentGroupMoved, AgentGroupPropertiesModified, AgentGroupPermissionsModified, UserGroupCreated, UserGroupRemoved, UserGroupEdited, UserGroupEnabled, UserGroupDisabled, UserGroupRenamed, UserGroupMoved, UserGroupPropertiesModified, UserGroupPermissionsModified, ProcessCreated, ProcessRemoved, ProcessEdited, ProcessEnabled, ProcessDisabled, ProcessRenamed, ProcessMoved, ProcessPropertiesModified, ProcessExported, ProcessImported, ProcessPermissionsModified, RevisionUpdated, RevisionDeleted, RevisionRestored, RevisionDeletedRecycleBin, RevisionRestoredRecycleBin, All

Required: False
Position: Named
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterSet
The parameters to filter the search on. 
Supply hashtable(s) with the following properties: Property, Operator, Value.
Valid values for the Operator are: =, !=, \<, \>, contains (default - no need to supply Operator when using 'contains')

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterSetMode
If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: And
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortProperty
The object property to sort results on. 
Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: EventDateTime
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortDescending
If specified, this will sort the output on the specified SortProperty in descending order. 
Otherwise, ascending order is assumed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuditUserActivity
If this switch is supplied, then this function returns any audited events that were performed by the piped in user.
Otherwise,
    audit events related to the user object are returned.

```yaml
Type: SwitchParameter
Parameter Sets: ByPipeline
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
The Automate management server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Audit events for the following objects can be retrieved by this function:
### Workflow
### Task
### Condition
### Process
### TaskAgent
### ProcessAgent
### AgentGroup
### User
### UserGroup
### Folder
## OUTPUTS

### AuditEvent
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMAuditEvent.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMAuditEvent.md)

