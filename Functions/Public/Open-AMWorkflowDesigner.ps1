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
            $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
            switch ($connection.Version.Major) {
                10 { $programFolder = "AutoMate BPA Server 10"  }
                11 { $programFolder = "Automate Enterprise 11" }
                22 { $programFolder = "Automate Enterprise 2022" }
                23 { $programFolder = "Automate 2023" }
                24 { $programFolder = "Automate 2024" }
                25 { $programFolder = "Automate 2025" }
                default {
                    if (-not $PSBoundParameters.ContainsKey("InstallationPath")) {
                        throw "Unsupported server major version: $_!"
                    }
                }
            }
            switch ($connection.GetCompatibility()) {
                10 {
                    $utilityDLL = "AutoMate.Utilities.v10.dll"
                    $managementServerPort = 9603
                }
                11 {
                    $utilityDLL = "AutoMate.Utilities.v11.dll"
                    $managementServerPort = 9703
                }
            }
            $x64path = Join-Path -Path $env:ProgramFiles -ChildPath $programFolder
            $x86path = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath $programFolder
            if (-not $PSBoundParameters.ContainsKey("InstallationPath")) {
                if     (Test-Path -Path $x64path) { $InstallationPath = $x64path }
                elseif (Test-Path -Path $x86path) { $InstallationPath = $x86path }
                else                              { throw "Could not find the installation path for Automate!" }
            }
            $designerPath = Join-Path -Path $InstallationPath -ChildPath $designerEXE
            $utilityPath  = Join-Path -Path $InstallationPath -ChildPath $utilityDLL
            if (-not (Test-Path -Path $designerPath) -or -not(Test-Path -Path $utilityPath)) {
                throw "Specified InstallationPath '$InstallationPath' does not contain the required Automate binaries!"
            }
            Add-Type -Path $utilityPath
            switch ($connection.GetCompatibility()) {
                10 { $encryptedPass = [Automate.Utilities.v10.StringManager]::EncryptTripleDESSalted($connection.Credential.GetNetworkCredential().Password) }
                11 { $encryptedPass = [Automate.Utilities.v11.StringManager]::EncryptWithMostAdvanced($connection.Credential.GetNetworkCredential().Password) }
            }

            $procArgs = [string]::Format('{0}:{1} "{2}" "{3}" "-ID:{4}"', $connection.Server, $managementServerPort, $connection.Credential.UserName, $encryptedPass, $Workflow.ID)

            $processStartInfo = [System.Diagnostics.ProcessStartInfo]::new()
            $processStartInfo.FileName = $designerPath
            $processStartInfo.Arguments = $procArgs
            $processStartInfo.UseShellExecute = $true

            $process = [System.Diagnostics.Process]::new()
            $process.StartInfo = $processStartInfo
            $process.Start() | Out-Null
        }
    }
}
