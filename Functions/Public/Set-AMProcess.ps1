function Set-AMProcess {
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise process.

        .DESCRIPTION
            Set-AMProcess can change properties of a process object.

        .PARAMETER InputObject
            The object to modify.

        .PARAMETER Instance
            The process object to save directly to the server.  This parameter takes a process that has been manually modified to be saved as-is to the server.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER CommandLine
            The command to run.

        .PARAMETER WorkingDirectory
            The working directory to use when running the command.

        .PARAMETER EnvironmentVariables
            Environment variables to load when running the command.

        .PARAMETER RunningContext
            The context to execute the command in: Default, SH or Bash.

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Process

        .EXAMPLE
            # Change command for a process
            Get-AMProcess "Start Service" | Set-AMProcess -Notes "Starts a service"

        .EXAMPLE
            # Empty notes for all agent groups
            Get-AMProcess | Set-AMProcess -RunningContext Bash

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
            if ($_.Type -eq "Process") {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"Instance is not a Process!"
            }
        })]
        $Instance,

        [Parameter(ParameterSetName = "ByInputObject")]
        [string]$Notes,

        [Parameter(ParameterSetName = "ByInputObject")]
        [ValidateNotNullOrEmpty()]
        [string]$CommandLine,

        [Parameter(ParameterSetName = "ByInputObject")]
        [string]$WorkingDirectory,

        [Parameter(ParameterSetName = "ByInputObject")]
        [string]$EnvironmentVariables,

        [Parameter(ParameterSetName = "ByInputObject")]
        [AMRunProcessAs]$RunningContext,

        [Parameter(ParameterSetName = "ByInputObject")]
        [AMCompletionState]$CompletionState
    )
    PROCESS {
        switch ($PSCmdlet.ParameterSetName) {
            "ByInputObject" {
                foreach ($obj in $InputObject) {
                    if ($obj.Type -eq "Process") {
                        $updateObject = Get-AMProcess -ID $obj.ID -Connection $obj.ConnectionAlias
                        $shouldUpdate = $false
                        if ($PSBoundParameters.ContainsKey("CommandLine")) {
                            if ($updateObject.CommandLine -ne $CommandLine) {
                                $updateObject.CommandLine = $CommandLine
                                $shouldUpdate = $true
                            }
                        }
                        if ($PSBoundParameters.ContainsKey("WorkingDirectory")) {
                            if ($updateObject.WorkingDirectory -ne $WorkingDirectory) {
                                $updateObject.WorkingDirectory = $WorkingDirectory
                                $shouldUpdate = $true
                            }
                        }
                        if ($PSBoundParameters.ContainsKey("EnvironmentVariables")) {
                            if ($updateObject.EnvironmentVariables -ne $EnvironmentVariables) {
                                $updateObject.EnvironmentVariables = $EnvironmentVariables
                                $shouldUpdate = $true
                            }
                        }
                        if ($PSBoundParameters.ContainsKey("RunningContext")) {
                            if ($updateObject.RunProcessAs -ne $RunningContext) {
                                $updateObject.RunProcessAs = $RunningContext
                                $shouldUpdate = $true
                            }
                        }
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
