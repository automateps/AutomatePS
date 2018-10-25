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

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 10/25/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(DefaultParameterSetName = "AllConnections")]
    param (
        [Parameter(ParameterSetName = "ByConnection")]
        [ValidateNotNullOrEmpty()]
        $Connection
    )

    DynamicParam {
        New-DynamicParam -Name "ConnectionAlias" -ValidateSet $global:AMConnections.Alias -ParameterSetName "ByAlias" -Type ([string[]])
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            "AllConnections" {
                $connections = $global:AMConnections
            }
            "ByAlias" {
                $connections = @()
                foreach ($alias in $PSBoundParameters["ConnectionAlias"]) {
                    $connections += $global:AMConnections | Where-Object {$_.Alias -eq $alias}
                }
            }
            "ByConnection" {
                if ($Connection -is [string]) {
                    $connections = Get-AMConnection -ConnectionAlias $Connection
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
