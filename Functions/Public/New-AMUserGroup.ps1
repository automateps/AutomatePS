function New-AMUserGroup {
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise user group.

        .DESCRIPTION
            New-AMUserGroup creates a user group object.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .EXAMPLE
            # Create a user group
            New-AMUserGroup -Name "All Users" -Notes "Group containing all users"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [string]$Notes = "",

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    if (($Connection | Measure-Object).Count -gt 1) {
        throw "Multiple AutoMate Servers are connected, please specify which server to create the new user group on!"
    }

    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
    if (-not $Folder) {
        $Folder = Get-AMFolder -Name USERGROUPS -Connection $Connection
    }

    switch ($Connection.Version.Major) {
        10      { $newObject = [AMUserGroupv10]::new($Name, $Folder, $Connection.Alias) }
        11      { $newObject = [AMUserGroupv11]::new($Name, $Folder, $Connection.Alias) }
        default { throw "Unsupported server major version: $_!" }
    }
    $newObject.CreatedBy = $user.ID
    $newObject.Notes     = $Notes
    $newObject | New-AMObject -Connection $Connection
}