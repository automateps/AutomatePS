function Get-AMServer {
    <#
        .SYNOPSIS
            Gets Automate server information.

        .DESCRIPTION
            Get-AMServer gets information about the server.

        .PARAMETER Type
            The type of server information to retrieve.

        .PARAMETER Connection
            The Automate management server.

        .EXAMPLE
            # Get information about the management server
            Get-AMServer -Type Management

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMServer.md
    #>
    [CmdletBinding()]
    param (
        [ValidateSet("Server","Execution","Management")]
        [ValidateNotNullOrEmpty()]
        [string]$Type = "Server",

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $conn = Get-AMConnection -Connection $Connection
    } else {
        $conn = Get-AMConnection
    }
    $result = @()
    foreach ($c in $conn) {
        switch ($Type) {
            "Server" {
                $temp = Invoke-AMRestMethod -Resource "info/get" -RestMethod "Get" -Connection $c
                $temp.PSObject.TypeNames.Insert(0,"AMServer")
                $temp.Version = [Version]$temp.Version # Cast to the [Version] type
            }
            "Execution" {
                $temp = Invoke-AMRestMethod -Resource "metrics/execution/get" -RestMethod "Get" -Connection $c
                $temp.PSObject.TypeNames.Insert(0,"AMServerExecution")
            }
            "Management" {
                $temp = Invoke-AMRestMethod -Resource "metrics/management/get" -RestMethod "Get" -Connection $c
                $temp.PSObject.TypeNames.Insert(0,"AMServerManagement")
            }
        }
        $result += $temp
    }
    return $result
}