function Move-AMObject {
    <#
        .SYNOPSIS
            Moves an AutoMate Enterprise object.

        .DESCRIPTION
            Move-AMObject receives AutoMate Enterprise object(s) on the pipeline, or via the parameter $InputObject, and moves the object(s) to the specified folder.

        .PARAMETER InputObject
            The object(s) to be moved.

        .PARAMETER Folder
            The folder to move the object to.

        .INPUTS
            The following objects can be moved by this function:
            Folder
            Workflow
            Task
            Process
            TaskAgent
            ProcessAgent
            AgentGroup
            User
            UserGroup

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMWorkflow "My Workflow" | Move-AMObject -Folder (Get-AMFolder -Path \WORKFLOWS)

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.ParentID -ne $Folder.ID) {
                switch ($obj.Type) {
                    {$_ -in "Folder","Workflow","Task","Condition","Process","Agent","AgentGroup","User","UserGroup"} {
                        $update = Get-AMObject -ID $obj.ID -Types $obj.Type -Connection $obj.ConnectionAlias
                    }
                    default {
                        Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                    }
                }
                $update.Path     = Join-Path -Path $Folder.Path -ChildPath $Folder.Name
                $update.ParentID = $Folder.ID
                $update | Set-AMObject
                Write-Verbose "Moved $($obj.Type) '$($obj.Name)' to folder $(Join-Path -Path $Folder.Path -ChildPath $Folder.Name)."
            } else {
                Write-Verbose "$($obj.Type) '$($obj.Name)' is already in folder $(Join-Path -Path $Folder.Path -ChildPath $Folder.Name)."
            }
        }
    }
}

New-Alias -Name Move-AMAgent      -Value Move-AMObject -Scope Global -Force
New-Alias -Name Move-AMAgentGroup -Value Move-AMObject -Scope Global -Force
New-Alias -Name Move-AMCondition  -Value Move-AMObject -Scope Global -Force
New-Alias -Name Move-AMFolder     -Value Move-AMObject -Scope Global -Force
New-Alias -Name Move-AMProcess    -Value Move-AMObject -Scope Global -Force
New-Alias -Name Move-AMTask       -Value Move-AMObject -Scope Global -Force
New-Alias -Name Move-AMUser       -Value Move-AMObject -Scope Global -Force
New-Alias -Name Move-AMUserGroup  -Value Move-AMObject -Scope Global -Force
New-Alias -Name Move-AMWorkflow   -Value Move-AMObject -Scope Global -Force