function Compare-AMCondition {
    <#
        .SYNOPSIS
            Compares two conditions.

        .DESCRIPTION
            Compare-AMCondition compares two conditions and displays the differences.

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
    # Only compare properties that define the configuration of the condition.
    $excludedProperties = @("__type","ID","ParentID","Path","CreatedBy","CreatedOn","EndedOn","ExclusionSchedules","LockedBy","ModifiedOn","ResultCode","ResultText","StartedOn","Version","VersionDate","LastLaunchDate","ConnectionAlias","CreatedByUser","LockedByUser")
    # Compare properties
    foreach ($property in ($ReferenceObject.PSObject.Properties | Where-Object {$_.Name -notin $excludedProperties})) {
        switch ($ReferenceObject.($property.Name).GetType()) {
            {$_.IsPrimitive -or $_.Name -eq "String" -or $_.BaseType.Name -eq "Enum"} {
                Write-Verbose "$($property.Name) is a basic type."
                if ($ReferenceObject.($property.Name) -ne $DifferenceObject.($property.Name) -and -not $ExcludeDifferent.IsPresent) {
                    $result += [AMComparison]::new($ReferenceObject, $DifferenceObject, $property.Name, [AMComparisonResult]::NotEqual)
                } elseif ($IncludeEqual.IsPresent) {
                    $result += [AMComparison]::new($ReferenceObject, $DifferenceObject, $property.Name, [AMComparisonResult]::Equal)
                }
            }
            {$_.IsArray -or $_.Name -eq "ArrayList"} {
                Write-Verbose "$($property.Name) is an array type."
                $arrayCompare = Compare-Object -ReferenceObject $ReferenceObject.($property.Name) -DifferenceObject $DifferenceObject.($property.Name) -PassThru
                if (($arrayCompare | Measure-Object).Count -gt 0) {
                    $result += [AMComparison]::new($ReferenceObject, $DifferenceObject, $property.Name, [AMComparisonResult]::Equal)
                }
            }
            default {
                Write-Warning "$($property.Name) is an unhandled type."
            }
        }
    }
    return $result
}