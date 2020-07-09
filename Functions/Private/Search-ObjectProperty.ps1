function Search-ObjectProperty {
    <#
        .SYNOPSIS
            Searches PSCustomObject(s) for a specified search pattern, returning a list of matching properties.

        .DESCRIPTION
            Search-ObjectProperty searches PSCustomObject(s) for a specified search pattern, returning a list of matching properties.

        .PARAMETER InputObject
            The object(s) to search.

        .PARAMETER Pattern
            The pattern to use when searching.  Regular expressions are supported.

        .PARAMETER Depth
            The number of layers (sub-objects/properties) in every object to search.  Using a search depth that is too deep can significantly increase search time.

        .PARAMETER CurrentDepth
            Do not use.  This parameter is used internally when searching recursively to keep track of the current depth in the object.

        .PARAMETER ParentProperty
            Do not use.  This parameter is used internally when searching recursively to keep track of the full path to a matching property.

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [string]$Pattern,

        [switch]$Regex = $false,

        [ValidateScript({$_ -gt 0})]
        [int]$Depth = 3,

        [int]$CurrentDepth = 0,

        [ValidateNotNullOrEmpty()]
        [string]$ParentProperty = ""
    )
    BEGIN {
        $result = @()
        $index = 0
        if ($Regex.ToBool()) {
            try {
                [regex]::new($Pattern)
            } catch {
                throw "$Pattern is not a valid regular expression!"
            }
        } elseif ([System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Pattern)) {
            try   { "" -like $Pattern | Out-Null } # Test wildcard string
            catch { throw }                        # Throw error if wildcard invalid
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            $found = $false
            $matchedProps = @{}

            foreach ($property in ($obj | Get-Member -MemberType Property | Where-Object {$_.Name -notin "MatchedProperty"}).Name) {
                if ($ParentProperty -eq "") {
                    $propertyChain = ".$property"
                } else {
                    $propertyChain = "$ParentProperty[$index].$property"
                }
                if ($obj."$property" -is [System.Collections.IEnumerable] -and $obj."$property" -isnot [string]) {
                    if ($CurrentDepth -le $Depth) {
                        #Write-Verbose "Searching sub-object $ParentProperty.$property"
                        $subProperties = $obj."$property" | Search-ObjectProperty -Pattern $Pattern -ParentProperty $propertyChain -Regex:$Regex -Depth $Depth -CurrentDepth ($CurrentDepth + 1)
                        foreach ($subProperty in $subProperties) {
                            $matchedProps += $subProperty.MatchedProperty
                            $found = $true
                        }
                    }
                } else {
                    $matched = $false
                    if ($Regex.ToBool()) {
                        $matched = $obj."$property" -match $Pattern
                    } else {
                        $matched = $obj."$property" -like $Pattern
                    }
                    if ($matched) {
                        Write-Verbose "Found '$Pattern' in $propertyChain"
                        $matchedProps.Add("$propertyChain", $obj."$property") | Out-Null
                        $found = $true
                    }
                }
            }
            if ($found) {
                if ($null -eq ($obj | Get-Member -Name "MatchedProperty")) {
                    $obj | Add-Member -NotePropertyName "MatchedProperty" -NotePropertyValue $matchedProps
                } else {
                    $obj.MatchedProperty = $matchedProps
                }
                $result += $obj
            }
            $index += 1
        }
    }

    END {
        return $result
    }
}
