function Rename-AMObject {
    <#
        .SYNOPSIS
            Renames an AutoMate Enterprise object.

        .DESCRIPTION
            Rename-AMObject receives AutoMate Enterprise object(s) on the pipeline, or via the parameter $InputObject, and renames the object(s).

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

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            $restResource = ([AMTypeDictionary]::($obj.Type)).RestResource
            switch ($obj.Type) {
                "Folder" {
                    $update = Get-AMFolder -ID $obj.ID -Connection $obj.ConnectionAlias
                    if ($update.ID -notin (Get-AMFolderRoot -Connection $obj.ConnectionAlias).ID) {
                        $update.Name = $Name
                    } else {
                        throw "A root folder cannot be renamed!"
                    }
                }
                "Workflow"   {
                    $update = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                    $update.Name = $Name
                }
                "Task"       {
                    $update = Get-AMTask -ID $obj.ID -Connection $obj.ConnectionAlias
                    $update.Name = $Name
                }
                "Condition"  {
                    $update = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
                    $update.Name = $Name
                }
                "Process"    {
                    $update = Get-AMProcess -ID $obj.ID -Connection $obj.ConnectionAlias
                    $update.Name = $Name
                }
                "AgentGroup" {
                    $update = Get-AMAgentGroup -ID $obj.ID -Connection $obj.ConnectionAlias
                    $update.Name = $Name
                }
                "UserGroup"  {
                    $update = Get-AMUserGroup -ID $obj.ID -Connection $obj.ConnectionAlias
                    $update.Name = $Name
                }
                "WorkflowVariable" {
                    $update = Get-AMWorkflow -ID $obj.ParentID -Connection $obj.ConnectionAlias
                    $oldNameVar = $update.Variables | Where-Object {$_.ID -eq $obj.ID}
                    $newNameVar = $update.Variables | Where-Object {$_.Name -eq $NewName}
                    if ($null -eq $newNameVar) {
                        $oldNameVar.Name = $Name
                        $restResource = "workflows"
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
