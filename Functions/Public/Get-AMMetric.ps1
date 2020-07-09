function Get-AMMetric {
    <#
        .SYNOPSIS
            Gets metrics from Automate.

        .DESCRIPTION
            Get-AMMetric gets metrics from Automate.

        .PARAMETER Type
            The type of metrics to query: Running, Completed, Queued, Deviations.

        .PARAMETER Folder
            The folder containing objects to retrieve metrics for.

        .PARAMETER StartDate
            The first date of metrics to retrieve (Default: 1 day ago).

        .PARAMETER EndDate
            The last date of metrics to retrieve (Default: now).

        .PARAMETER IntervalSeconds
            The interval to use for Running, Queued and Completed metrics.

        .PARAMETER DeviationPercentage
            The deviation percentage when querying deviation metrics.

        .PARAMETER DeviationDirection
            The deviation direction when querying deviation metrics.

        .PARAMETER Connection
            The Automate management server.

        .INPUTS
            Folder

        .OUTPUTS
            Metrics

        .EXAMPLE
            # Get completed metrics over a 24 hour interval for the past week
            Get-AMMetric -Type Completed -Interval 86400 -StartDate (Get-Date).AddDays(-7)

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    param (
        [ValidateSet("Running","Completed","Queued","Deviations")]
        $Type = "Running",

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        [DateTime]$StartDate = (Get-Date).AddDays(-1),

        [ValidateNotNullOrEmpty()]
        [DateTime]$EndDate = (Get-Date),

        [ValidateNotNullOrEmpty()]
        [int]$IntervalSeconds = 3600,

        [ValidateNotNullOrEmpty()]
        [int]$DeviationPercentage,

        [ValidateSet("ABOVE","BELOW","BOTH")]
        [string]$DeviationDirection,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )
    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }

    $parameters = @()
    $parameters += "interval_size=$IntervalSeconds"
    if ($PSBoundParameters.ContainsKey("Folder")) { $parameters += "folder_id=$($Folder.ID)"}
    switch ($Type) {
        "Running" {
            $path = "metrics/run/list"
        }
        "Completed" {
            $path = "metrics/completed/list"
        }
        "Queued" {
            $path = "metrics/queued/list"
        }
        "Deviations" {
            $path = "metrics/deviations/list"
            if ($PSBoundParameters.ContainsKey("DeviationPercentage")) { $parameters += "deviation_percentage=$DeviationPercentage" }
            if ($PSBoundParameters.ContainsKey("DeviationDirection")) { $parameters += "deviation_direction=$DeviationDirection" }
        }
    }
    $resource = Format-AMUri -Path $path -Parameters $parameters -RangeStart $StartDate -RangeEnd $EndDate
    $output = Invoke-AMRestMethod -Resource $resource -RestMethod Get -Connection $Connection
    foreach ($obj in $output) {
        switch ($Type) {
            "Running" {
                $obj.PSObject.Typenames.Insert(0, "AMMetricRunning")
            }
            "Completed" {
                $obj.PSObject.Typenames.Insert(0, "AMMetricCompleted")
            }
            "Queued" {
                $obj.PSObject.Typenames.Insert(0, "AMMetricQueued")
            }
            "Deviations" {
                $obj.PSObject.Typenames.Insert(0, "AMMetricDeviations")
            }
        }
        $obj
    }
}
