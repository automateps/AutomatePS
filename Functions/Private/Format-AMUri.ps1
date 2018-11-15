function Format-AMUri {
    <#
        .SYNOPSIS
            Creates a formatted filter set with sort options.

        .DESCRIPTION
            Format-AMUri takes an array of hashtables and formats them into a filter set for the API.

        .PARAMETER Path
            The root URI to build the query from.

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Operator, Value (these properties can be shorthanded by specifying P, C or V).
            Valid values for the Operator are: =, !=, <, >, contains (default - no need to supply Operator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .PARAMETER RangeStart
            The time of the earliest desired record. Applicable only when querying audit events, execution events, instances, metrics and the calendar.

        .PARAMETER RangeEnd
            The time of the latest desired record. Applicable only when querying audit events, execution events, instances, metrics and the calendar.

        .PARAMETER FolderID
            The ID of the folder containing the desired objects.

        .PARAMETER IncludeRelativeInstances
            Returns any additional instances related to the query.

        .PARAMETER CalendarType
            The type of schedule triggers to report on when querying the calendar.

        .PARAMETER Parameters
            Any additional parameters.

        .PARAMETER SortProperty
            The object property to sort results on.  Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

        .PARAMETER SortDescending
            If specified, this will sort the output on the specified SortProperty in descending order.  Otherwise, ascending order is assumed.

        .EXAMPLE
            Format-AMUri -FilterSet @{Property = "Enabled"; Operator = "="; Value = "true"} -SortProperty "Name"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Hashtable[]]$FilterSet,

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And",

        [DateTime]$RangeStart,

        [DateTime]$RangeEnd,

        [string]$FolderID,

        [ValidateNotNullOrEmpty()]
        [switch]$IncludeRelativeInstances = $false,

        [ValidateSet("Specific","Weekly","Monthly","Holidays","Non-interval",$null)]
        [string]$CalendarType,

        [string[]]$Parameters,

        [ValidateNotNullOrEmpty()]
        [string[]]$SortProperty,

        [switch]$SortDescending = $false
    )

    switch ($FilterSetMode) {
        "And" {$operator = "&&"}
        "Or"  {$operator = "||"}
    }

    $filterStrings = @()
    foreach ($fs in $FilterSet) {
        $filterProperty = $null
        $filterOperator = $null
        $filterValue = $null
        foreach ($key in $fs.Keys) {
            if ("Property" -like "$key*") { $filterProperty = $fs[$key] }
            elseif ("Comparator" -like "$key*" -or "Operator" -like "$key*") { $filterOperator = $fs[$key] }
            elseif ("Value" -like "$key*") { $filterValue = $fs[$key] }
        }
        if ($null -ne $filterProperty -and $null -ne $filterValue) {
            if ($filterValue -is [DateTime]) { $filterValue = $filterValue.ToUniversalTime() }
            if (-not $filterOperator) { $filterOperator = "contains" }
            $filterStrings += '"' + $filterProperty + '","' + $filterOperator + '","\"' + [uri]::EscapeDataString($filterValue) + '\""'
        } else {
            throw "'Property' and 'Value' must be specified in the filter set hashtable!"
        }
    }
    if (($filterStrings | Measure-Object).Count -gt 0) {
        $Parameters += ("filter_sets=$($filterStrings -join [uri]::EscapeDataString($operator))")
    }
    if ($PSBoundParameters.ContainsKey("RangeStart")) {
        $Parameters += "range_start=$($RangeStart.ToUniversalTime())"
    }
    if ($PSBoundParameters.ContainsKey("RangeEnd")) {
        $Parameters += "range_end=$($RangeEnd.ToUniversalTime())"
    }
    if ($PSBoundParameters.ContainsKey("FolderID")) {
        $Parameters += "folder_id=$FolderID"
    }
    if ($PSBoundParameters.ContainsKey("CalendarType") -and (-not [string]::IsNullOrEmpty($CalendarType))) {
        $Parameters += "type=$Type"
    }
    if ($IncludeRelativeInstances.ToBool()) {
        $Parameters += "include_relatives=true"
    }
    if ($PSBoundParameters.ContainsKey("SortProperty")) {
        $Parameters += "sort_field=$($SortProperty[0])"
        if ($SortDescending.ToBool()) { $Parameters += "sort_order=DSC" }
    }
    $index = 0
    foreach ($parameter in $Parameters | Where-Object {-not [string]::IsNullOrEmpty($_)}) {
        if ($index -eq 0) { $Path += "?" }
        else              { $Path += "&" }
        $Path += $parameter
        $index++
    }
    return $Path
}
