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

        .EXAMPLE

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
        [Parameter(ValueFromPipeline = $true)]
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
            $matchedProps = @()

            foreach ($property in ($obj | Get-Member -MemberType Property | Where-Object {$_.Name -notin "__type","MatchedProperty"}).Name) {
                if ($obj."$property" -isnot [string]) {
                    if ($CurrentDepth -le $Depth) {
                        Write-Verbose "Searching sub-object $ParentProperty.$property"
                        $subProperties = $obj."$property" | Search-ObjectProperty -Pattern $Pattern -ParentProperty "$ParentProperty.$property" -Regex:$Regex -Depth $Depth -CurrentDepth ($CurrentDepth + 1)
                        if ($subProperties) {
                            $matchedProps += $subProperties.MatchedProperty
                            $found = $true
                        }
                    }
                } else {
                    if ($Regex.ToBool()) {
                        if ($obj."$property" -match $Pattern) {
                            Write-Verbose "Found '$Pattern' in $ParentProperty.$property"
                            $matchedProps += [AMMatchedProperty]::new("$ParentProperty.$property", $obj."$property")
                            $found = $true
                        }
                    } else {
                        if ($obj."$property" -like $Pattern) {
                            Write-Verbose "Found '$Pattern' in $ParentProperty.$property"
                            $matchedProps += [AMMatchedProperty]::new("$ParentProperty.$property", $obj."$property")
                            $found = $true
                        }
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
        }
    }

    END {
        return $result
    }
}
