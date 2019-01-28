function Invoke-AMFilterSet {
    <#
        .SYNOPSIS
            Filters any object using similar filter set logic provided by the API.

        .DESCRIPTION
            Invoke-AMFilterSet applies filter sets without calling the API.

        .PARAMETER InputObject
            The object(s) to filter.

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Operator, Value.
            Valid values for the Operator are: =, !=, <, >, contains (default - no need to supply Operator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .EXAMPLE
            # Filter non-API folder root objects
            Get-AMFolderRoot | Invoke-AMFilterSet -FilterSet @{Property = "Name"; Value = "Task"}

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 01/28/2019
            Date Modified  : 01/28/2019

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNull()]
        [Hashtable[]]$FilterSet = @(),

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And"
    )

    BEGIN {
        $scriptBlocks = @()
        foreach ($fs in $FilterSet) {
            $filterProperty = $null
            $filterOperator = $null
            $filterValue = $null
            # Get filter set parameters
            foreach ($key in $fs.Keys) {
                if ("Property" -like "$key*") { $filterProperty = $fs[$key] }
                elseif ("Comparator" -like "$key*" -or "Operator" -like "$key*") { $filterOperator = $fs[$key] }
                elseif ("Value" -like "$key*") { $filterValue = $fs[$key] }
            }
            # Validate filter set parameters
            if ($null -ne $filterProperty -and $null -ne $filterValue) {
                if (-not $filterOperator) { $filterOperator = "contains" }
            } else {
                throw "'Property' and 'Value' must be specified in the filter set hashtable!"
            }
            # Create script blocks for each filter set
            switch ($filterOperator) {
                "="        { $scriptBlocks += [ScriptBlock]::Create("`$obj.$filterProperty -eq '$filterValue'") }
                "!="       { $scriptBlocks += [ScriptBlock]::Create("`$obj.$filterProperty -ne '$filterValue'") }
                "<"        { $scriptBlocks += [ScriptBlock]::Create("`$obj.$filterProperty -lt '$filterValue'") }
                ">"        { $scriptBlocks += [ScriptBlock]::Create("`$obj.$filterProperty -gt '$filterValue'") }
                "contains" { $scriptBlocks += [ScriptBlock]::Create("`$obj.$filterProperty -like '*$filterValue*'") }
                default    { throw "Unsupported filter operator: $_!" }
            }
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            switch ($FilterSetMode) {
                "AND" {
                    $allMatch = $true
                    # Loop through script blocks and execute them, returns $true if matched
                    foreach ($scriptBlock in $scriptBlocks) {
                        if (-not (Invoke-Command -ScriptBlock $scriptBlock)) {
                            $allMatch = $false
                            break
                        }
                    }
                    if ($allMatch) {
                        $obj
                    }
                }
                "OR" {
                    foreach ($scriptBlock in $scriptBlocks) {
                        # Loop through script blocks and execute them, returns $true if matched
                        if (Invoke-Command -ScriptBlock $scriptBlock) {
                            $obj
                            break
                        }
                    }
                }
            }
        }
    }
}