function New-AMProcess {
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise process.

        .DESCRIPTION
            New-AMProcess creates a new process object.

        .PARAMETER Name
            The name of the new object.

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

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .EXAMPLE
            # Change command for a process
            New-AMProcess -Name "Test Process" -CommandLine "dir.exe > %TEMP%\dir.txt" -EnvironmentVariables "TEMP"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 12/03/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [string]$Notes = "",

        [ValidateNotNullOrEmpty()]
        [string]$CommandLine,

        [string]$WorkingDirectory = "",

        [string]$EnvironmentVariables = "",

        [AMRunProcessAs]$RunningContext = ([AMRunProcessAs]::Default),

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    switch (($Connection | Measure-Object).Count) {
        1 {
            $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
            if (-not $Folder) { $Folder = $user | Get-AMFolder -Type PROCESSES -Connection $Connection } # Place the process in the users process folder
            switch ($Connection.Version.Major) {
                10      { $newObject = [AMProcessv10]::new($Name, $Folder, $Connection.Alias) }
                11      { $newObject = [AMProcessv11]::new($Name, $Folder, $Connection.Alias) }
                default { throw "Unsupported server major version: $_!" }
            }
            $newObject.CreatedBy            = $user.ID
            $newObject.Notes                = $Notes
            $newObject.CommandLine          = $CommandLine
            $newObject.EnvironmentVariables = $EnvironmentVariables
            $newObject.RunProcessAs         = $RunningContext
            $newObject.WorkingDirectory     = $WorkingDirectory
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple AutoMate servers are connected, please specify which server to create the new process on!" }
    }
}