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

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 02/01/2019
            Date Modified  : 02/06/2019

        .LINK
            https://github.com/davidseibel/AutoMatePS

    #>
    [CmdletBinding()]
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
        [string]$FilePath = "$($env:APPDATA)\AutoMatePS\repositorymap.csv"
    )

    $map = @{}
    foreach ($mapping in (Import-Csv -Path $FilePath)) {
        if ($mapping.SourceConnection -eq $SourceConnection -and $mapping.DestinationConnection -eq $DestinationConnection) {
            $map.Add($mapping.SourceID, $mapping.DestinationID)
        }
    }
    return $map
}