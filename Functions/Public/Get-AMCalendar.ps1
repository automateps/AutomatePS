function Get-AMCalendar {
    <#
        .SYNOPSIS
            Gets Automate calendar events.

        .DESCRIPTION
            Get-AMCalendar gets events from the calendar.

        .PARAMETER InputObject
            The object(s) to search the calendar for.

        .PARAMETER StartDate
            The first date of events to retrieve (Default: now - must be equal or greater than the current time).

        .PARAMETER EndDate
            The last date of events to retrieve (Default: 24 hours from now).

        .PARAMETER Type
            The schedule types to retrieve:
            Specific     - The schedule defines specific dates and times.
            Weekly       - The schedule reoccurs on a weekly basis.
            Monthly      - The schedule reoccurs on a monthly basis.
            Holidays     - The schedule occurs on a holiday.
            Non-Interval - ???

        .PARAMETER FilterSet
            The parameters to filter the search on.  Supply hashtable(s) with the following properties: Property, Operator, Value.
            Valid values for the Operator are: =, !=, <, >, contains (default - no need to supply Operator when using 'contains')

        .PARAMETER FilterSetMode
            If multiple filter sets are provided, FilterSetMode determines if the filter sets should be evaluated with an AND or an OR

        .PARAMETER SortProperty
            The object property to sort results on.  Do not use ConnectionAlias, since it is a custom property added by this module, and not exposed in the API.

        .PARAMETER SortDescending
            If specified, this will sort the output on the specified SortProperty in descending order.  Otherwise, ascending order is assumed.

        .PARAMETER Connection
            The Automate management server.

        .INPUTS
            Calendar events related to the following objects can be retrieved by this function:
            Workflow
            Condition
            Folder

        .OUTPUTS
            Calendar

        .EXAMPLE
            # Get calendar events for the next 7 days
            Get-AMCalendar -EndDate (Get-Date).AddDays(7)

        .EXAMPLE
            # Get calendar events for workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Get-AMCalendar

        .EXAMPLE
            # Get calendar events using filter sets
            Get-AMCalendar -FilterSet @{Property = 'ScheduleDescription'; Operator = 'contains'; Value = 'hour(s)'}

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Position = 0, ParameterSetName = "ByPipeline", ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [DateTime]$StartDate = (Get-Date),

        [ValidateNotNullOrEmpty()]
        [DateTime]$EndDate = (Get-Date).AddDays(1),

        [ValidateSet("Specific","Weekly","Monthly","Holidays","Non-interval")]
        [string]$Type,

        [ValidateNotNull()]
        [Hashtable[]]$FilterSet = @(),

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And",

        [ValidateNotNullOrEmpty()]
        [string[]]$SortProperty = "NextRunTime",

        [ValidateNotNullOrEmpty()]
        [switch]$SortDescending = $false,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    BEGIN {
        if ($StartDate -gt $EndDate) {
            throw "StartDate must be before EndDate!"
        }
        $splat = @{
            RestMethod = "Get"
        }
        if ($PSBoundParameters.ContainsKey("Connection")) {
            $Connection = Get-AMConnection -Connection $Connection
            $splat.Add("Connection",$Connection)
        }
        $result = @()
    }

    PROCESS {
        switch($PSCmdlet.ParameterSetName) {
            "All" {
                $splat += @{ Resource = Format-AMUri -Path "calendar/list" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $FilterSet -FilterSetMode $FilterSetMode -CalendarType $Type -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                $result = Invoke-AMRestMethod @splat
            }
            "ByPipeline" {
                foreach ($obj in $InputObject) {
                    $tempSplat = $splat
                    if (-not $tempSplat.ContainsKey("Connection")) {
                        $tempSplat += @{ Connection = $obj.ConnectionAlias }
                    } else {
                        $tempSplat["Connection"] = $obj.ConnectionAlias
                    }
                    Write-Verbose "Processing $($obj.Type) '$($obj.Name)'"
                    switch ($obj.Type) {
                        "Workflow" {
                            $tempFilterSet = $FilterSet + @{Property = "WorkflowID"; Operator = "="; Value = $obj.ID}
                            $tempSplat += @{ Resource = Format-AMUri -Path "calendar/list" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -CalendarType $Type -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                            $result += Invoke-AMRestMethod @tempSplat
                        }
                        "Condition" {
                            $tempFilterSet = $FilterSet + @{Property = "ScheduleID"; Operator = "="; Value = $obj.ID}
                            $tempSplat += @{ Resource = Format-AMUri -Path "calendar/list" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -CalendarType $Type -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                            $result += Invoke-AMRestMethod @tempSplat
                        }
                        "Folder" {
                            $tempSplat += @{ Resource = Format-AMUri -Path "calendar/list" -RangeStart $StartDate -RangeEnd $EndDate -FolderID $obj.ID -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -CalendarType $Type -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
                            $result += Invoke-AMRestMethod @tempSplat
                        }
                        default {
                            $unsupportedType = $obj.GetType().FullName
                            if ($_) {
                                $unsupportedType = $_
                            } elseif (-not [string]::IsNullOrEmpty($obj.Type)) {
                                $unsupportedType = $obj.Type
                            }
                            Write-Error -Message "Unsupported input type '$unsupportedType' encountered!" -TargetObject $obj
                        }
                    }
                }
            }
        }
    }

    END {
        $result | Foreach-Object {$_.PSObject.TypeNames.Insert(0,"AMCalendar")}
        $SortProperty += "ConnectionAlias", "ID"
        return $result | Sort-Object $SortProperty -Unique -Descending:$SortDescending.ToBool()
    }
}
