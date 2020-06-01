function Import-AMHoliday {
    <#
        .SYNOPSIS
            Read the holidays.aho file into a dictionary.

        .DESCRIPTION
            This function reads in the holidays.aho file and returns a dictionary object.

        .PARAMETER Path
            Path to holidays.aho file

        .EXAMPLE
            Import-AMHoliday -Path "C:\ProgramData\AutoMate\Automate Enterprise 11\Holidays.aho"

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            if (Test-Path -Path $_) {
                $true
            } else {
                throw [System.Management.Automation.PSArgumentException]"Path '$_' does not exist!"
            }
        })]
        [string]$Path
    )

    $result = @{}
    switch -Regex -File $Path {
        "^\[(.+)\]" { # Category
            $section = $matches[1]
            $result[$section] = @()
        }
        "(.+?)\s*,(.*)" { # Holiday
            $name,$value = $matches[1..2]
            if ($value -like "*,*") {
                $value,$calendarType = $value.Split(",")
            } else {
                $calendarType = [AMCalendarType]::Gregorian
            }
            $result[$section] += [PSCustomObject]@{
                Name = $name
                Date = $value
                CalendarType = [AMCalendarType]$calendarType
            }
        }
    }
    return $result
}
