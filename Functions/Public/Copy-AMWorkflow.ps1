function Copy-AMWorkflow {
    <#
        .SYNOPSIS
            Copies an AutoMate Enterprise workflow.

        .DESCRIPTION
            Copy-AMWorkflow can copy a workflow within a server.

        .PARAMETER InputObject
            The object to copy.

        .PARAMETER Name
            The new name to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER ConflictAction
            The action to take if a conflicting object is found on the destination server.

        .PARAMETER Connection
            The server to copy the object to.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Workflow

        .EXAMPLE
            # Copy workflow "FTP Files to Company A" to "FTP Files to Company B"
            Get-AMWorkflow "FTP Files to Company A" | Copy-AMWorkflow -Name "FTP Files to Company B" -Folder (Get-AMFolder WORKFLOWS)

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 10/31/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateSet("CopySourceServerObject","UseDestinationServerObject")]
        [string]$ConflictAction,

        $Connection
    )

    BEGIN {
        if ($PSBoundParameters.ContainsKey("Connection")) {
            $Connection = Get-AMConnection -Connection $Connection
            $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
            $taskFolder = $user | Get-AMFolder -Type TASKS
            $conditionFolder = $user | Get-AMFolder -Type CONDITIONS
            $processFolder = $user | Get-AMFolder -Type PROCESSES
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Workflow") {
                if ($PSBoundParameters.ContainsKey("Connection")) {
                    # Copy from one AutoMate server to another
                    if ($obj.ConnectionAlias -ne $Connection.Alias) {
                        if ((Get-AMConnection -Connection $obj.ConnectionAlias).Version.Major -ne $Connection.Version.Major) {
                            throw "Source server and destination server are different versions! This module does not support changing task versions."
                        }
                        if ($PSBoundParameters.ContainsKey("Folder")) {
                            if ($Folder.ConnectionAlias -ne $Connection.Alias) {
                                throw "Folder specified exists on $($Folder.ConnectionAlias), the folder must exist on $($Connection.Name)!"
                            }
                        } else {
                            $Folder = Get-AMFolder -ID $user.WorkflowFolderID -Connection $Connection
                        }
                    }
                } else {
                    $Connection = Get-AMConnection -Connection $obj.ConnectionAlias
                    if (-not $PSBoundParameters.ContainsKey("Folder")) {
                        $Folder = Get-AMFolder -ID $obj.ParentID -Connection $obj.ConnectionAlias
                    }
                    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
                }
                
                if (-not $PSBoundParameters.ContainsKey("Name")) { $Name = $obj.Name }
                switch ($Connection.Version.Major) {
                    10      { $copyObject = [AMWorkflowv10]::new($Name, $Folder, $Connection.Alias) }
                    11      { $copyObject = [AMWorkflowv11]::new($Name, $Folder, $Connection.Alias) }
                    default { throw "Unsupported server major version: $_!" }
                }

                $copyObject.CreatedBy = $user.ID
                $currentObject = Get-AMworkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                $copyObject.CompletionState = $currentObject.CompletionState
                $copyObject.Enabled         = $currentObject.Enabled
                $copyObject.LockedBy        = $currentObject.LockedBy
                $copyObject.Notes           = $currentObject.Notes

                $idLookup = @{}
                foreach ($item in $currentObject.Items) {
                    switch ($item.ConstructType) {
                        "Evaluation" {
                            switch ($Connection.Version.Major) {
                                10      { $newItem = [AMWorkflowConditionv10]::new($Connection.Alias) }
                                11      { $newItem = [AMWorkflowConditionv11]::new($Connection.Alias) }
                                default { throw "Unsupported server major version: $_!" }
                            }
                            $newItem.Expression = $item.Expression
                        }
                        "Wait" {
                            switch ($Connection.Version.Major) {
                                10      { $newItem = [AMWorkflowItemv10]::new($Connection.Alias) }
                                11      { $newItem = [AMWorkflowItemv11]::new($Connection.Alias) }
                                default { throw "Unsupported server major version: $_!" }
                            }
                            $newItem.ConstructType = $item.ConstructType
                        }
                        default {
                            switch ($Connection.Version.Major) {
                                10      { $newItem = [AMWorkflowItemv10]::new($Connection.Alias) }
                                11      { $newItem = [AMWorkflowItemv11]::new($Connection.Alias) }
                                default { throw "Unsupported server major version: $_!" }
                            }
                            # Workflows don't use an agent, so there's no reason to set it
                            if ($item.Type -ne "Workflow") {
                                $newItem.AgentID = $item.AgentID
                            }
                            if ($obj.ConnectionAlias -ne $Connection.Alias) {
                                if (-not $idLookup.ContainsKey($item.ConstructID)) {
                                    $idFilterSet = @{Property = "ID"; Operator = "="; Value = $item.ConstructID}
                                    switch ($item.ConstructType) {
                                        "Workflow" {
                                            $sourceItem = Get-AMWorkflow -FilterSet $idFilterSet -Connection $obj.ConnectionAlias
                                            if ($null -ne $sourceItem) {
                                                $destinationItem = Get-AMWorkflow -FilterSet $idFilterSet,@{Property = "Name"; Operator = "="; Value = $sourceItem.Name} -Connection $Connection
                                                if ($null -ne $destinationItem) {
                                                    if (-not $PSBoundParameters.ContainsKey("ConflictAction")) {
                                                        $options = [System.Management.Automation.Host.ChoiceDescription[]] @("Copy &Source Server Object", "Use &Destination Server Object")
                                                        $defaultChoice = 0
                                                        $answer = $host.UI.PromptForChoice("Import Conflict", "There already is a workflow with the same ID and Name '$($destinationItem.Name)' in the repository.", $Options, $defaultChoice)
                                                        switch($answer) {
                                                            0 { $ConflictAction = "CopySourceServerObject" }
                                                            1 { $ConflictAction = "UseDestinationServerObject" }
                                                        }
                                                    }
                                                    switch ($ConflictAction) {
                                                        "CopySourceServerObject" {
                                                            $newWorkflow = $sourceItem | Copy-AMWorkflow -Folder $Folder -Connection $Connection
                                                            $idLookup.Add($item.ConstructID, $newWorkflow.ID)
                                                        }
                                                        "UseDestinationServerObject" {
                                                            $idLookup.Add($item.ConstructID, $destinationItem.ID)
                                                        }
                                                    }
                                                } else {
                                                    $newWorkflow = $sourceItem | Copy-AMWorkflow -Folder $Folder -Connection $Connection
                                                    $idLookup.Add($item.ConstructID, $newWorkflow.ID)
                                                }
                                            } else {
                                                # Enter a bogus GUID, will result in an unbuilt item
                                                $idLookup.Add($item.ConstructID, (New-Guid).Guid)
                                            }
                                        }
                                        "Task" {
                                            $sourceItem = Get-AMTask -FilterSet $idFilterSet -Connection $obj.ConnectionAlias
                                            if ($null -ne $sourceItem) {
                                                $destinationItem = Get-AMTask -FilterSet $idFilterSet,@{Property = "Name"; Operator = "="; Value = $sourceItem.Name} -Connection $Connection
                                                if ($null -ne $destinationItem) {
                                                    if (-not $PSBoundParameters.ContainsKey("ConflictAction")) {
                                                        $options = [System.Management.Automation.Host.ChoiceDescription[]] @("Copy &Source Server Object", "Use &Destination Server Object")
                                                        $defaultChoice = 0
                                                        $answer = $host.UI.PromptForChoice("Import Conflict", "There already is a task with the same ID and Name '$($destinationItem.Name)' in the repository.", $Options, $defaultChoice)
                                                        switch($answer) {
                                                            0 { $ConflictAction = "CopySourceServerObject" }
                                                            1 { $ConflictAction = "UseDestinationServerObject" }
                                                        }
                                                    }
                                                    switch ($ConflictAction) {
                                                        "CopySourceServerObject" {
                                                            $newTask = $sourceItem | Copy-AMTask -Folder $taskFolder -Connection $Connection
                                                            $idLookup.Add($item.ConstructID, $newTask.ID)
                                                        }
                                                        "UseDestinationServerObject" {
                                                            $idLookup.Add($item.ConstructID, $destinationItem.ID)
                                                        }
                                                    }
                                                } else {
                                                    $newTask = $sourceItem | Copy-AMTask -Folder $taskFolder -Connection $Connection
                                                    $idLookup.Add($item.ConstructID, $newTask.ID)
                                                }
                                            } else {
                                                # Enter a bogus GUID, will result in an unbuilt item
                                                $idLookup.Add($item.ConstructID, (New-Guid).Guid)
                                            }
                                        }
                                        "Process" {
                                            $sourceItem = Get-AMProcess -FilterSet $idFilterSet -Connection $obj.ConnectionAlias
                                            if ($null -ne $sourceItem) {
                                                $destinationItem = Get-AMProcess -FilterSet $idFilterSet,@{Property = "Name"; Operator = "="; Value = $sourceItem.Name} -Connection $Connection
                                                if ($null -ne $destinationItem) {
                                                    if (-not $PSBoundParameters.ContainsKey("ConflictAction")) {
                                                        $options = [System.Management.Automation.Host.ChoiceDescription[]] @("Copy &Source Server Object", "Use &Destination Server Object")
                                                        $defaultChoice = 0
                                                        $answer = $host.UI.PromptForChoice("Import Conflict", "There already is a process with the same ID and Name '$($destinationItem.Name)' in the repository.", $Options, $defaultChoice)
                                                        switch($answer) {
                                                            0 { $ConflictAction = "CopySourceServerObject" }
                                                            1 { $ConflictAction = "UseDestinationServerObject" }
                                                        }
                                                    }
                                                    switch ($ConflictAction) {
                                                        "CopySourceServerObject" {
                                                            $newProcess = $sourceItem | Copy-AMProcess -Folder $processFolder -Connection $Connection
                                                            $idLookup.Add($item.ConstructID, $newProcess.ID)
                                                        }
                                                        "UseDestinationServerObject" {
                                                            $idLookup.Add($item.ConstructID, $destinationItem.ID)
                                                        }
                                                    }
                                                } else {
                                                    $newProcess = $sourceItem | Copy-AMProcess -Folder $processFolder -Connection $Connection
                                                    $idLookup.Add($item.ConstructID, $newProcess.ID)
                                                }
                                            } else {
                                                # Enter a bogus GUID, will result in an unbuilt item
                                                $idLookup.Add($item.ConstructID, (New-Guid).Guid)
                                            }
                                        }
                                    }
                                }
                                $newItem.ConstructID = $idLookup[$item.ConstructID]
                            } else {
                                $newItem.ConstructID = $item.ConstructID
                            }
                            $newItem.ConstructType = $item.ConstructType
                        }
                    }
                    $newItem.Enabled    = $item.Enabled
                    $newItem.Height     = $item.Height
                    $newItem.Label      = $item.Label
                    $newItem.UseLabel   = $item.UseLabel
                    $newItem.Width      = $item.Width
                    $newItem.WorkflowID = $copyObject.ID
                    $newItem.X          = $item.X
                    $newItem.Y          = $item.Y
                    $copyObject.Items += $newItem
                    $idLookup.Add($item.ID, $newItem.ID)
                }
                foreach ($trigger in $currentObject.Triggers) {
                    switch ($Connection.Version.Major) {
                        10      { $newTrigger = [AMWorkflowTriggerv10]::new($Connection.Alias) }
                        11      { $newTrigger = [AMWorkflowTriggerv11]::new($Connection.Alias) }
                        default { throw "Unsupported server major version: $_!" }
                    }
                    # Schedules don't use an agent, so there's no reason to set it
                    if ($trigger.TriggerType -ne "Schedule") {
                        $newTrigger.AgentID = $trigger.AgentID
                    }
                    if ($obj.ConnectionAlias -ne $Connection.Alias) {
                        if (-not $idLookup.ContainsKey($trigger.ConstructID)) {
                            $idFilterSet = @{Property = "ID"; Operator = "="; Value = $trigger.ConstructID}
                            $sourceItem = Get-AMCondition -FilterSet $idFilterSet -Connection $obj.ConnectionAlias
                            if ($null -ne $sourceItem) {
                                $destinationItem = Get-AMCondition -FilterSet $idFilterSet,@{Property = "Name"; Operator = "="; Value = $sourceItem.Name} -Connection $Connection
                                if ($null -ne $destinationItem) {
                                    if (-not $PSBoundParameters.ContainsKey("ConflictAction")) {
                                        $options = [System.Management.Automation.Host.ChoiceDescription[]] @("Copy &Source Server Object", "Use &Destination Server Object")
                                        $defaultChoice = 0
                                        $answer = $host.UI.PromptForChoice("Import Conflict", "There already is a condition with the same ID and Name '$($destinationItem.Name)' in the repository.", $Options, $defaultChoice)
                                        switch($answer) {
                                            0 { $ConflictAction = "CopySourceServerObject" }
                                            1 { $ConflictAction = "UseDestinationServerObject" }
                                        }
                                    }
                                    switch ($ConflictAction) {
                                        "CopySourceServerObject" {
                                            $newCondition = $sourceItem | Copy-AMCondition -Folder $conditionFolder -Connection $Connection
                                            $idLookup.Add($trigger.ConstructID, $newCondition.ID)
                                        }
                                        "UseDestinationServerObject" {
                                            $idLookup.Add($trigger.ConstructID, $destinationItem.ID)
                                        }
                                    }
                                } else {
                                    $newCondition = $sourceItem | Copy-AMCondition -Folder $conditionFolder -Connection $Connection
                                    $idLookup.Add($trigger.ConstructID, $newCondition.ID)
                                }
                            } else {
                                # Enter a bogus GUID, will result in an unbuilt item
                                $idLookup.Add($trigger.ConstructID, (New-Guid).Guid)
                            }
                        }
                        $newTrigger.ConstructID = $idLookup[$trigger.ConstructID]
                    } else {
                        $newTrigger.ConstructID = $trigger.ConstructID
                    }
                    $newTrigger.TriggerType   = $trigger.TriggerType
                    $newTrigger.ConstructType = $trigger.ConstructType
                    $newTrigger.Enabled       = $trigger.Enabled
                    $newTrigger.Height        = $trigger.Height
                    $newTrigger.Label         = $trigger.Label
                    $newTrigger.UseLabel      = $trigger.UseLabel
                    $newTrigger.Width         = $trigger.Width
                    $newTrigger.WorkflowID    = $copyObject.ID
                    $newTrigger.X             = $trigger.X
                    $newTrigger.Y             = $trigger.Y
                    $copyObject.Triggers += $newTrigger
                    $idLookup.Add($trigger.ID, $newTrigger.ID)
                }
                foreach ($link in $currentObject.Links) {
                    switch ($Connection.Version.Major) {
                        10      { $newLink = [AMWorkflowLinkv10]::new($Connection.Alias) }
                        11      { $newLink = [AMWorkflowLinkv11]::new($Connection.Alias) }
                        default { throw "Unsupported server major version: $_!" }
                    }
                    $newLink.ParentID         = $copyObject.ID
                    $newLink.DestinationID    = $idLookup[$link.DestinationID]
                    $newLink.DestinationPoint = [PSCustomObject]@{x = $link.DestinationPoint.X; y = $link.DestinationPoint.Y}
                    $newLink.LinkType         = $link.LinkType
                    $newLink.ResultType       = $link.ResultType
                    $newLink.SourceID         = $idLookup[$link.SourceID]
                    $newLink.SourcePoint      = [PSCustomObject]@{x = $link.SourcePoint.X; y = $link.SourcePoint.Y}
                    $newLink.Value            = $link.Value
                    $newLink.WorkflowID       = $copyObject.ID
                    $copyObject.Links += $newLink
                }
                foreach ($variable in $currentObject.Variables) {
                    switch ($Connection.Version.Major) {
                        10      { $newVariable = [AMWorkflowVariablev10]::new($Connection.Alias) }
                        11      { $newVariable = [AMWorkflowVariablev11]::new($Connection.Alias) }
                        default { throw "Unsupported server major version: $_!" }
                    }
                    $newVariable.Name         = $variable.Name
                    $newVariable.ParentID     = $copyObject.ID
                    $newVariable.DataType     = $variable.DataType
                    $newVariable.Description  = $variable.Description
                    $newVariable.InitalValue  = $variable.InitalValue
                    $newVariable.Parameter    = $variable.Parameter
                    $newVariable.Private      = $variable.Private
                    $newVariable.VariableType = $variable.VariableType
                    $copyObject.Variables += $newVariable
                }
                $copyObject | New-AMObject -Connection $Connection
                Get-AMWorkflow -ID $copyObject.ID -Connection $Connection
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
