function Get-AMDefaultFolder {
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