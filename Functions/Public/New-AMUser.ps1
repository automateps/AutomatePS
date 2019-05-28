function New-AMUser {
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise user.

        .DESCRIPTION
            New-AMUser creates a new user object.

        .PARAMETER Name
            The name/username of the new object.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .EXAMPLE
            # Create new user
            New-AMUser -Name John

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        <#[string]$Password, API BUG: does not support setting user password via REST call #>

        [string]$Notes = "",

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
            if (-not $Folder) { $Folder = Get-AMFolder -Name USERS -Connection $Connection } # Place the user in the root users folder
            switch ($Connection.Version.Major) {
                10      { $newObject = [AMUserv10]::new($Name, $Folder, $Connection.Alias) }
                11      { $newObject = [AMUserv11]::new($Name, $Folder, $Connection.Alias) }
                default { throw "Unsupported server major version: $_!" }
            }
            $newObject.CreatedBy = $user.ID
            $newObject.Notes     = $Notes
            $newObject.Username  = $Name
            #$newObject.Password  = $Password # Not yet supported by the API
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple AutoMate servers are connected, please specify which server to create the new user on!" }
    }
}