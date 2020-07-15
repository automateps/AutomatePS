function Set-AMWorkflow {
    <#
        .SYNOPSIS
            Sets properties of an Automate workflow.

        .DESCRIPTION
            Set-AMWorkflow can change properties of a workflow object.

        .PARAMETER InputObject
            The object to modify.

        .PARAMETER Instance
            The object to save.  Use this parameter if the object was modified directly, and not by another function in this module.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .INPUTS
            The following Automate object types can be modified by this function:
            Workflow

        .EXAMPLE
            # Change notes for a workflow
            Get-AMWorkflow "Some Workflow" | Set-AMWorkflow -Notes "Does something important"

        .EXAMPLE
            # Modify a workflow
            Set-AMWorkflow -Instance $modifiedWorkflow

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMWorkflow.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "ByInputObject")]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = "ByInstance")]
        [ValidateScript({
            if ($_.Type -eq "Workflow") {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"Instance is not a Workflow!"
            }
        })]
        $Instance,

        [Parameter(ParameterSetName = "ByInputObject")]
        [AllowEmptyString()]
        [string]$Notes,

        [Parameter(ParameterSetName = "ByInputObject")]
        [AMCompletionState]$CompletionState
    )
    PROCESS {
        switch ($PSCmdlet.ParameterSetName) {
            "ByInputObject" {
                foreach ($obj in $InputObject) {
                    if ($obj.Type -eq "Workflow") {
                        $updateObject = Get-AMWorkflow -ID $obj.ID -Connection $obj.ConnectionAlias
                        $shouldUpdate = $false

                        if ($PSBoundParameters.ContainsKey("Notes")) {
                            if ($updateObject.Notes -ne $Notes) {
                                $updateObject.Notes = $Notes
                                $shouldUpdate = $true
                            }
                        }
                        if ($PSBoundParameters.ContainsKey("CompletionState")) {
                            if ($updateObject.CompletionState -ne $CompletionState) {
                                $updateObject.CompletionState = $CompletionState
                                $shouldUpdate = $true
                            }
                        }
                        if ($shouldUpdate) {
                            $updateObject | Set-AMObject
                        } else {
                            Write-Verbose "$($obj.Type) '$($obj.Name)' already contains the specified values."
                        }
                    } else {
                        Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                    }
                }
            }
            "ByInstance" {
                $updateObject = $Instance.PSObject.Copy()
                $validated = $true
                if ($updateObject.ID -notmatch $AMGuidRegex) {
                    $validated = $false
                    throw "$($Instance.Type) '$($Instance.Name)' has an ID that is not a valid GUID!"
                }
                if ($updateObject.Items | Group-Object ID | Where-Object {$_.Count -gt 1}) {
                    $validated = $false
                    throw "$($Instance.Type) '$($Instance.Name)' has multiple items with the same ID!"
                }
                if ($updateObject.Triggers | Group-Object ID | Where-Object {$_.Count -gt 1}) {
                    $validated = $false
                    throw "$($Instance.Type) '$($Instance.Name)' has multiple triggers with the same ID!"
                }
                if ($updateObject.Links | Group-Object ID | Where-Object {$_.Count -gt 1}) {
                    $validated = $false
                    throw "$($Instance.Type) '$($Instance.Name)' has multiple links with the same ID!"
                }
                if ($updateObject.Variables | Group-Object ID | Where-Object {$_.Count -gt 1}) {
                    $validated = $false
                    throw "$($Instance.Type) '$($Instance.Name)' has multiple variables with the same ID!"
                }
                foreach ($item in ($updateObject.Items + $updateObject.Triggers + $updateObject.Links)) {
                    if ($item.ID -notmatch $AMGuidRegex) {
                        $validated = $false
                        throw "$($Instance.Type) '$($Instance.Name)' contains an item with an ID that is not a valid GUID!"
                    }
                    if ($item.WorkflowID -ne $updateObject.ID) {
                        $validated = $false
                        throw "$($Instance.Type) '$($Instance.Name)' contains an item with an invalid workflow ID!"
                    }
                }
                foreach ($variable in $updateObject.Variables) {
                    if ($variable.ID -notmatch $AMGuidRegex) {
                        $validated = $false
                        throw "$($Instance.Type) '$($Instance.Name)' contains a variable with an ID that is not a valid GUID!"
                    }
                    if ($variable.ParentID -ne $updateObject.ID) {
                        $validated = $false
                        throw "$($Instance.Type) '$($Instance.Name)' contains a variable with an invalid parent ID!"
                    }
                    if ([string]::IsNullOrEmpty($variable.Name)) {
                        $validated = $false
                        throw "$($Instance.Type) '$($Instance.Name)' contains a variable with an invalid name!"
                    }
                }
                if ($validated) {
                    $updateObject | Set-AMObject
                }
            }
        }
    }
}
