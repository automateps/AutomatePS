function New-AMSharePointCondition {
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise SharePoint condition.

        .DESCRIPTION
            New-AMSharePointCondition creates a new SharePoint condition.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER SiteURL
            The SharePoint site URL in which to monitor.

        .PARAMETER Scope
            The SharePoint range to monitor: Web or List.

        .PARAMETER List
            The title of the list to monitor. This parameter is available only if the Scope parameter is set to List.

        .PARAMETER ItemAdded
            If set to YES, the condition will monitor for items to be added to the site/list.

        .PARAMETER ItemUpdated
            If set to YES, the condition will monitor for items to be updated in the site/list.

        .PARAMETER ItemDeleted
            If set to YES, the condition will monitor for items to be deleted from the site/list.

        .PARAMETER ItemCheckedIn
            If set to YES, the condition will monitor for items to be checked in the site/list.

        .PARAMETER ItemCheckedOut
            If set to YES, the condition will monitor for items to be checked out of the site/list. If you check out an item, you will reserve it for your use so that others cannot change it while you are working on it.

        .PARAMETER ItemUncheckedOut
            If set to YES, the condition will monitor for items to be unchecked out (also known as discarded checkout) from the site/list. You can uncheck out an item if you want it to go back to the way it was before you checked it out. This will undo all of the changes that you made to the item

        .PARAMETER ItemFileMoved
            If set to YES, the condition will monitor for a file that is represented by an item from a document library to be moved from the site/list.

        .PARAMETER ItemAttachmentAdded
            If set to YES, the condition will monitor for an attachment to be added to a list item in the specified site/list.

        .PARAMETER ItemAttachmentDeleted
            If set to YES, the condition will monitor for an attachment to be deleted from a list item in the specified site/list.

        .PARAMETER FieldAdded
            If set to YES, the condition will monitor for a field to be added to the site/list.

        .PARAMETER FieldUpdated
            If set to YES, the condition will monitor for a field to be updated in the site/list.

        .PARAMETER FieldDeleted
            If set to YES, the condition will monitor for a field to be deleted from the site/list.

        .PARAMETER WorkflowStarted
            If set to YES, the condition will monitor for a SharePoint workflow to be started from the site/list.

        .PARAMETER WorkflowPostponed
            If set to YES, the condition will monitor for a SharePoint workflow to be postponed from the site/list.

        .PARAMETER WorkflowCompleted
            If set to YES, the condition will monitor for a SharePoint workflow to be completed from the site/list.

        .PARAMETER ListAdded
            If set to YES, the condition will monitor for a list to be added to the site/list.

        .PARAMETER ListDeleted
            If set to YES, the condition will monitor for a list to be deleted from the site/list.

        .PARAMETER GroupAdded
            If set to YES, the condition will monitor for a group to be added to the specified site/list.

        .PARAMETER GroupUpdated
            If set to YES, the condition will monitor for a group to be updated in the specified site/list.

        .PARAMETER GroupDeleted
            If set to YES, the condition will monitor for a group to be deleted from the specified site/list.

        .PARAMETER GroupUserAdded
            If set to YES, the condition will monitor for a user to be added to a group in the specified site/list.

        .PARAMETER GroupUserDeleted
            If set to YES, the condition will monitor for a user to be deleted from a group in the specified site/list.

        .PARAMETER RoleDefinitionAdded
            If set to YES, the condition will monitor for a role definition (or permission level) to be added to an item in the specified site/list. A role definition is a collection of rights bound to a specific item.

        .PARAMETER RoleDefinitionUpdated
            If set to YES, the condition will monitor for a role definition (or permission level) to be updated in the specified site/list.

        .PARAMETER RoleDefinitionDeleted
            If set to YES, the condition will monitor for a role definition (or permission level) to be deleted from an item in the specified site/list.

        .PARAMETER RoleAssignmentAdded
            If set to YES, the condition will monitor for a role assignment to be added to an item in the specified site/list.

        .PARAMETER RoleAssignmentDeleted
            If set to YES, the condition will monitor for a role assignment to be deleted from an item in the specified site/list.

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

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteURL,
        [AMSharePointScope]$Scope = [AMSharePointScope]::Web,
        [string]$List,
        [switch]$ItemAdded,
        [switch]$ItemUpdated,
        [switch]$ItemDeleted,
        [switch]$ItemCheckedIn,
        [switch]$ItemCheckedOut,
        [switch]$ItemUncheckedOut,
        [switch]$ItemFileMoved,
        [switch]$ItemAttachmentAdded,
        [switch]$ItemAttachmentDeleted,
        [switch]$FieldAdded,
        [switch]$FieldUpdated,
        [switch]$FieldDeleted,
        [switch]$WorkflowStarted,
        [switch]$WorkflowPostponed,
        [switch]$WorkflowCompleted,
        [switch]$ListAdded,
        [switch]$ListDeleted,
        [switch]$GroupAdded,
        [switch]$GroupUpdated,
        [switch]$GroupDeleted,
        [switch]$GroupUserAdded,
        [switch]$GroupUserDeleted,
        [switch]$RoleDefinitionAdded,
        [switch]$RoleDefinitionUpdated,
        [switch]$RoleDefinitionDeleted,
        [switch]$RoleAssignmentAdded,
        [switch]$RoleAssignmentDeleted,

        [ValidateScript({
            if ($_ -eq [AMConditionUserMode]::NoUser) {
                throw [System.Management.Automation.PSArgumentException]"NoUser is not supported for SharePoint conditions!"
                $false
            } else {
                $true
            }
        })]
        [AMConditionUserMode]$UserMode = [AMConditionUserMode]::DefaultUser,
        [string]$UserName = "",
        #[string]$Password, API BUG: does not support setting password via REST call
        [string]$Domain = "",

        [ValidateNotNullOrEmpty()]
        [switch]$Wait = $true,
        [int]$Timeout = 0,
        [AMTimeMeasure]$TimeoutUnit = [AMTimeMeasure]::Seconds,
        [int]$TriggerAfter = 1,

        [string]$Notes = "",

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    switch (($Connection | Measure-Object).Count) {
        1 {
            $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
            if (-not $Folder) { $Folder = $user | Get-AMFolder -Type CONDITIONS } # Place the condition in the users condition folder
            switch ($Connection.Version.Major) {
                10      { $newObject = [AMSharePointTriggerv10]::new($Name, $Folder, $Connection.Alias) }
                11      { $newObject = [AMSharePointTriggerv11]::new($Name, $Folder, $Connection.Alias) }
                default { throw "Unsupported server major version: $_!" }
            }
            $newObject.CreatedBy       = $user.ID
            $newObject.Notes           = $Notes
            $newObject.Wait            = $Wait.ToBool()
            if ($newObject.UserMode -eq [AMConditionUserMode]::SpecifiedUser) {
                $newObject.UserName = $UserName
                #$newObject.Password = $Password
                $newObject.Domain   = $Domain
            }
            if ($newObject.Wait) {
                $newObject.Timeout      = $Timeout
                $newObject.TimeoutUnit  = $TimeoutUnit
                $newObject.TriggerAfter = $TriggerAfter
            }
            $newObject.SiteURL               = $SiteURL
            $newObject.Scope                 = $Scope
            $newObject.List                  = $List
            $newObject.ItemAdded             = $ItemAdded.ToBool()
            $newObject.ItemUpdated           = $ItemUpdated.ToBool()
            $newObject.ItemDeleted           = $ItemDeleted.ToBool()
            $newObject.ItemCheckedIn         = $ItemCheckedIn.ToBool()
            $newObject.ItemCheckedOut        = $ItemCheckedOut.ToBool()
            $newObject.ItemUncheckedOut      = $ItemUncheckedOut.ToBool()
            $newObject.ItemFileMoved         = $ItemFileMoved.ToBool()
            $newObject.ItemAttachmentAdded   = $ItemAttachmentAdded.ToBool()
            $newObject.ItemAttachmentDeleted = $ItemAttachmentDeleted.ToBool()
            $newObject.FieldAdded            = $FieldAdded.ToBool()
            $newObject.FieldUpdated          = $FieldUpdated.ToBool()
            $newObject.FieldDeleted          = $FieldDeleted.ToBool()
            $newObject.WorkflowStarted       = $WorkflowStarted.ToBool()
            $newObject.WorkflowPostponed     = $WorkflowPostponed.ToBool()
            $newObject.WorkflowCompleted     = $WorkflowCompleted.ToBool()
            $newObject.ListAdded             = $ListAdded.ToBool()
            $newObject.ListDeleted           = $ListDeleted.ToBool()
            $newObject.GroupAdded            = $GroupAdded.ToBool()
            $newObject.GroupUpdated          = $GroupUpdated.ToBool()
            $newObject.GroupDeleted          = $GroupDeleted.ToBool()
            $newObject.GroupUserAdded        = $GroupUserAdded.ToBool()
            $newObject.GroupUserDeleted      = $GroupUserDeleted.ToBool()
            $newObject.RoleDefinitionAdded   = $RoleDefinitionAdded.ToBool()
            $newObject.RoleDefinitionUpdated = $RoleDefinitionUpdated.ToBool()
            $newObject.RoleDefinitionDeleted = $RoleDefinitionDeleted.ToBool()
            $newObject.RoleAssignmentAdded   = $RoleAssignmentAdded.ToBool()
            $newObject.RoleAssignmentDeleted = $RoleAssignmentDeleted.ToBool()
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple AutoMate servers are connected, please specify which server to create the new condition on!" }
    }
}