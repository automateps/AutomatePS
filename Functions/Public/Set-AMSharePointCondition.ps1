function Set-AMSharePointCondition {
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise SharePoint condition.

        .DESCRIPTION
            Set-AMIdleCondition modifies an existing SharePoint condition.

        .PARAMETER InputObject
            The condition to modify.

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
        [string]$SiteURL,

        [ValidateNotNullOrEmpty()]
        [AMSharePointScope]$Scope,
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
        [int]$TriggerAfter,

        [AllowEmptyString()]
        [string]$Notes,

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Condition" -and $obj.TriggerType -eq [AMTriggerType]::SharePoint) {
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
