function Get-AMConnectionStoreItem {
    <#
        .SYNOPSIS
            Retrieves connections for the specified Automate server

        .DESCRIPTION
            Get-AMConnectionStoreItem stores a server and connection object together in a connection store file.

        .PARAMETER Server
            The Automate management server.

        .PARAMETER Port
            The TCP port for the management API.

        .PARAMETER FilePath
            The file the server/connection combinations are stored in.  It is stored in the user profile by default.

        .EXAMPLE
            Get-AMConnectionStoreItem -Connection server01

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [Parameter(Position = 0, ParameterSetName = "ByServerOrPort")]
        [ValidateNotNullOrEmpty()]
        [string]$Server,

        [Parameter(ParameterSetName = "ByServerOrPort")]
        [ValidateNotNullOrEmpty()]
        [int]$Port,

        [ValidateScript({
            if (Test-Path -Path $_) {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"FilePath '$_' does not exist!"
            }
        })]
        [string]$FilePath = "$($env:APPDATA)\AutomatePS\connstore.xml"
    )

    if (Test-Path -Path $FilePath) {
        $items = Import-Clixml -Path $FilePath
        $items | ForEach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name FilePath -Value $FilePath
            $_.PSObject.Typenames.Insert(0, "ConnectionStoreItem")
        }
        switch ($PSCmdlet.ParameterSetName) {
            "Default" {
                $items
            }
            "ByServerOrPort" {
                foreach ($item in $items) {
                    $found = $true
                    if ($PSBoundParameters.ContainsKey("Server") -and $item.Server -ne $Server) {
                        $found = $false
                    }
                    if ($PSBoundParameters.ContainsKey("Port") -and $item.Port -ne $Port) {
                        $found = $false
                    }
                    if ($found) {
                        $item
                    }
                }
            }
        }
    }
}
