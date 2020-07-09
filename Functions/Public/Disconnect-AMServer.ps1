function Disconnect-AMServer {
    <#
        .SYNOPSIS
            Disconnect from an Automate management server

        .DESCRIPTION
            Disconnect-AMServer removes stored connection information for the management server(s).

        .PARAMETER Connection
            The Automate management server. If the server isn't specified, all servers are removed.

        .EXAMPLE
            Disonnect-AMServer -Connection "AM01" -Credential (Get-Credential)

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    param (
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "ByConnection", Position = 0)]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    PROCESS {
        if ($null -ne (Get-Variable AMConnections -Scope Global -ErrorAction SilentlyContinue)) {
            switch ($PSCmdlet.ParameterSetName) {
                "All" {
                    Remove-Variable AMConnections -Scope Global
                }
                "ByConnection" {
                    foreach ($c in $Connection) {
                        $c = Get-AMConnection -Connection $c
                        $global:AMConnections = $global:AMConnections | Where-Object {$_.Name -ne $c.Name}
                    }
                }
            }
        }
    }
}
