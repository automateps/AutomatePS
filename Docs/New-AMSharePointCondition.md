---
external help file: AutomatePS-help.xml
Module Name: AutomatePS
online version: https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMSharePointCondition.md
schema: 2.0.0
---

# New-AMSharePointCondition

## SYNOPSIS
Creates a new Automate SharePoint condition.

## SYNTAX

```
New-AMSharePointCondition [-Name] <String> -SiteURL <String> [-Scope <AMSharePointScope>] [-List <String>]
 [-ItemAdded] [-ItemUpdated] [-ItemDeleted] [-ItemCheckedIn] [-ItemCheckedOut] [-ItemUncheckedOut]
 [-ItemFileMoved] [-ItemAttachmentAdded] [-ItemAttachmentDeleted] [-FieldAdded] [-FieldUpdated] [-FieldDeleted]
 [-WorkflowStarted] [-WorkflowPostponed] [-WorkflowCompleted] [-ListAdded] [-ListDeleted] [-GroupAdded]
 [-GroupUpdated] [-GroupDeleted] [-GroupUserAdded] [-GroupUserDeleted] [-RoleDefinitionAdded]
 [-RoleDefinitionUpdated] [-RoleDefinitionDeleted] [-RoleAssignmentAdded] [-RoleAssignmentDeleted]
 [-UserMode <AMConditionUserMode>] [-UserName <String>] [-Domain <String>] [-Wait] [-Timeout <Int32>]
 [-TimeoutUnit <AMTimeMeasure>] [-TriggerAfter <Int32>] [-Notes <String>] [-Folder <Object>]
 [-Connection <Object>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
New-AMSharePointCondition creates a new SharePoint condition.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Name
The name of the new object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SiteURL
The SharePoint site URL in which to monitor.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
The SharePoint range to monitor: Web or List.

```yaml
Type: AMSharePointScope
Parameter Sets: (All)
Aliases:
Accepted values: Web, List

Required: False
Position: Named
Default value: Web
Accept pipeline input: False
Accept wildcard characters: False
```

### -List
The title of the list to monitor.
This parameter is available only if the Scope parameter is set to List.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ItemAdded
If set to YES, the condition will monitor for items to be added to the site/list.

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

### -ItemUpdated
If set to YES, the condition will monitor for items to be updated in the site/list.

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

### -ItemDeleted
If set to YES, the condition will monitor for items to be deleted from the site/list.

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

### -ItemCheckedIn
If set to YES, the condition will monitor for items to be checked in the site/list.

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

### -ItemCheckedOut
If set to YES, the condition will monitor for items to be checked out of the site/list.
If you check out an item, you will reserve it for your use so that others cannot change it while you are working on it.

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

### -ItemUncheckedOut
If set to YES, the condition will monitor for items to be unchecked out (also known as discarded checkout) from the site/list.
You can uncheck out an item if you want it to go back to the way it was before you checked it out.
This will undo all of the changes that you made to the item

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

### -ItemFileMoved
If set to YES, the condition will monitor for a file that is represented by an item from a document library to be moved from the site/list.

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

### -ItemAttachmentAdded
If set to YES, the condition will monitor for an attachment to be added to a list item in the specified site/list.

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

### -ItemAttachmentDeleted
If set to YES, the condition will monitor for an attachment to be deleted from a list item in the specified site/list.

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

### -FieldAdded
If set to YES, the condition will monitor for a field to be added to the site/list.

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

### -FieldUpdated
If set to YES, the condition will monitor for a field to be updated in the site/list.

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

### -FieldDeleted
If set to YES, the condition will monitor for a field to be deleted from the site/list.

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

### -WorkflowStarted
If set to YES, the condition will monitor for a SharePoint workflow to be started from the site/list.

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

### -WorkflowPostponed
If set to YES, the condition will monitor for a SharePoint workflow to be postponed from the site/list.

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

### -WorkflowCompleted
If set to YES, the condition will monitor for a SharePoint workflow to be completed from the site/list.

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

### -ListAdded
If set to YES, the condition will monitor for a list to be added to the site/list.

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

### -ListDeleted
If set to YES, the condition will monitor for a list to be deleted from the site/list.

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

### -GroupAdded
If set to YES, the condition will monitor for a group to be added to the specified site/list.

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

### -GroupUpdated
If set to YES, the condition will monitor for a group to be updated in the specified site/list.

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

### -GroupDeleted
If set to YES, the condition will monitor for a group to be deleted from the specified site/list.

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

### -GroupUserAdded
If set to YES, the condition will monitor for a user to be added to a group in the specified site/list.

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

### -GroupUserDeleted
If set to YES, the condition will monitor for a user to be deleted from a group in the specified site/list.

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

### -RoleDefinitionAdded
If set to YES, the condition will monitor for a role definition (or permission level) to be added to an item in the specified site/list.
A role definition is a collection of rights bound to a specific item.

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

### -RoleDefinitionUpdated
If set to YES, the condition will monitor for a role definition (or permission level) to be updated in the specified site/list.

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

### -RoleDefinitionDeleted
If set to YES, the condition will monitor for a role definition (or permission level) to be deleted from an item in the specified site/list.

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

### -RoleAssignmentAdded
If set to YES, the condition will monitor for a role assignment to be added to an item in the specified site/list.

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

### -RoleAssignmentDeleted
If set to YES, the condition will monitor for a role assignment to be deleted from an item in the specified site/list.

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

### -UserMode
Specify to use the default agent user (DefaultUser) or a specified user (SpecifiedUser).

```yaml
Type: AMConditionUserMode
Parameter Sets: (All)
Aliases:
Accepted values: NoUser, DefaultUser, SpecifiedUser

Required: False
Position: Named
Default value: DefaultUser
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
The username used to authenticate with the database.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
The domain for the specified user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
Wait for the condition, or evaluate immediately.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
If wait is specified, the amount of time before the condition times out.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutUnit
The unit for Timeout (Seconds by default).

```yaml
Type: AMTimeMeasure
Parameter Sets: (All)
Aliases:
Accepted values: Seconds, Minutes, Hours, Days, Milliseconds

Required: False
Position: Named
Default value: Seconds
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerAfter
The number of times the condition should occur before the trigger fires.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
The new notes to set on the object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Folder
The folder to place the object in.

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

### -Connection
The server to create the object on.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMSharePointCondition.md](https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMSharePointCondition.md)

