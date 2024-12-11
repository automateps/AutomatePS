function Get-AMDefaultFolder {
    <#
        .SYNOPSIS
            Gets a default folder in the repository to place new objects.

        .DESCRIPTION
            Get-AMDefaultFolder gets a default location in the repository to place new objects.

        .PARAMETER Connection
            The connection to get the default folder for.

        .PARAMETER Type
            The type of repository folder.

        .EXAMPLE
            Get-AMDefaultFolder -Connection $connection -Type WORKFLOWS

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Connection,

        [Parameter(Mandatory = $true)]
        [ValidateSet("CONDITIONS","PROCESSES","TASKS","WORKFLOWS")]
        [string]$Type
    )

    switch ($Connection.AuthenticationMethod) {
        "Basic" {
            # Get the user folder
            $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
            $folder = $user | Get-AMFolder -Type $Type
        }
        "Bearer" {
            # When using bearer auth, we don't know which user we are, so just return the root folder
            $folder = Get-AMFolder -Type $Type -Path \
        }
    }
    return $folder
}