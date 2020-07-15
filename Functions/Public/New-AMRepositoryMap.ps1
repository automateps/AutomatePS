function New-AMRepositoryMap {
    <#
        .SYNOPSIS
            Creates server to server repository mappings

        .DESCRIPTION
            New-AMRepositoryMap creates repository mappings between two servers to be supplied to Copy-AMWorkflow.

        .PARAMETER SourceObject
            The source object to map

        .PARAMETER DestinationObject
            The destination object to map

        .PARAMETER CreateReverseMapping
            Also create the reverse mapping from destination server to source server

        .PARAMETER FilePath
            The file path to save repository mappings in, saved in the user profile by default

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMRepositoryMap.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        $SourceObject,

        $DestinationObject,

        [switch]$CreateReverseMapping = $false,

        [string]$FilePath = "$($env:APPDATA)\AutomatePS\repositorymap.csv"
    )

    $mappingAdded = $false
    $map = @()
    if (Test-Path -Path $FilePath) {
        $map += Import-Csv -Path $FilePath
    } else {
        if (-not (Test-Path -Path (Split-Path -Path $FilePath -Parent))) {
            New-Item -Path (Split-Path -Path $FilePath -Parent) -ItemType Directory -Force | Out-Null
        }
    }
    if ($SourceObject.Type -eq $DestinationObject.Type) {
        $existingMapping = $map | Where-Object {$_.SourceID -eq $SourceObject.ID -and $_.SourceConnection -eq $SourceObject.ConnectionAlias -and $_.DestinationConnection -eq $DestinationObject.ConnectionAlias}
        if (($existingMapping | Measure-Object).Count -eq 0) {
            if ($PSCmdlet.ShouldProcess("Creating repository mapping for $($SourceObject.Type) '$($SourceObject.Name)' from connection '$($SourceObject.ConnectionAlias)' to '$($DestinationObject.ConnectionAlias)'!")) {
                $map += [AMRepositoryMapDetail]::new($SourceObject, $DestinationObject)
                $mappingAdded = $true
            }
        } else {
            Write-Warning "A mapping already exists for $($SourceObject.Type) '$($SourceObject.Name)' from connection '$($SourceObject.ConnectionAlias)' to '$($DestinationObject.ConnectionAlias)'!"
        }
        if ($mappingAdded) {
            $map | Export-Csv -Path $FilePath -NoTypeInformation
        }
        if ($CreateReverseMapping.IsPresent) {
            New-AMRepositoryMap -SourceObject $DestinationObject -DestinationObject $SourceObject -CreateReverseMapping:$false
        }
    } else {
        throw "SourceObject and DestinationObject must be of the same type!"
    }
}