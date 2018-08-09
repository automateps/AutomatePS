function Get-AMObject {
    <#
        .SYNOPSIS
            Retrieves any AutoMate Enterprise object by ID.

        .DESCRIPTION
            Get-AMObject allows search for any AutoMate Enterprise object by its ID when the construct type is not known.

        .PARAMETER ID
            The ID to search for.

        .PARAMETER Types
            The construct types to search, all are searched by default.

        .PARAMETER Connection
            The server to search.

        .EXAMPLE
            Get-AMObject -ID "{1525ea3b-45cc-4ee1-9b34-8ea855c3b299}"

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
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $ID,

        [ValidateNotNullOrEmpty()]
        [AMConstructType[]]$Types = @([AMConstructType]::Workflow, `
                                       [AMConstructType]::Task, `
                                       [AMConstructType]::Process, `
                                       [AMConstructType]::Condition, `
                                       [AMConstructType]::Agent, `
                                       [AMConstructType]::AgentGroup, `
                                       [AMConstructType]::User, `
                                       [AMConstructType]::UserGroup, `
                                       [AMConstructType]::Folder
                                      ),

        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }

    if ($null -eq $Connection) {
        throw "Invalid connection specified!"
    }

    $filterSet = @{Property = "ID"; Comparator = "="; Value = $ID}
    foreach ($type in $Types) {
        foreach ($c in $Connection) {
            $resource = Format-AMUri -Path "$(([AMTypeDictionary]::($type)).RestResource)/index" -FilterSet $filterSet
            if (Invoke-AMRestMethod -Resource $resource -Connection $c) {
                Invoke-AMRestMethod -Resource "$(([AMTypeDictionary]::($type)).RestResource)/$ID/get" -Connection $c
            }
        }
    }
}
