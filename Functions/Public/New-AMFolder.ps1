function New-AMFolder {
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise folder.

        .DESCRIPTION
            New-AMFolder creates a new folder object.

        .PARAMETER Name
            The name of the new folder.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .EXAMPLE
            # Create a new folder
            Get-AMFolder ParentFolder | New-AMFolder -Name "FTP Workflows"

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

        [Parameter(Mandatory = $true)]
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
            switch ($Connection.Version.Major) {
                10      { $newObject = [AMFolderv10]::new($Name, $Folder, $Connection.Alias) }
                11      { $newObject = [AMFolderv11]::new($Name, $Folder, $Connection.Alias) }
                default { throw "Unsupported server major version: $_!" }
            }
            $newObject.CreatedBy = $user.ID
            $newObject.Notes     = $Notes
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple AutoMate servers are connected, please specify which server to create the new folder on!" }
    }
}