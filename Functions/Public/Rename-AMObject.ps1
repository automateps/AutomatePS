function Rename-AMObject {
    <#
        .SYNOPSIS
            Renames an Automate object.

        .DESCRIPTION
            Rename-AMObject receives Automate object(s) on the pipeline, or via the parameter $InputObject, and renames the object(s).

        .PARAMETER InputObject
            The object(s) to be locked.

        .PARAMETER Name
            The new name.

        .INPUTS
            The following objects can be renamed by this function:
            Folder
            Workflow
            WorkflowVariable
            Task
            Process
            AgentGroup
            UserGroup

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMWorkflow "My Workflow" | Rename-AMObject "My Renamed Workflow"

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Rename-AMObject.md
    #>
    [CmdletBinding()]
    [Alias("Rename-AMAgentGroup")]
    [Alias("Rename-AMCondition")]
    [Alias("Rename-AMFolder")]
    [Alias("Rename-AMProcess")]
    [Alias("Rename-AMTask")]
    [Alias("Rename-AMUserGroup")]
    [Alias("Rename-AMWorkflow")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                {$_ -in "Workflow","Task","Condition","Process","AgentGroup","UserGroup"} {
                    $update = Get-AMObject -ID $obj.ID -Types $obj.Type -Connection $obj.ConnectionAlias
                    $update.Name = $Name
                }
                "Folder" {
                    $update = Get-AMFolder -ID $obj.ID -Connection $obj.ConnectionAlias
                    if ($update.ID -notin (Get-AMFolderRoot -Connection $obj.ConnectionAlias).ID) {
                        $update.Name = $Name
                    } else {
                        throw "A root folder cannot be renamed!"
                    }
                }
                "WorkflowVariable" {
                    $update = Get-AMWorkflow -ID $obj.ParentID -Connection $obj.ConnectionAlias
                    $oldNameVar = $update.Variables | Where-Object {$_.ID -eq $obj.ID}
                    $newNameVar = $update.Variables | Where-Object {$_.Name -eq $NewName}
                    if ($null -eq $newNameVar) {
                        $oldNameVar.Name = $Name
                    } else {
                        throw "Workflow $($update.Name) already contains a variable with the name '$NewName'!"
                    }
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
            $update | Set-AMObject
            Write-Verbose "Renamed $($update.Type) '$($update.Name)' to '$($Name)'."
        }
    }
}