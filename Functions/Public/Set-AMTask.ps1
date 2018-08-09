function Set-AMTask {
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise task.

        .DESCRIPTION
            Set-AMTask can change properties of a task object.

        .PARAMETER InputObject
            The object to modify.

        .PARAMETER Instance
            The task object to save directly to the server.  This parameter takes a task that has been manually modified to be saved as-is to the server.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER AML
            The new AutoMate Markup Language (AML) to set on the object.

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Task

        .EXAMPLE
            # Change notes for a task
            Get-AMTask "Delete Log Files" | Set-AMTask -Notes "Deletes old log files"

        .EXAMPLE
            # Change AML for a task
            Get-AMTask "Some Task" | Set-AMTask -AML (Get-AMTask "Some Other Task").AML

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "ByInputObject")]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = "ByInstance")]
        [ValidateScript({
            if ($_.Type -eq "Task") {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"Instance is not a Task!"
            }
        })]
        $Instance,

        [Parameter(ParameterSetName = "ByInputObject")]
        [string]$Notes,

        [Parameter(ParameterSetName = "ByInputObject")]
        [ValidateScript({
            if (($_ -is [string]) -and ($_.Trim() -like "<AMTASK>*</AMTASK>")) {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"AML is invalid!"
            }
        })]
        [string]$AML,

        [Parameter(ParameterSetName = "ByInputObject")]
        [AMCompletionState]$CompletionState
    )
    PROCESS {
        switch ($PSCmdlet.ParameterSetName) {
            "ByInputObject" {
                foreach ($obj in $InputObject) {
                    if ($obj.Type -eq "Task") {
                        $updateObject = Get-AMTask -ID $obj.ID -Connection $obj.ConnectionAlias
                        $shouldUpdate = $false
                        if ($PSBoundParameters.ContainsKey("Notes")) {
                            if ($updateObject.Notes -ne $Notes) {
                                $updateObject.Notes = $Notes
                                $shouldUpdate = $true
                            }
                        }
                        if ($PSBoundParameters.ContainsKey("AML")) {
                            if ($updateObject.AML -ne $AML) {
                                $updateObject.AML = $AML
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
                if (($updateObject.AML -is [string]) -and ($updateObject.AML.Trim() -notlike "<AMTASK>*</AMTASK>")) {
                    $validated = $false
                    throw "$($Instance.Type) '$($Instance.Name)' has invalid AML!"
                }
                if ($validated) {
                    $updateObject | Set-AMObject
                }
            }
        }
    }
}
