function Open-AMWorkflowDesigner {
    <#
        .SYNOPSIS
            Opens the Workflow Designer for the specified workflow(s).

        .DESCRIPTION
            Open-AMWorkflowDesigner opens the workflow designer for the specified workflow(s).

        .PARAMETER Workflow
            The workflow to launch the designer for.

        .PARAMETER InstallationPath
            If the Automate Developer Tools are not installed in the default location, specify the path to the tools here.

        .INPUTS
            The following Automate object types can be processed by this function:
            Workflow

        .OUTPUTS
            None

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Open-AMWorkflowDesigner.md
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        $Workflow,

        [ValidateScript({
            if (Test-Path -Path $_) {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"InstallationPath '$_' does not exist!"
            }
        })]
        $InstallationPath
    )

    BEGIN {
        $designerEXE = "AMWFD.EXE"
    }

    PROCESS {
        foreach ($obj in $Workflow) {
            $connection = Get-AMConnection -ConnectionAlias $Workflow.ConnectionAlias
            switch ($connection.Version.Major) {
                10 {
                    $programFolder = "AutoMate BPA Server 10"
                    $utilityDLL = "AutoMate.Utilities.v10.dll"
                    $managementServerPort = 9603
                }
                11 {
                    $programFolder = "Automate Enterprise 11"
                    $utilityDLL = "AutoMate.Utilities.v11.dll"
                    $managementServerPort = 9703
                }
                default {
                    throw "Unsupported server major version: $_!"
                }
            }
            if (-not $PSBoundParameters.ContainsKey("InstallationPath")) {
                if (Test-Path -Path "$($env:ProgramFiles)\$programFolder") {
                    $InstallationPath = "$($env:ProgramFiles)\$programFolder"
                } elseif (Test-Path -Path "$(${env:ProgramFiles(x86)})\$programFolder") {
                    $InstallationPath = "$(${env:ProgramFiles(x86)})\$programFolder"
                } else {
                    throw "Could not find the installation path for Automate!"
                }
            }
            if (-not (Test-Path -Path "$InstallationPath\$designerEXE") -or -not(Test-Path -Path "$InstallationPath\$utilityDLL")) {
                throw "Specified InstallationPath '$InstallationPath' does not contain the required Automate binaries!"
            }
            Add-Type -Path "$InstallationPath\$utilityDLL"
            switch ($connection.Version.Major) {
                10 { $encryptedPass = [Automate.Utilities.v10.StringManager]::EncryptTripleDESSalted($connection.Credential.GetNetworkCredential().Password) }
                11 { $encryptedPass = [Automate.Utilities.v11.StringManager]::EncryptWithMostAdvanced($connection.Credential.GetNetworkCredential().Password) }
                default { throw "Unsupported server major version: $_!" }
            }

            $procArgs = [string]::Format('{0}:{1} "{2}" "{3}" "-ID:{4}"', $connection.Server, $managementServerPort, $connection.Credential.UserName, $encryptedPass, $Workflow.ID)

            $processStartInfo = [System.Diagnostics.ProcessStartInfo]::new()
            $processStartInfo.FileName = "$InstallationPath\$designerEXE"
            $processStartInfo.Arguments = $procArgs
            $processStartInfo.UseShellExecute = $true

            $process = [System.Diagnostics.Process]::new()
            $process.StartInfo = $processStartInfo
            $process.Start() | Out-Null
        }
    }
}
