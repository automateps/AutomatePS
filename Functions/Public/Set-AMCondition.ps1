function Set-AMCondition {
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise condition.

        .DESCRIPTION
            Set-AMCondition can change properties of a condition object.

        .PARAMETER InputObject
            The object to modify.

        .PARAMETER Instance
            The object to save.  Use this parameter if the object was modified directly, and not by another function in this module.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Task

        .EXAMPLE
            # Change notes for a task
            Get-AMCondition "Daily at 8AM" | Set-AMCondition -Notes "Starts every day at 8AM"

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
            if ($_.Type -eq "Condition") {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"Instance is not a Condition!"
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
                    if ($obj.Type -eq "Condition") {
                        $updateObject = Get-AMCondition -ID $obj.ID -Connection $obj.ConnectionAlias
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
                if ($validated) {
                    $updateObject | Set-AMObject
                }
            }
        }
    }
}
