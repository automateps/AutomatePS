function New-AMPerformanceCondition {
    <#
        .SYNOPSIS
            Creates a new Automate performance condition.

        .DESCRIPTION
            New-AMPerformanceCondition creates a new performance condition.

        .PARAMETER Name
            The name of the new object.

        .PARAMETER MachineName
            The computer to check performance counters on.

        .PARAMETER CategoryName
            The system category in which to monitor (i.e. Processor, Memory, Paging File, etc.). A category catalogues performance counters in a logical unit.

        .PARAMETER CounterName
            The type of counter related to the category in which to monitor. Performance counters are combined together under categories. They are used to measure various aspects of performance, such as transfer rates for disks or, for processors, the amount of processor time consumed. Specific counters are populated in this section depending on the performance category selected.

        .PARAMETER InstanceName
            The instance related to the category in which to monitor. A performance counter can be divided into instances, such as processes, threads, or physical units.

        .PARAMETER Operator
            Above or Below.

        .PARAMETER Amount
            The threshold to trigger on.

        .PARAMETER TimePeriod
            The amount of time to wait before triggering.

        .PARAMETER TimePeriodUnit
            The unit of time for TriggerWhenTimePeriod.

        .PARAMETER Wait
            Wait for the condition, or evaluate immediately.

        .PARAMETER Timeout
            If wait is specified, the amount of time before the condition times out.

        .PARAMETER TimeoutUnit
            The unit for Timeout (Seconds by default).

        .PARAMETER TriggerAfter
            The number of times the condition should occur before the trigger fires.

        .PARAMETER Notes
            The new notes to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMPerformanceCondition.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [string]$MachineName = "",

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CategoryName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CounterName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InstanceName,

        [ValidateNotNullOrEmpty()]
        [AMPerformanceOperator]$Operator = [AMPerformanceOperator]::Below,

        [ValidateNotNullOrEmpty()]
        [int]$Amount = 10,

        [ValidateNotNullOrEmpty()]
        [int]$TimePeriod = 3,

        [ValidateNotNullOrEmpty()]
        [AMTimeMeasure]$TimePeriodUnit = [AMTimeMeasure]::Milliseconds,

        [ValidateNotNullOrEmpty()]
        [switch]$Wait = $true,
        [int]$Timeout = 0,
        [AMTimeMeasure]$TimeoutUnit = [AMTimeMeasure]::Seconds,
        [int]$TriggerAfter = 1,

        [string]$Notes = "",

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    switch (($Connection | Measure-Object).Count) {
        1 {
            $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
            if (-not $Folder) { $Folder = $user | Get-AMFolder -Type CONDITIONS } # Place the condition in the users condition folder
            switch ($Connection.Version.Major) {
                10      { $newObject = [AMPerformanceTriggerv10]::new($Name, $Folder, $Connection.Alias) }
                11      { $newObject = [AMPerformanceTriggerv11]::new($Name, $Folder, $Connection.Alias) }
                default { throw "Unsupported server major version: $_!" }
            }
            $newObject.CreatedBy       = $user.ID
            $newObject.Notes           = $Notes
            $newObject.Wait            = $Wait.ToBool()
            if ($newObject.Wait) {
                $newObject.Timeout      = $Timeout
                $newObject.TimeoutUnit  = $TimeoutUnit
                $newObject.TriggerAfter = $TriggerAfter
            }
            $newObject.MachineName    = $MachineName
            $newObject.CounterName    = $CounterName
            $newObject.CategoryName   = $CategoryName
            $newObject.InstanceName   = $InstanceName
            $newObject.Operator       = $Operator
            $newObject.Amount         = $Amount
            $newObject.TimePeriod     = $TimePeriod
            $newObject.TimePeriodUnit = $TimePeriodUnit
            $newObject | New-AMObject -Connection $Connection
        }
        0       { throw "No servers are currently connected!" }
        default { throw "Multiple Automate servers are connected, please specify which server to create the new condition on!" }
    }
}