function Get-AMExecutionEvent {
    <#
        .SYNOPSIS
            Gets AutoMate Enterprise execution events.

        .DESCRIPTION
            Get-AMExecutionEvent gets execution events for workflows and tasks.

        .PARAMETER InputObject
            The object(s) to retrieve execution events for.

        .PARAMETER StartDate
            The first date of events to retrieve (Default: 1 hour ago).

        .PARAMETER EndDate
            The last date of events to retrieve (Default: now).

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
            The AutoMate Enterprise management server.

        .INPUTS
            Execution events for the following objects can be retrieved by this function:
            Workflow
            Task
            Condition
            Process
            TaskAgent
            ProcessAgent

        .OUTPUTS
            ExecutionEvent

        .EXAMPLE
            # Get events for workflow "My Workflow"
            Get-AMWorkflow "My Workflow" | Get-AMExecutionEvent

        .EXAMPLE
            # Get events using filter sets
            Get-AMExecutionEvent -Connection AMprd -FilterSet @{Property = 'ResultText'; Operator = 'contains'; Value = 'Agent01'}

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
        [DateTime]$StartDate = (Get-Date).AddHours(-1),

        [ValidateNotNullOrEmpty()]
        [DateTime]$EndDate = (Get-Date),

        [ValidateNotNull()]
        [Hashtable[]]$FilterSet = @(),

        [ValidateSet("And","Or")]
        [string]$FilterSetMode = "And",

        [ValidateNotNullOrEmpty()]
        [string[]]$SortProperty = @("StartDateTime","EndDateTime"),

        [ValidateNotNullOrEmpty()]
        [switch]$SortDescending = $false,

        [ValidateNotNullOrEmpty()]
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
                $splat += @{ Resource = Format-AMUri -Path "execution_events/get" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $FilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
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
                        {($_ -in @("Workflow","Task","Process","Condition","Agent"))} {
                            $tempFilterSet = $FilterSet + @{Property = "ConstructID"; Operator = "="; Value = $obj.ID}
                            $tempSplat += @{ Resource = Format-AMUri -Path "execution_events/get" -RangeStart $StartDate -RangeEnd $EndDate -FilterSet $tempFilterSet -FilterSetMode $FilterSetMode -SortProperty $SortProperty -SortDescending:$SortDescending.ToBool() }
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
        $SortProperty += "ConnectionAlias", "ID"
        return $result | Sort-Object $SortProperty -Unique -Descending:$SortDescending.ToBool()
    }
}
