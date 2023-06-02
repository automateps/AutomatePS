function New-AMUser {
    <#
        .SYNOPSIS
            Creates a new Automate user.

        .DESCRIPTION
            New-AMUser creates a new user object.

        .PARAMETER Name
            The name/username of the new object.

        .PARAMETER Password
            The password for the user.

        .PARAMETER UseActiveDirectory
            Authenticate against Active Directory.  If not specified, Automate authentication is used.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .EXAMPLE
            # Create new user that authenticates against Active Directory
            New-AMUser -Name John -UseActiveDirectory

        .EXAMPLE
            # Create new user that authenticates against Automate (prompts for password)
            New-AMUser -Name John -Password (Read-Host -Prompt "Enter password" -AsSecureString)

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMUser.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $true, ParameterSetName = "AutomatePassword")]
        [ValidateNotNullOrEmpty()]
        [Security.SecureString]$Password,

        [Parameter(Mandatory = $true, ParameterSetName = "ActiveDirectoryPassword")]
        [switch]$UseActiveDirectory,

        [string]$Notes = "",

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
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
            if (-not $Folder) { $Folder = Get-AMFolder -Path "\" -Name "USERS" -Connection $Connection } # Place the user in the root users folder
            switch ($Connection.Version.Major) {
                10             { $newObject = [AMUserv10]::new($Name, $Folder, $Connection.Alias) }
                {$_ -in 11,22} { $newObject = [AMUserv11]::new($Name, $Folder, $Connection.Alias) }
                default        { throw "Unsupported server major version: $_!" }
            }
            $newObject.CreatedBy = $user.ID
            $newObject.Notes     = $Notes
            $newObject.Username  = $Name
            if ($UseActiveDirectory.IsPresent) {
                $newObject.Password = "<!*!>"
            } else {
                $newObject.Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
            }
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple Automate servers are connected, please specify which server to create the new user on!" }
    }
}