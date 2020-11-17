---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMObject.md
schema: 2.0.0
---

# Get-AMObject

## SYNOPSIS
Retrieves any Automate object by ID.

## SYNTAX

```
Get-AMObject [-ID] <Object> [[-Types] <AMConstructType[]>] [[-Connection] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get-AMObject allows search for any Automate object by its ID when the construct type is not known.

## EXAMPLES

### EXAMPLE 1
```
Get-AMObject -ID "{1525ea3b-45cc-4ee1-9b34-8ea855c3b299}"
```

## PARAMETERS

### -ID
The ID to search for.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Types
The construct types to search, all are searched by default.

```yaml
Type: AMConstructType[]
Parameter Sets: (All)
Aliases:
Accepted values: Undefined, Folder, Task, Workflow, Condition, RootContainer, UserPreference, Agent, MachineConnection, User, AgentGroup, UserGroup, Evaluation, Comment, AuditEvent, ExecutionEvent, Connection, Wait, Joiner, Exclusion, ServerProperty, WorkflowProperty, AgentProperty, TaskProperty, Constant, Package, AMSystem, Permission, SystemPermission, Process, WorkflowItemProperty, WorkflowItem, WorkflowLink, WorkflowVariable, ExecutionServerProperty, ManagementServerProperty, ManagedTaskProperty, Snapshot, ExclusionPeriod, SnapshotInfo, Notification, Instance, ApiPermission, SNMPCredential, WindowsControl, SystemAgent, WorkflowTrigger, WorkflowCondition

Required: False
Position: 2
Default value: @([AMConstructType]::Workflow, `
                                       [AMConstructType]::Task, `
                                       [AMConstructType]::Process, `
                                       [AMConstructType]::Condition, `
                                       [AMConstructType]::Agent, `
                                       [AMConstructType]::AgentGroup, `
                                       [AMConstructType]::User, `
                                       [AMConstructType]::UserGroup, `
                                       [AMConstructType]::Folder
                                      )
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
The server to search.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### AMAutomationConstructv10
### AMAutomationConstructv11
## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMObject.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMObject.md)

