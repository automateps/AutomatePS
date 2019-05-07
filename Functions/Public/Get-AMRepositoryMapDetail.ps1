function Get-AMRepositoryMapDetail {
    <#
        .SYNOPSIS
            Retrieves information about server to server repository mappings

        .DESCRIPTION
            Get-AMRepositoryMapDetail retrieves information about repository mappings between two servers to be supplied to Copy-AMWorkflow

        .PARAMETER SourceConnection
            The source server connection alias

        .PARAMETER DestinationConnection
            The destination server connection alias

        .PARAMETER FilePath
            The file path to retrieve repository mappings from, retrieved from the user profile by default

        .LINK
            https://github.com/AutomatePS/AutomatePS

    #>
    [CmdletBinding()]
    param (
        $SourceConnection,

        $DestinationConnection,

        [ValidateScript({
            if (Test-Path -Path $_) {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"FilePath '$_' does not exist!"
            }
        })]
        [string]$FilePath = "$($env:APPDATA)\AutomatePS\repositorymap.csv"
    )

    $mappings = Import-Csv -Path $FilePath
    foreach ($mapping in $mappings) {
        $filtered = $false
        if ($PSBoundParameters.ContainsKey("SourceConnection") -and $mapping.SourceConnection -ne $SourceConnection) {
            $filtered = $true
        }
        if ($PSBoundParameters.ContainsKey("DestinationConnection") -and $mapping.DestinationConnection -ne $DestinationConnection) {
            $filtered = $true
        }
        if (-not $filtered) {
            [AMRepositoryMapDetail]::new($mapping)
        }
    }
}