function New-AMConnectionStoreItem {
    <#
        .SYNOPSIS
            Save the connection for the specified Automate server

        .DESCRIPTION
            New-AMConnectionStoreItem stores a server and credential object together in a credential store file.

        .PARAMETER Server
            The Automate management server.

        .PARAMETER Port
            The TCP port for the management API.

        .PARAMETER ConnectionAlias
            The alias to save with the stored connection.

        .PARAMETER Credential
            The credentials use during authentication.

        .PARAMETER UserName
            The username to use during authentication.

        .PARAMETER Password
            The password to use during authentication.

        .PARAMETER FilePath
            The file to store the server/credential combinations in.  It is stored in the user profile by default.

        .EXAMPLE
            New-AMConnectionStoreItem -Connection server01 -Credential (Get-Credential)

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Server,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$Port,

        [ValidateNotNullOrEmpty()]
        [string]$ConnectionAlias,

        [Parameter(ParameterSetName = "ByCredential")]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(ParameterSetName = "ByUserPass")]
        [ValidateNotNullOrEmpty()]
        [string]$UserName,

        [Parameter(ParameterSetName = "ByUserPass")]
        [ValidateNotNullOrEmpty()]
        [Security.SecureString]$Password,

        [string]$FilePath = "$($env:APPDATA)\AutomatePS\connstore.xml"
    )

    if ($PSCmdlet.ParameterSetName -eq "ByUserPass") {
        $Credential = New-Object System.Management.Automation.PSCredential($UserName, $Password)
    }
    if (-not $PSBoundParameters.ContainsKey("ConnectionAlias")) {
        $ConnectionAlias = "$($Server):$($Port)"
    }
    $newItem = [PSCustomObject]@{
        Server     = $Server
        Port       = $Port
        Credential = $Credential
        Alias      = $ConnectionAlias
        ID         = (New-Guid).Guid
        Type       = "ConnectionStoreItem"
    }
    if ($PSCmdlet.ShouldProcess("Creating saved connection to $($newItem.Server):$($newItem.Port) for user $($newItem.Credential.UserName).")) {
        if (Test-Path -Path $FilePath) {
            $items = Import-Clixml -Path $FilePath
            if ($items.Alias -contains $ConnectionAlias) {
                throw "A connection with this alias already exists in the connection store!"
            }
            # Change it if it already exists, otherwise add it
            if ($null -ne $items) {
                $found = $false
                foreach ($item in $items) {
                    if ($item.Server -eq $Server -and $item.Port -eq $Port) {
                        $item = $newItem
                    }
                }
                if (-not $found) {
                    if ($items -is [Array]) {
                        $items += $newItem
                    } else {
                        $items = @($items,$newItem)
                    }
                }
            } else {
                $items = @($newItem)
            }
        } else {
            # Create folder if it doesn't exist
            if (-not (Test-Path -Path (Split-Path -Path $FilePath -Parent))) {
                New-Item -Path (Split-Path -Path $FilePath -Parent) -ItemType Directory -Force | Out-Null
            }
            $items = @($newItem)
        }
        $items | Export-Clixml -Path $FilePath
    }
}
