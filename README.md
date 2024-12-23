AutomatePS PowerShell Module
===================

AutomatePS provides a PowerShell interface with Help Systems' Automate Enterprise.

----------
Installing the Module
-------------

Install this module from the PSGallery using:
```PowerShell
Install-Module AutomatePS
```

----------
Using the Module
-------------
### Connecting to a Automate Enterprise/Plus/Ultimate server
To connect to an Automate Server using credentials:
```PowerShell
$myCredential = Get-Credential
Connect-AMServer "AMserver01" -Credential $myCredential
```

To connect to an Automate Server (v23.1 and later) using an API key:
```PowerShell
Connect-AMServer "AMserver01" -ApiKey 42xGBhxxWoWL/SXIUxxxB+UWO7tBxx81
```
NOTE: When using an API key to authenticate, AutomatePS cannot currently determine the user associated with the key. Therefore,  functions that, by default, place new objects in your user folder will instead place new objects in the root folder.

To disconnect:
```PowerShell
# Disconnect from single server
Disconnect-AMServer "AMserver01"

# Disconnect from all servers
Disconnect-AMServer
```
----------

### Getting Objects
AutomatePS supports retrieving a majority of Automate object types using these functions:
```PowerShell
# Retrieve common objects from AM
Get-AMAgent
Get-AMAgentGroup
Get-AMCondition
Get-AMFolder
Get-AMInstance
Get-AMPermission
Get-AMProcess
Get-AMSystemPermission
Get-AMTask
Get-AMUser
Get-AMUserGroup
Get-AMWorkflow
```
Some examples:
```PowerShell
# Get process by name
Get-AMProcess -Name "Some Process"

# Get workflow by ID
Get-AMWorkflow -ID "{b774c4e5-61df-4fc8-be78-149d918c605b}"

# Get folder by path
Get-AMFolder -Path "\WORKFLOWS\My Folder\"
```
Most of these functions support pipeline input for getting related objects.  For example:
```PowerShell
# Retrieve agents belonging to group "AgentGroup1"
Get-AMAgentGroup "AgentGroup1" | Get-AMAgent

# Retrieve workflows containing task "Create File"
Get-AMTask "Create File" | Get-AMWorkflow

# Retrieve workflows containing workflow "Child Workflow"
Get-AMWorkflow "Child Workflow" | Get-AMWorkflow -Parent

# Get permissions for a folder
Get-AMFolder "FTP Tasks" | Get-AMPermission

# Get conditions that run on agent "Agent1"
Get-AMAgent "Agent1" | Get-AMCondition
```
Other Get functions include:
```PowerShell
Get-AMAuditEvent
Get-AMCalendar
Get-AMConsoleOutput
Get-AMExecutionEvent
Get-AMMetric
Get-AMServer
```
Some examples:
```PowerShell
# Get audit events for WebSMC logins in the past 30 days
Get-AMAuditEvent -StartDate (Get-Date).AddDays(-30) -EventType UserConnectedWeb

# Get audit events for when workflow "Encrypt and FTP Files" was edited
Get-AMWorkflow -Name "Encrypt and FTP Files" | Get-AMAuditEvent -EventType WorkflowEdited

# Get execution events for workflow "Encrypt and FTP Files" in the past 2 weeks
Get-AMWorkflow "Encrypt and FTP Files" | Get-AMExecutionEvent -StartDate (Get-Date).AddDays(-14)

# Get upcoming events in the next 2 days for all workflows in folder "File Transfers"
Get-AMFolder "File Transfers" -Type "WORKFLOWS" | Get-AMCalendar -EndDate (Get-Date).AddDays(2)
```

If you have a large number of objects in your environment, calling these functions without any sort of filter could be slow.  It is recommended that you supply a name, an ID, or use the FilterSet parameter available on many object types to filter the call to the API.  This could dramatically improve performance.  See the following example on how to use the FilterSet parameter:

```PowerShell
# Gets all disabled workflows
$filterSet = @{
    Property = "Enabled"  # The property of the object to filter on
    Operator = "="        # Valid values: =, !=, <, >, contains
    Value    = "false"    # The value to use in the comparison
}
Get-AMWorkflow -FilterSet $filterSet
```

Additionally, these filter sets can be combined by supplying multiple filter set hashtables in an array, as shown here:

```PowerShell
# Gets all disabled workflows that have "FTP" in the name
$filterSet = @()
$filterSet += @{
    Property = "Enabled"
    Operator = "="
    Value    = "false"
}
$filterSet += @{
    Property = "Name"
    Operator = "contains"  # contains is the default operator, and does not have to be specified
    Value    = "FTP"
}
Get-AMWorkflow -FilterSet $filterSet                   # AND's the filter sets together
Get-AMWorkflow -FilterSet $filterSet -FilterSetMode Or # OR's the filter sets together
```

----------
### Enabling, Disabling, Locking, Unlocking, Moving, Removing and Renaming Objects
AutomatePS supports modifying a majority of object types using these functions:
```PowerShell
Enable-AMObject
Disable-AMObject
Lock-AMObject
Unlock-AMObject
Move-AMObject
Remove-AMObject
Remove-AMPermission
Remove-AMSystemPermission
Rename-AMObject
```
For example:
```PowerShell
# Disable the "Start Service" process object
Get-AMProcess "Start Service" | Enable-AMObject

# Disable user "David"
Get-AMUser "David" | Disable-AMObject

# Lock and unlock task "Delete Files"
Get-AMTask "Delete Files" | Lock-AMObject
Get-AMTask "Delete Files" | Unlock-AMObject

# Remove workflow "Some Useless Workflow"
Get-AMWorkflow "Some Useless Workflow" | Remove-AMObject                 # With confirmation
Get-AMWorkflow "Some Useless Workflow" | Remove-AMObject -Confirm:$false # Without confirmation

# Note: Remove-AMObject will output warnings for any objects that are dependent on the objects being 
#       removed. As long as confirmation isn't skipped with -Confirm:$false, you will have the 
#       opportunity to cancel.
Get-AMWorkflow "Child Workflow" | Remove-AMObject -WhatIf
WARNING: Workflow 'Child Workflow' is used in workflow 'Parent Workflow'
What if: Performing the operation "Removing Workflow: \WORKFLOWS\Some Folder\Child Workflow" on target "server1".

# Rename process "Start Service"
Get-AMProess "Start Service" | Rename-AMObject "Restart Service"
```

----------
### Starting Workflows, Tasks and Processes
```PowerShell
# Start workflow "FTP File"
Get-AMWorkflow "FTP File" | Start-AMWorkflow

# Start task "Cleanup Files" on agent "Agent1"
# Reference "Agent1" by name:
Get-AMTask "Cleanup Files" | Start-AMTask -Agent "Agent1"

# OR, pass "Agent1" object:
$agent1 = Get-AMAgent "Agent1"
Get-AMTask "Cleanup Files" | Start-AMTask -Agent $agent1

# Start process "Delete Logs" on agent "ProcessAgent1"
Get-AMProcess "Delete Logs" | Start-AMProcess -Agent "ProcessAgent1"
```

----------

### Managing Instances of Workflows and Tasks
```PowerShell
# Stop workflow "FTP File"
Get-AMWorkflow "FTP File" | Get-AMInstance -Status Running | Stop-AMInstance

# The same functions work for running Task instances
Get-AMTask "Cleanup Files" | Get-AMInstance -Status Running | Stop-AMInstance

# Wait for an instance to complete
Get-AMInstance -Status Running | Wait-AMInstance

# Suspend and resume a task
$instance = Get-AMTask "Cleanup Files" | Get-AMInstance -Status Running | Suspend-AMInstance
$instance | Resume-AMInstance
```
----------

### Create New Objects
AutomatePS supports creating new objects using the following functions:
```PowerShell
New-AMAgent
New-AMAgentGroup
New-AMDatabaseCondition
New-AMEmailCondition
New-AMEventLogCondition
New-AMFileSystemCondition
New-AMFolder
New-AMIdleCondition
New-AMKeyboardCondition
New-AMLogonCondition
New-AMObject
New-AMPerformanceCondition
New-AMPermission
New-AMProcess
New-AMProcessCondition
New-AMScheduleCondition
New-AMServiceCondition
New-AMSharePointCondition
New-AMSnmpCondition
New-AMTask
New-AMUser
New-AMUserGroup
New-AMWindowCondition
New-AMWmiCondition
New-AMWorkflow
```
----------

### Modify Existing Objects
AutomatePS supports modifying existing objects using the following functions:
```PowerShell
Set-AMAgent
Set-AMAgentGroup
Set-AMCondition
Set-AMDatabaseCondition
Set-AMEmailCondition
Set-AMEventLogCondition
Set-AMFileSystemCondition
Set-AMFolder
Set-AMIdleCondition
Set-AMKeyboardCondition
Set-AMLogonCondition
Set-AMObject
Set-AMPerformanceCondition
Set-AMProcess
Set-AMProcessCondition
Set-AMScheduleCondition
Set-AMServiceCondition
Set-AMSharePointCondition
Set-AMSnmpCondition
Set-AMTask
Set-AMUser
Set-AMUserGroup
Set-AMWindowCondition
Set-AMWmiCondition
Set-AMWorkflow
Set-AMWorkflowVariable
```
----------

### Manage workflows
AutomatePS supports modifying workflow design with the following functions:
```PowerShell
Add-AMWorkflowItem
Add-AMWorkflowLink
Add-AMWorkflowVariable
Remove-AMWorkflowLink
Remove-AMWorkflowVariable
Set-AMWorkflowItem
Set-AMWorkflowVariable
```
----------

### Add User/Agent Group Members
AutomatePS supports adding and removing group members with the following functions:
```PowerShell
Add-AMAgentGroupMember
Add-AMUserGroupMember
Remove-AMAgentGroupMember
Remove-AMUserGroupMember
```
----------

### Working with Multiple Servers
AutomatePS supports working with multiple Automate servers.
For example:
```PowerShell

Connect-AMServer server1 -Credential (Get-Credential)

Get-AMAgent

Name            Enabled Online
----            ------- ------
Agent1             True   True
Agent2             True   True


Connect-AMServer server2 -Credential (Get-Credential)

Get-AMAgent

Name            Enabled Online ConnectionAlias
----            ------- ------ ---------------
Agent1             True   True server1:9708
Agent2             True   True server1:9708
Agent3             True   True server2:9708
Agent4             True   True server2:9708
```
Objects retrieved from Automate know which server they belong to - each has a property called **ConnectionAlias** that indicate which connection they were retrieved from.  Therefore, any actions taken against those objects are routed to the correct server.

When connecting to a server, the -ConnectionAlias parameter can be used to provide a shorthand alias for the connection.  For example:

```PowerShell
Connect-AMServer server1 -ConnectionAlias prod
Connect-AMServer server2 -ConnectionAlias dev
Get-AMAgent -Connection dev

Name            Enabled Online ConnectionAlias
----            ------- ------ ---------------
Agent1             True   True dev
Agent2             True   True dev
```

If the -SaveConnection parameter is used, the ConnectionAlias specified is saved.