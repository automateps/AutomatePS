function Connect-AMServer {
    <#
        .SYNOPSIS
            Connect to an Automate management server

        .DESCRIPTION
            Connect-AMServer gathers connection information for Automate, and tests authentication.
            This module supports connecting to multiple servers at once.

        .PARAMETER Server
            The Automate management server.  One or more can be provided.  The same credentials are used for all servers.

        .PARAMETER Port
            The TCP port for the management API.

        .PARAMETER Credential
            The credentials use during authentication.

        .PARAMETER UserName
            The username to use during authentication.

        .PARAMETER Password
            The password to use during authentication.

        .PARAMETER ConnectionAlias
            The alias to assign to this connection.

        .PARAMETER ConnectionStoreFilePath
            The file that connections are stored in.

        .PARAMETER SaveConnection
            Saves the new connection to the connection store.

        .OUTPUTS
            Connection

        .EXAMPLE
            Connect-AMServer -Connection "automate01" -Credential (Get-Credential)

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="ByConnectionStore")]
    [OutputType([AMConnection[]])]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Server,

        [ValidateNotNullOrEmpty()]
        [int]$Port = 9708,

        [Parameter(ParameterSetName = "ByCredential")]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(ParameterSetName = "ByUserPass")]
        [ValidateNotNullOrEmpty()]
        [string]$UserName,

        [Parameter(ParameterSetName = "ByUserPass")]
        [ValidateNotNullOrEmpty()]
        [Security.SecureString]$Password,

        [ValidateNotNullOrEmpty()]
        [string]$ConnectionAlias,

        [Parameter(ParameterSetName = "ByConnectionStore")]
        [ValidateScript({
            if (Test-Path -Path $_) {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"ConnectionStoreFilePath '$_' does not exist!"
            }
        })]
        [string]$ConnectionStoreFilePath = "$($env:APPDATA)\AutomatePS\connstore.xml",

        [switch]$SaveConnection = $false
    )
    if ($PSCmdlet.ParameterSetName -eq "ByUserPass") {
        $Credential = [System.Management.Automation.PSCredential]::new($UserName, $Password)
    }
    foreach ($s in $Server) {
        $fromStoredConnection = $false
        # If no credentials were supplied, check the credential store
        if ($PSCmdlet.ParameterSetName -eq "ByConnectionStore") {
            $fromStoredConnection = $true
            if (Test-Path -Path $ConnectionStoreFilePath) {
                if ($PSBoundParameters.ContainsKey("Port")) {
                    $storedConnection = Get-AMConnectionStoreItem -Server $s -Port $Port -FilePath $ConnectionStoreFilePath
                } else {
                    $storedConnection = Get-AMConnectionStoreItem -Server $s -FilePath $ConnectionStoreFilePath
                }
            }
            # If no connections are found in the store, prompt for credential, otherwise connect
            if (($storedConnection | Measure-Object).Count -eq 0) {
                $Credential = Get-Credential -Message "Enter credentials for Automate server '$s'"
                if ($null -ne $Credential)  {
                    if ($PSBoundParameters.ContainsKey("ConnectionAlias")) {
                        Connect-AMServer -Server $s -Port $Port -Credential $Credential -ConnectionAlias $ConnectionAlias -SaveConnection:$SaveConnection.ToBool()
                    } else {
                        Connect-AMServer -Server $s -Port $Port -Credential $Credential -SaveConnection:$SaveConnection.ToBool()
                    }
                } else {
                    throw "No credentials specified for server '$s'!"
                }
            } else {
                $storedConnection | ForEach-Object {Connect-AMServer -Server $_.Server -Port $_.Port -Credential $_.Credential -ConnectionAlias $_.Alias}
            }
        }

        if (-not $fromStoredConnection) {
            if ($PSBoundParameters.ContainsKey("ConnectionAlias")) {
                $thisConnection = [AMConnection]::new($ConnectionAlias, $s, $Port, $Credential)
            } else {
                $thisConnection = [AMConnection]::new($s, $Port, $Credential)
            }
            if ($global:AMConnections.Name -notcontains $thisConnection.Name) {
                if ($global:AMConnections.Alias -notcontains $thisConnection.Alias) {
                    if ($thisConnection.Authenticate()) {
                        # Only save credential if authentication is successful
                        if ($SaveConnection.ToBool()) {
                            New-AMConnectionStoreItem -Server $s -Port $Port -Credential $Credential -ConnectionAlias $thisConnection.Alias -File $ConnectionStoreFilePath
                        }
                        if ($null -eq (Get-Variable AMConnections -ErrorAction SilentlyContinue)) {
                            # Store connection info for multiple servers in an array
                            $global:AMConnections = @()
                        }
                        # Make sure connection info variable is still an array, if not, make it an array
                        if ($global:AMConnections -is [System.Array]) {
                            $global:AMConnections += $thisConnection
                        } else {
                            $global:AMConnections = @($global:AMConnections, $thisConnection)
                        }
                        return $thisConnection
                    }
                } else {
                    throw "Already connected to another server with alias '$($thisConnection.Alias)'!"
                }
            } else {
                throw "Already connected to server '$($thisConnection.Name)'!"
            }
        }
    }
}
