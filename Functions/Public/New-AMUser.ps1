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

        .PARAMETER Domain
            The domain the user will authenticate against if running Automate version 23.1 or later.  On earlier versions specifying this parameter will enable AD authentication, but the domain passed in is ignored and the machine domain is used instead.

        .PARAMETER ForceReset
            Force the user to reset their password on login.

        .PARAMETER UseSecureConnection
            Use encryption when authenticating against Active Directory.

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
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low",DefaultParameterSetName="AutomateAuth")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $true, ParameterSetName = "AutomateAuth")]
        [ValidateNotNullOrEmpty()]
        [Security.SecureString]$Password,

        [Parameter(Mandatory = $true, ParameterSetName = "ADAuth")]
        [ValidateNotNullOrEmpty()]
        [string]$Domain,
        
        [Parameter(ParameterSetName = "AutomateAuth")]
        [switch]$ForceReset,
        
        [Parameter(ParameterSetName = "ADAuth")]
        [switch]$UseSecureConnection,

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
    switch ($PSCmdlet.ParameterSetName) {
        "AutomateAuth" { $AuthProvider = [AMAuthProvider]::Automate }
        "ADAuth"       { $AuthProvider = [AMAuthProvider]::AD }
    }
    switch (($Connection | Measure-Object).Count) {
        1 {
            if (-not $Folder) { $Folder = Get-AMFolder -Path "\" -Name "USERS" -Connection $Connection }
            switch ($Connection.Version.Major) {
                10             { $newObject = [AMUserv10]::new($Name, $Folder, $Connection.Alias) }
                {$_ -in 11,22} { $newObject = [AMUserv11]::new($Name, $Folder, $Connection.Alias) }
                {$_ -in 23,24} { $newObject = [AMUserv1123]::new($Name, $Folder, $Connection.Alias) }
                default        { throw "Unsupported server major version: $_!" }
            }
            $newObject.Notes     = $Notes
            $newObject.Username  = $Name
            if ($AuthProvider -eq [AMAuthProvider]::AD) {
                if (Test-AMFeatureSupport -Connection $Connection -Feature MultiDomainUser -Action Ignore) {
                    $newObject.AuthProvider = $AuthProvider
                    $newObject.Domain = $Domain
                    $newObject.UseSecureConnection = $UseSecureConnection.IsPresent
                } else {                    
                    $newObject.Password = "<!*!>"
                }
            } else {
                $newObject.Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
                if (Test-AMFeatureSupport -Connection $Connection -Feature MultiDomainUser -Action Ignore) {
                    $newObject.AuthProvider = $AuthProvider
                    $newObject.ForceReset = $ForceReset.IsPresent
                }
            }
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple Automate servers are connected, please specify which server to create the new user on!" }
    }
}