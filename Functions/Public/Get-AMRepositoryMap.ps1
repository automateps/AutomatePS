function Get-AMRepositoryMap {
    <#
        .SYNOPSIS
            Retrieves server to server repository mappings

        .DESCRIPTION
            Get-AMRepositoryMap retrieves repository mappings between two servers to be supplied to Copy-AMWorkflow

        .PARAMETER SourceConnection
            The source server connection alias

        .PARAMETER DestinationConnection
            The destination server connection alias

        .PARAMETER FilePath
            The file path to retrieve repository mappings from, retrieved from the user profile by default

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMRepositoryMap.md

    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        $SourceConnection,

        [Parameter(Mandatory = $true)]
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

    $map = @{}
    foreach ($mapping in (Import-Csv -Path $FilePath)) {
        if ($mapping.SourceConnection -eq $SourceConnection -and $mapping.DestinationConnection -eq $DestinationConnection) {
            $map.Add($mapping.SourceID, $mapping.DestinationID)
        }
    }
    return $map
}