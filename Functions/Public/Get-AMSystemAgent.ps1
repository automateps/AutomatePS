function Get-AMSystemAgent {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise system agent types.

        .DESCRIPTION
            Get-AMSystemAgent returns a list of system agent types and their IDs.

        .PARAMETER ID
            The ID of the system agent.

        .PARAMETER Type
            The type of system agent to return.

        .PARAMETER Connection
            The AutoMate Enterprise management server.

        .EXAMPLE
            # Get the default system agent
            Get-AMSystemAgent -Type Default

        .EXAMPLE
            # Get workflows that use "Previous Agent"
            Get-AMSystemAgent -Type Previous | Get-AMWorkflow

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param (
        [Parameter(ParameterSetName="ByID")]
        [ValidateNotNullOrEmpty()]
        [string]$ID,

        [Parameter(ParameterSetName="ByType")]
        [ValidateSet("Condition","Default","Previous","Triggered","Variable")]
        [string]$Type,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
        if ($Connection.Name -notin (Get-AMConnection).Name) {
            throw "Not connected to server $($Connection.Name)!"
        }
    } else {
        $Connection = Get-AMConnection
    }

    foreach ($c in $Connection) {
        switch ($PSCmdlet.ParameterSetName) {
            "ByID" {
                $name = [AMSystemAgent]::new().GetByID($ID)
                if ($name) {
                    [PSCustomObject]@{
                        ID              = $ID
                        Name            = $name
                        Type            = "SystemAgent"
                        ConnectionAlias = $c.Alias
                    }
                }
            }
            "ByType" {
                # Return specified system agent type
                [PSCustomObject]@{
                    ID              = [AMSystemAgent]::$Type
                    Name            = $Type
                    Type            = "SystemAgent"
                    ConnectionAlias = $c.Alias
                }
            }
            "All" {
                # Return all system agent types
                $Types = @("Condition","Default","Previous","Triggered","Variable")
                foreach ($Type in $Types) {
                    [PSCustomObject]@{
                        ID              = [AMSystemAgent]::$Type
                        Name            = $Type
                        Type            = "SystemAgent"
                        ConnectionAlias = $c.Alias
                    }
                }
            }
        }
    }
}
