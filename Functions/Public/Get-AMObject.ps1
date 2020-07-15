function Get-AMObject {
    <#
        .SYNOPSIS
            Retrieves any Automate object by ID.

        .DESCRIPTION
            Get-AMObject allows search for any Automate object by its ID when the construct type is not known.

        .PARAMETER ID
            The ID to search for.

        .PARAMETER Types
            The construct types to search, all are searched by default.

        .PARAMETER Connection
            The server to search.

        .EXAMPLE
            Get-AMObject -ID "{1525ea3b-45cc-4ee1-9b34-8ea855c3b299}"

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Get-AMObject.md
    #>
    [CmdletBinding()]
    [OutputType([AMAutomationConstructv10],[AMAutomationConstructv11])]
    param (
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

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
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

    $filterSet = @{Property = "ID"; Operator = "="; Value = $ID}
    foreach ($type in $Types) {
        foreach ($c in $Connection) {
            if ($type -eq "SystemAgent") {
                Get-AMSystemAgent -ID $ID -Connection $c
            } else {
                $resource = Format-AMUri -Path "$(([AMTypeDictionary]::($type)).RestResource)/index" -FilterSet $filterSet
                if (Invoke-AMRestMethod -Resource $resource -Connection $c) {
                    Invoke-AMRestMethod -Resource "$(([AMTypeDictionary]::($type)).RestResource)/$ID/get" -Connection $c
                }
            }
        }
    }
}
