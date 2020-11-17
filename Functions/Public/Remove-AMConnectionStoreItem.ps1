function Remove-AMConnectionStoreItem {
    <#
        .SYNOPSIS
            Removes connection for the specified Automate server from the connection store.

        .DESCRIPTION
            Remove-AMConnectionStoreItem removes connection objects from the connection store file.

        .PARAMETER ConnectionStoreItem
            The connection store item to delete.

        .EXAMPLE
            Remove-AMConnectionStoreItem -Connection server01

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Remove-AMConnectionStoreItem.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $ConnectionStoreItem
    )

    PROCESS {
        foreach ($item in $ConnectionStoreItem) {
            if ($item.Type -eq "ConnectionStoreItem") {
                if (Test-Path -Path $item.FilePath) {
                    $connStoreItems = Import-Clixml -Path $item.FilePath
                    if (($connStoreItems | Where-Object {$_.ID -eq $item.ID} | Measure-Object).Count -gt 0) {
                        if ($PSCmdlet.ShouldProcess("Removing saved connection to $($item.Server):$($item.Port) for user $($item.Credential.UserName).")) {
                            $connStoreItems = $connStoreItems | Where-Object {$_.ID -ne $item.ID}
                            $connStoreItems | Export-Clixml -Path $item.FilePath
                        }
                    } else {
                        Write-Verbose "No saved connection found with ID $($item.ID)."
                    }
                }
            } else {
                Write-Error -Message "Unsupported input type '$($item.Type)' encountered!" -TargetObject $item
            }
        }
    }
}