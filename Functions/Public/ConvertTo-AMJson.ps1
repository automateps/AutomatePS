function ConvertTo-AMJson {
<#
    .SYNOPSIS
        Converts Automate objects to JSON.

    .DESCRIPTION
        ConvertTo-AMJson converts Automate objects to JSON.  In PowerShell versions 6 and above, special handling is required to properly serialize date objects.

    .PARAMETER InputObject
        The object to serialize to JSON.

    .PARAMETER Depth
        Specifies how many levels of contained objects are included in the JSON representation.

    .PARAMETER Compress
        Omits white space and indented formatting in the output string.

    .LINK
        https://github.com/AutomatePS/AutomatePS/blob/master/Docs/ConvertTo-AMJson.md
#>
    [CmdletBinding()]
    param (
        $InputObject,

        [int]$Depth = 1024,

        [switch]$Compress
    )

    switch ($PSVersionTable.PSVersion.Major) {
        {$_ -le 5} {
            ConvertTo-Json -InputObject $InputObject -Depth $Depth -Compress:$Compress
        }
        default {
            $jsonSettings = [Newtonsoft.Json.JsonSerializerSettings]::new()

            # Serialize with Microsoft's date format, for example: \/Date(1582571197098)\/.
            # If we didn't do this, it would use ISO 8601 format: 2020-02-24T14:07:34.7419315-05:00, which the Automate REST API does not accept
            $jsonSettings.DateFormatHandling = [Newtonsoft.Json.DateFormatHandling]::MicrosoftDateFormat

            $jsonSettings.MaxDepth = $Depth
            if (-not $Compress.IsPresent) {
                $jsonSettings.Formatting = [Newtonsoft.Json.Formatting]::Indented
            }
            [Newtonsoft.Json.JsonConvert]::SerializeObject($InputObject, $jsonSettings)
        }
    }
}