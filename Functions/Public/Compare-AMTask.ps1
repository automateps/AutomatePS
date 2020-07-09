function Compare-AMTask {
    <#
        .SYNOPSIS
            Compares two tasks.

        .DESCRIPTION
            Compare-AMTask compares two tasks and displays the differences.

        .PARAMETER ReferenceObject
            The first object to compare.

        .PARAMETER DifferenceObject
            The second object to compare.

        .PARAMETER ExcludeDifferent
            Exclude differences from the output.

        .PARAMETER IncludeEqual
            Include equal items in the input.

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    param (
        $ReferenceObject,

        $DifferenceObject,

        [switch]$ExcludeDifferent = $false,

        [switch]$IncludeEqual = $false
    )
    $result = @()
    # Only compare properties that define the configuration of the task.
    $baseProperties = @("AML","CompletionState","Empty","Enabled","Name","Notes","Removed","Type")
    # Compare base properties
    foreach ($property in $baseProperties) {
        if ($ReferenceObject.$property -ne $DifferenceObject.$property -and -not $ExcludeDifferent.IsPresent) {
            $result += [AMComparison]::new($ReferenceObject, $DifferenceObject, $property, [AMComparisonResult]::NotEqual)
        } elseif ($IncludeEqual.IsPresent) {
            $result += [AMComparison]::new($ReferenceObject, $DifferenceObject, $property, [AMComparisonResult]::Equal)
        }
    }
    return $result
}