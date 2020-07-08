function Compare-AMWorkflow {
    <#
        .SYNOPSIS
            Compares two workflows.

        .DESCRIPTION
            Compare-AMWorkflow compares two workflows and displays the differences.

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
    # Only compare properties that define the configuration of the workflow.
    $baseProperties = @("CompletionState","Empty","Enabled","Name","Notes","Reactive","Removed","Scheduled","Type")
    $itemProperties = @("AgentID","ConstructID","ConsructType","Enabled")
    $linkProperties = @("DestinationID","LinkType","ResultType","SourceID","Value")
    $triggerProperties = @("AgentID","ConstructID","ConsructType","Enabled")
    $variableProperties = @("DataType","InitalValue","Parameter","Private","VariableType")
    # Compare base properties
    foreach ($property in $baseProperties) {
        if ($ReferenceObject.$property -ne $DifferenceObject.$property -and -not $ExcludeDifferent.IsPresent) {
            $result += [AMComparison]::new($ReferenceObject, $DifferenceObject, $property, [AMComparisonResult]::NotEqual)
        } elseif ($IncludeEqual.IsPresent) {
            $result += [AMComparison]::new($ReferenceObject, $DifferenceObject, $property, [AMComparisonResult]::Equal)
        }
    }
    # Compare Items
    foreach ($referenceItem in $ReferenceObject.Items) {
        $foundMatch = $false
        $differenceItem = $DifferenceObject.Items | Where-Object {$_.ID -eq $referenceItem.ID}
        if (($differenceItem | Measure-Object).Count -eq 1) {
            $foundMatch = $true
        } else {
            $differenceItem = $DifferenceObject.Items | Where-Object {$_.ConstructID -eq $referenceItem.ConstructID}
            if (($differenceItem | Measure-Object).Count -eq 1) {
                $foundMatch = $true
            }
        }
        if ($foundMatch) {
            foreach ($property in $itemProperties) {
                if ($referenceItem.$property -ne $differenceItem.$property -and -not $ExcludeDifferent.IsPresent) {
                    $result += [AMComparison]::new($referenceItem, $differenceItem, $property, [AMComparisonResult]::NotEqual)
                } elseif ($IncludeEqual.IsPresent) {
                    $result += [AMComparison]::new($referenceItem, $differenceItem, $property, [AMComparisonResult]::Equal)
                }
            }
        } else {
            $result += [AMComparison]::new($referenceItem, $null, "Items", [AMComparisonResult]::MissingFromDifferenceObject)
        }
    }
    foreach ($differenceItem in $DifferenceObject.Items) {
        $foundMatch = $false
        $referenceItem = $ReferenceObject.Items | Where-Object {$_.ID -eq $differenceItem.ID}
        if (($referenceItem | Measure-Object).Count -eq 1) {
            $foundMatch = $true
        } else {
            $referenceItem = $ReferenceObject.Items | Where-Object {$_.ConstructID -eq $differenceItem.ConstructID}
            if (($referenceItem | Measure-Object).Count -eq 1) {
                $foundMatch = $true
            }
        }
        if (-not $foundMatch) {
            $result += [AMComparison]::new($null, $differenceItem, "Items", [AMComparisonResult]::MissingFromReferenceObject)
        }
    }
    # Compare Links
    foreach ($referenceLink in $ReferenceObject.Links) {
        $foundMatch = $false
        $differenceLink = $DifferenceObject.Links | Where-Object {$_.ID -eq $referenceLink.ID}
        if (($differenceLink | Measure-Object).Count -eq 1) {
            $foundMatch = $true
        } else {
            $differenceLink = $DifferenceObject.Links | Where-Object {$_.SourceID -eq $referenceLink.SourceID -and $_.DestinationID -eq $referenceLink.DestinationID -and $_.LinkType -eq $referenceLink.LinkType}
            if (($differenceLink | Measure-Object).Count -eq 1) {
                $foundMatch = $true
            }
        }
        if ($foundMatch) {
            foreach ($property in $linkProperties) {
                if ($referenceLink.$property -ne $differenceLink.$property -and -not $ExcludeDifferent.IsPresent) {
                    $result += [AMComparison]::new($referenceLink, $differenceLink, $property, [AMComparisonResult]::NotEqual)
                } elseif ($IncludeEqual.IsPresent) {
                    $result += [AMComparison]::new($referenceLink, $differenceLink, $property, [AMComparisonResult]::Equal)
                }
            }
        } else {
            $result += [AMComparison]::new($referenceLink, $null, "Links", [AMComparisonResult]::MissingFromDifferenceObject)
        }
    }
    foreach ($differenceLink in $DifferenceObject.Links) {
        $foundMatch = $false
        $referenceLink = $ReferenceObject.Links | Where-Object {$_.ID -eq $differenceLink.ID}
        if (($referenceLink | Measure-Object).Count -eq 1) {
            $foundMatch = $true
        } else {
            $referenceLink = $ReferenceObject.Links | Where-Object {$_.SourceID -eq $differenceLink.SourceID -and $_.DestinationID -eq $differenceLink.DestinationID -and $_.LinkType -eq $differenceLink.LinkType}
            if (($referenceLink | Measure-Object).Count -eq 1) {
                $foundMatch = $true
            }
        }
        if (-not $foundMatch) {
            $result += [AMComparison]::new($null, $differenceLink, "Links", [AMComparisonResult]::MissingFromReferenceObject)
        }
    }

    # Compare Triggers
    foreach ($referenceTrigger in $ReferenceObject.Triggers) {
        $foundMatch = $false
        $differenceTrigger = $DifferenceObject.Triggers | Where-Object {$_.ID -eq $referenceTrigger.ID}
        if (($differenceTrigger | Measure-Object).Count -eq 1) {
            $foundMatch = $true
        } else {
            $differenceTrigger = $DifferenceObject.Triggers | Where-Object {$_.ConstructID -eq $referenceTrigger.ConstructID}
            if (($differenceTrigger | Measure-Object).Count -eq 1) {
                $foundMatch = $true
            }
        }
        if ($foundMatch) {
            foreach ($property in $triggerProperties) {
                if ($referenceTrigger.$property -ne $differenceTrigger.$property -and -not $ExcludeDifferent.IsPresent) {
                    $result += [AMComparison]::new($referenceTrigger, $differenceTrigger, $property, [AMComparisonResult]::NotEqual)
                } elseif ($IncludeEqual.IsPresent) {
                    $result += [AMComparison]::new($referenceTrigger, $differenceTrigger, $property, [AMComparisonResult]::Equal)
                }
            }
        } else {
            $result += [AMComparison]::new($referenceTrigger, $null, "Triggers", [AMComparisonResult]::MissingFromDifferenceObject)
        }
    }
    foreach ($differenceTrigger in $DifferenceObject.Triggers) {
        $foundMatch = $false
        $referenceTrigger = $ReferenceObject.Triggers | Where-Object {$_.ID -eq $differenceTrigger.ID}
        if (($referenceTrigger | Measure-Object).Count -eq 1) {
            $foundMatch = $true
        } else {
            $referenceTrigger = $ReferenceObject.Triggers | Where-Object {$_.ConstructID -eq $differenceTrigger.ConstructID}
            if (($differenceTrigger | Measure-Object).Count -eq 1) {
                $foundMatch = $true
            }
        }
        if (-not $foundMatch) {
            $result += [AMComparison]::new($null, $differenceTrigger, "Triggers", [AMComparisonResult]::MissingFromReferenceObject)
        }
    }

    # Compare Variables
    foreach ($referenceVariable in $ReferenceObject.Variables) {
        $foundMatch = $false
        $differenceVariable = $DifferenceObject.Variables | Where-Object {$_.ID -eq $referenceVariable.ID}
        if (($differenceVariable | Measure-Object).Count -eq 1) {
            $foundMatch = $true
        } else {
            $differenceVariable = $DifferenceObject.Variables | Where-Object {$_.Name -eq $referenceVariable.Name}
            if (($differenceVariable | Measure-Object).Count -eq 1) {
                $foundMatch = $true
            }
        }
        if ($foundMatch) {
            foreach ($property in $variableProperties) {
                if ($referenceVariable.$property -ne $differenceVariable.$property -and -not $ExcludeDifferent.IsPresent) {
                    $result += [AMComparison]::new($referenceVariable, $differenceVariable, $property, [AMComparisonResult]::NotEqual)
                } elseif ($IncludeEqual.IsPresent) {
                    $result += [AMComparison]::new($referenceVariable, $differenceVariable, $property, [AMComparisonResult]::Equal)
                }
            }
        } else {
            $result += [AMComparison]::new($referenceVariable, $null, "Variables", [AMComparisonResult]::MissingFromDifferenceObject)
        }
    }
    foreach ($differenceVariable in $DifferenceObject.Variables) {
        $foundMatch = $true
        $referenceVariable = $ReferenceObject.Variables | Where-Object {$_.ID -eq $differenceVariable.ID}
        if (($referenceVariable | Measure-Object).Count -eq 1) {
            $foundMatch = $true
        } else {
            $referenceVariable = $ReferenceObject.Variables | Where-Object {$_.Name -eq $differenceVariable.Name}
            if (($referenceVariable | Measure-Object).Count -eq 1) {
                $foundMatch = $true
            }
        }
        if (-not $foundMatch) {
            $result += [AMComparison]::new($null, $differenceVariable, "Variables", [AMComparisonResult]::MissingFromReferenceObject)
        }
    }
    return $result
}