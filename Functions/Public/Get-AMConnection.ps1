function Get-AMConnection {
    <#
        .SYNOPSIS
            Gets current AutoMate Enterprise connections.

        .DESCRIPTION
            Get-AMConnection gets a list of current connections to AutoMate Enterprise.

        .PARAMETER Connection
            The connection name(s) or object(s).

        .PARAMETER ConnectionAlias
            The connection alias name.

        .INPUTS
            Connection, String

        .OUTPUTS
            Connection

        .EXAMPLE
            $connection = Connect-AMServer "automate01"
            Get-AMConnection -Connection $connection

        .EXAMPLE
            Connect-AMServer "automate01" -ConnectionAlias "prod"
            Get-AMConnection -Connection "prod"

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="AllConnections")]
    param (
        [Alias("ConnectionAlias")]
        [Parameter(ParameterSetName = "ByConnection")]
        [ArgumentCompleter([AMConnectionCompleter])]
        [ValidateNotNullOrEmpty()]
        $Connection
    )

    Process {
        switch ($PSCmdlet.ParameterSetName) {
            "AllConnections" {
                $connections = $global:AMConnections
            }
            "ByConnection" {
                if ($Connection -is [string]) {
                    $connections = $global:AMConnections | Where-Object {$_.Alias -eq $Connection}
                } elseif ($Connection -is [AMConnection]) {
                    $connections = $Connection
                } elseif ($Connection -is [array]) {
                    $connections = @()
                    foreach ($c in $Connection) {
                        $connections += Get-AMConnection -Connection $c
                    }
                }
            }
        }
        return $connections
    }
}
