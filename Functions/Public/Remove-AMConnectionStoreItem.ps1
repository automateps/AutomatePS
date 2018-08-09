function Remove-AMConnectionStoreItem {
    <#
        .SYNOPSIS
            Removes connection for the specified AutoMate Enterprise server from the connection store.

        .DESCRIPTION
            Remove-AMConnectionStoreItem removes connection objects from the connection store file.

        .PARAMETER ConnectionStoreItem
            The connection store item to delete.

        .EXAMPLE
            Remove-AMConnectionStoreItem -Connection server01

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $ConnectionStoreItem
    )
    PROCESS {
        foreach ($item in $ConnectionStoreItem) {
            if ($item.Type -eq "ConnectionStoreItem") {
                if (Test-Path -Path $item.FilePath) {
                    $connStoreItems = Import-Clixml -Path $item.FilePath
                    $connStoreItems = $connStoreItems | Where-Object {$_.ID -ne $item.ID}
                    $connStoreItems | Export-Clixml -Path $item.FilePath
                }
            } else {
                Write-Error -Message "Unsupported input type '$($item.Type)' encountered!" -TargetObject $item
            }
        }
    }
}
