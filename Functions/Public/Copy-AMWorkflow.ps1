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

        .PARAMETER IdSubstitutions
            A hashtable containing ID mappings between the source and destination server.  The ID from the source server object is the key, the destination server is the value.
            Use this to define mappings of agents/agent groups/folders, or repository objects where the default mapping actions taken by this workflow are not sufficient.

        .PARAMETER IgnoreServerVersionDifference
            Ignore server version differences when copying between servers.  If a task needs to be copied from the source server to the destination server, Copy-AMTask will still fail.
            This could result in an incomplete migration.  To avoid this, first use the export/import options in the Server Management Console for any tasks in the workflow(s) to be copied.

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
            Date Modified  : 04/22/2019

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateSet("CopySourceServerObject","UseDestinationServerObject")]
        [string]$ConflictAction,

        [ValidateNotNullOrEmpty()]
        [Hashtable]$IdSubstitutions = [Hashtable]::new(),

        [switch]$IgnoreServerVersionDifference,

        [ValidateNotNullOrEmpty()]
        $Connection
    )

    BEGIN {
        if ($PSBoundParameters.ContainsKey("Connection")) {
            $Connection = Get-AMConnection -Connection $Connection
            if (($Connection | Measure-Object).Count -eq 0) {
                throw "No AutoMate server specified!"
            } elseif (($Connection | Measure-Object).Count -gt 1) {
                throw "Multiple AutoMate servers specified, please specify one server to copy the workflow to!"
            }
            $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
            $taskFolder = $user | Get-AMFolder -Type TASKS
            $conditionFolder = $user | Get-AMFolder -Type CONDITIONS
            $processFolder = $user | Get-AMFolder -Type PROCESSES

            Write-Verbose "Caching workflow IDs for server $($Connection.Alias) for ID checking"
            $workflowCache = Get-AMWorkflow -Connection $Connection
            $existingIds = @()
            $existingIds += $workflowCache.ID
            $existingIds += $workflowCache.Items.ID
            $existingIds += $workflowCache.Triggers.ID
            $existingIds += $workflowCache.Links.ID
            $existingIds += $workflowCache.Variables.ID
        }

        $substitions = $IdSubstitutions.PSObject.Copy()
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Workflow") {
                if ($PSBoundParameters.ContainsKey("Connection")) {
                    # Copy from one AutoMate server to another
                    if ($obj.ConnectionAlias -ne $Connection.Alias) {
                        if ((Get-AMConnection -ConnectionAlias $obj.ConnectionAlias).Version.Major -ne $Connection.Version.Major) {
                            if ($IgnoreServerVersionDifference.IsPresent) {
                                Write-Warning "Server versions do not match, but this is being ignored.  This could result in an incomplete migration if tasks fail to migrate!"
                            } else {
                                throw "Source server and destination server are different versions! This module does not support changing task versions."
                            }
                        }
                        if ($PSBoundParameters.ContainsKey("Folder")) {
                            # If folder was specified, validate that it is on the destination server
                            if ($Folder.ConnectionAlias -ne $Connection.Alias) {
                                throw "Folder specified exists on $($Folder.ConnectionAlias), the folder must exist on $($Connection.Name)!"
                            }
                        } else {
                            # If a folder substition was given, use it, otherwise default to the user folder
                            if ($substitions.ContainsKey($obj.ParentID)) {
                                $Folder = Get-AMFolder -ID $substitions[$obj.ParentID] -Connection $Connection
                            } else {
                                $Folder = Get-AMFolder -ID $user.WorkflowFolderID -Connection $Connection
                            }
                        }
                    }
                } else {
                    # Copy within the same server
                    $Connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
                    if (-not $PSBoundParameters.ContainsKey("Folder")) {
                        # If folder was not specified, place workflow in same folder as source workflow
                        $Folder = Get-AMFolder -ID $obj.ParentID -Connection $obj.ConnectionAlias
                    }
                    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
                }

                # If a name was not specified, default to using the original objects name (API will automatically append number if there is a naming conflict)
                if (-not $PSBoundParameters.ContainsKey("Name")) { $Name = $obj.Name }
                # Create the new workflow object
                switch ($Connection.Version.Major) {
                    10      { $copyObject = [AMWorkflowv10]::new($Name, $Folder, $Connection.Alias) }
                    11      { $copyObject = [AMWorkflowv11]::new($Name, $Folder, $Connection.Alias) }
                    default { throw "Unsupported server major version: $_!" }
                }
                # If an object with the same ID doesn't already exist, use the same ID (when copying between servers)
                if ($obj.ID -notin $existingIds) {
                    $copyObject.ID = $obj.ID
                }

                # Copy properties of the source workflow to the new workflow
                try {
                    $currentObject = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                } catch {
                    Write-Verbose "Could not find workflow with ID $($obj.ID), assuming this is a workflow that was deleted from the server."
                    $currentObject = $obj.PSObject.Copy()
                }
                $copyObject.CreatedBy       = $user.ID
                $copyObject.CompletionState = $currentObject.CompletionState
                $copyObject.Enabled         = $currentObject.Enabled
                $copyObject.LockedBy        = $currentObject.LockedBy
                $copyObject.Notes           = $currentObject.Notes

                # Copy items into new workflow
                foreach ($item in $currentObject.Items) {
                    switch ($item.ConstructType) {
                        "Evaluation" {
                            # Create a new evaluation object
                            switch ($Connection.Version.Major) {
                                10      { $newItem = [AMWorkflowConditionv10]::new($Connection.Alias) }
                                11      { $newItem = [AMWorkflowConditionv11]::new($Connection.Alias) }
                                default { throw "Unsupported server major version: $_!" }
                            }
                            # Copy properties of the source evaluation object to the new evaluation
                            $newItem.Expression = $item.Expression
                        }
                        "Wait" {
                            # Create a new wait object
                            switch ($Connection.Version.Major) {
                                10      { $newItem = [AMWorkflowItemv10]::new($Connection.Alias) }
                                11      { $newItem = [AMWorkflowItemv11]::new($Connection.Alias) }
                                default { throw "Unsupported server major version: $_!" }
                            }
                            # Copy properties of the source wait object to the new evaluation
                            $newItem.ConstructType = $item.ConstructType
                        }
                        default {
                            # Create the new workflow item (for workflows/tasks/processes)
                            switch ($Connection.Version.Major) {
                                10      { $newItem = [AMWorkflowItemv10]::new($Connection.Alias) }
                                11      { $newItem = [AMWorkflowItemv11]::new($Connection.Alias) }
                                default { throw "Unsupported server major version: $_!" }
                            }
                            # Workflows don't use an agent, so there's no reason to set it
                            if ($item.ConstructType -ne "Workflow") {
                                $newItem.AgentID = $item.AgentID
                            }
                            # If copying to another server
                            if ($obj.ConnectionAlias -ne $Connection.Alias) {
                                # Look for any specified substitions for the agent, use if provided
                                if ($substitions.ContainsKey($item.AgentID)) {
                                    $newItem.AgentID = $substitions[$item.AgentID]
                                }
                                # If there is no substition specified for the item
                                if (-not $substitions.ContainsKey($item.ConstructID)) {
                                    $idFilterSet = @{Property = "ID"; Operator = "="; Value = $item.ConstructID}
                                    switch ($item.ConstructType) {
                                        "Workflow" {
                                            $sourceItem = Get-AMWorkflow -FilterSet $idFilterSet -Connection $obj.ConnectionAlias
                                            # If the source item exists
                                            if ($null -ne $sourceItem) {
                                                $destinationItem = Get-AMWorkflow -FilterSet $idFilterSet,@{Property = "Name"; Operator = "="; Value = $sourceItem.Name} -Connection $Connection
                                                # If the destination item exists
                                                if ($null -ne $destinationItem) {
                                                    # Prompt user for conflict action
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
                                                            # Copy object from source server to destination server
                                                            $splat = @{
                                                                IdSubstitutions = $substitions
                                                                Connection = $Connection
                                                            }
                                                            if ($PSBoundParameters.ContainsKey("Folder")) {
                                                                $splat.Add("Folder", $Folder)
                                                            }
                                                            $newWorkflow = $sourceItem | Copy-AMWorkflow @splat
                                                            $substitions.Add($item.ConstructID, $newWorkflow.ID)
                                                        }
                                                        "UseDestinationServerObject" {
                                                            # Use existing object in the destination server
                                                            $substitions.Add($item.ConstructID, $destinationItem.ID)
                                                        }
                                                    }
                                                } else {
                                                    # If the destination item does not already exist, create it
                                                    $splat = @{
                                                        IdSubstitutions = $substitions
                                                        Connection = $Connection
                                                    }
                                                    # Only specify the folder if it was specified by the user, allows IdSubstitions to be used in recursive calls
                                                    if ($PSBoundParameters.ContainsKey("Folder")) {
                                                        $splat.Add("Folder", $Folder)
                                                    }
                                                    $newWorkflow = $sourceItem | Copy-AMWorkflow @splat
                                                    $substitions.Add($item.ConstructID, $newWorkflow.ID)
                                                }
                                            } else {
                                                # Enter a bogus GUID, will result in an unbuilt item
                                                $substitions.Add($item.ConstructID, (New-Guid).Guid)
                                            }
                                        }
                                        "Task" {
                                            $sourceItem = Get-AMTask -FilterSet $idFilterSet -Connection $obj.ConnectionAlias
                                            # If the source item exists
                                            if ($null -ne $sourceItem) {
                                                # Check if a folder substition was provided, default to user folder if not
                                                if ($substitions.ContainsKey($sourceItem.ParentID)) {
                                                    $tempTaskFolder = Get-AMFolder -ID $substitions[$sourceItem.ParentID] -Connection $Connection
                                                } else {
                                                    $tempTaskFolder = $taskFolder
                                                }
                                                $destinationItem = Get-AMTask -FilterSet $idFilterSet,@{Property = "Name"; Operator = "="; Value = $sourceItem.Name} -Connection $Connection
                                                # If the destination item exists
                                                if ($null -ne $destinationItem) {
                                                    # Prompt user for conflict action
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
                                                            # Copy object from source server to destination server
                                                            $newTask = $sourceItem | Copy-AMTask -Folder $tempTaskFolder -Connection $Connection
                                                            $substitions.Add($item.ConstructID, $newTask.ID)
                                                        }
                                                        "UseDestinationServerObject" {
                                                            # Use existing object in the destination server
                                                            $substitions.Add($item.ConstructID, $destinationItem.ID)
                                                        }
                                                    }
                                                } else {
                                                    # If the destination item does not already exist, create it
                                                    $newTask = $sourceItem | Copy-AMTask -Folder $tempTaskFolder -Connection $Connection
                                                    $substitions.Add($item.ConstructID, $newTask.ID)
                                                }
                                            } else {
                                                # Enter a bogus GUID, will result in an unbuilt item
                                                $substitions.Add($item.ConstructID, (New-Guid).Guid)
                                            }
                                        }
                                        "Process" {
                                            $sourceItem = Get-AMProcess -FilterSet $idFilterSet -Connection $obj.ConnectionAlias
                                            # If the source item exists
                                            if ($null -ne $sourceItem) {
                                                if ($substitions.ContainsKey($sourceItem.ParentID)) {
                                                    $tempProcessFolder = Get-AMFolder -ID $substitions[$sourceItem.ParentID] -Connection $Connection
                                                } else {
                                                    $tempProcessFolder = $processFolder
                                                }
                                                $destinationItem = Get-AMProcess -FilterSet $idFilterSet,@{Property = "Name"; Operator = "="; Value = $sourceItem.Name} -Connection $Connection
                                                # If the destination item exists
                                                if ($null -ne $destinationItem) {
                                                    # Prompt user for conflict action
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
                                                            # Copy object from source server to destination server
                                                            $newProcess = $sourceItem | Copy-AMProcess -Folder $tempProcessFolder -Connection $Connection
                                                            $substitions.Add($item.ConstructID, $newProcess.ID)
                                                        }
                                                        "UseDestinationServerObject" {
                                                            # Use existing object in the destination server
                                                            $substitions.Add($item.ConstructID, $destinationItem.ID)
                                                        }
                                                    }
                                                } else {
                                                    # If the destination item does not already exist, create it
                                                    $newProcess = $sourceItem | Copy-AMProcess -Folder $tempProcessFolder -Connection $Connection
                                                    $substitions.Add($item.ConstructID, $newProcess.ID)
                                                }
                                            } else {
                                                # Enter a bogus GUID, will result in an unbuilt item
                                                $substitions.Add($item.ConstructID, (New-Guid).Guid)
                                            }
                                        }
                                    }
                                }
                                $newItem.ConstructID = $substitions[$item.ConstructID]
                            } else {
                                $newItem.ConstructID = $item.ConstructID
                            }
                            $newItem.ConstructType = $item.ConstructType
                        }
                    }
                    # Retain the item ID if it does not already exist
                    if ($item.ID -notin $existingIds) {
                        $newItem.ID = $item.ID
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
                    $substitions.Add($item.ID, $newItem.ID)
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
                    # If copying to another server
                    if ($obj.ConnectionAlias -ne $Connection.Alias) {
                        # Look for any specified substitions for the agent, use if provided
                        if ($substitions.ContainsKey($trigger.AgentID)) {
                            $newTrigger.AgentID = $substitions[$trigger.AgentID]
                        }
                        # If there is no substition specified for the item
                        if (-not $substitions.ContainsKey($trigger.ConstructID)) {
                            $idFilterSet = @{Property = "ID"; Operator = "="; Value = $trigger.ConstructID}
                            $sourceItem = Get-AMCondition -FilterSet $idFilterSet -Connection $obj.ConnectionAlias
                            # If the source item exists
                            if ($null -ne $sourceItem) {
                                if ($substitions.ContainsKey($sourceItem.ParentID)) {
                                    $tempConditionFolder = Get-AMFolder -ID $substitions[$sourceItem.ParentID] -Connection $Connection
                                } else {
                                    $tempConditionFolder = $conditionFolder
                                }
                                $destinationItem = Get-AMCondition -FilterSet $idFilterSet,@{Property = "Name"; Operator = "="; Value = $sourceItem.Name} -Connection $Connection
                                # If the destination item exists
                                if ($null -ne $destinationItem) {
                                    # Prompt for conflict action
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
                                            # Copy object from source server to destination server
                                            $newCondition = $sourceItem | Copy-AMCondition -Folder $tempConditionFolder -Connection $Connection
                                            $substitions.Add($trigger.ConstructID, $newCondition.ID)
                                        }
                                        "UseDestinationServerObject" {
                                            # Use existing object in the destination server
                                            $substitions.Add($trigger.ConstructID, $destinationItem.ID)
                                        }
                                    }
                                } else {
                                    # If the destination item does not already exist, create it
                                    $newCondition = $sourceItem | Copy-AMCondition -Folder $tempConditionFolder -Connection $Connection
                                    $substitions.Add($trigger.ConstructID, $newCondition.ID)
                                }
                            } else {
                                # Enter a bogus GUID, will result in an unbuilt item
                                $substitions.Add($trigger.ConstructID, (New-Guid).Guid)
                            }
                        }
                        $newTrigger.ConstructID = $substitions[$trigger.ConstructID]
                    } else {
                        $newTrigger.ConstructID = $trigger.ConstructID
                    }
                    # Retain the item ID if it does not already exist
                    if ($trigger.ID -notin $existingIds) {
                        $newTrigger.ID = $trigger.ID
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
                    $substitions.Add($trigger.ID, $newTrigger.ID)
                }
                foreach ($link in $currentObject.Links) {
                    switch ($Connection.Version.Major) {
                        10      { $newLink = [AMWorkflowLinkv10]::new($Connection.Alias) }
                        11      { $newLink = [AMWorkflowLinkv11]::new($Connection.Alias) }
                        default { throw "Unsupported server major version: $_!" }
                    }
                    # Retain the link ID if it does not already exist
                    if ($link.ID -notin $existingIds) {
                        $newLink.ID = $link.ID
                    }
                    $newLink.DestinationID    = $substitions[$link.DestinationID]
                    $newLink.DestinationPoint = [PSCustomObject]@{x = $link.DestinationPoint.X; y = $link.DestinationPoint.Y}
                    $newLink.LinkType         = $link.LinkType
                    $newLink.ResultType       = $link.ResultType
                    $newLink.SourceID         = $substitions[$link.SourceID]
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
                    # Retain the variable ID if it does not already exist
                    if ($variable.ID -notin $existingIds) {
                        $newVariable.ID = $variable.ID
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
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}