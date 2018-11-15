function Get-AMServer {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise server information.

        .DESCRIPTION
            Get-AMServer gets information about the server.

        .PARAMETER Type
            The type of server information to retrieve.

        .PARAMETER Connection
            The AutoMate Enterprise management server.

        .EXAMPLE
            # Get information about the management server
            Get-AMServer -Type Management

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param (
        [ValidateSet("Server","Execution","Management")]
        [ValidateNotNullOrEmpty()]
        [string]$Type = "Server",

        [ValidateNotNullOrEmpty()]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    switch ($Type) {
        "Server" {
            $result = Invoke-AMRestMethod -Resource "info/get" -RestMethod "Get" -Connection $Connection
            $result | Foreach-Object {$_.PSObject.TypeNames.Insert(0,"AMServer")}
            $result | ForEach-Object {$_.Version = [Version]$_.Version} # Cast to the [Version] type
        }
        "Execution" {
            $result = Invoke-AMRestMethod -Resource "metrics/execution/get" -RestMethod "Get" -Connection $Connection
            $result | Foreach-Object {$_.PSObject.TypeNames.Insert(0,"AMServerExecution")}
        }
        "Management" {
            $result = Invoke-AMRestMethod -Resource "metrics/management/get" -RestMethod "Get" -Connection $Connection
            $result | Foreach-Object {$_.PSObject.TypeNames.Insert(0,"AMServerManagement")}
        }
    }

    return $result
}
