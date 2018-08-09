function New-AMPerformanceCondition {    
    <#
        .SYNOPSIS
            Creates a new AutoMate Enterprise performance condition.

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

        .PARAMETER CompletionState
            The completion state (staging level) to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to create the object on.

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [string]$MachineName = "",

        [Parameter(Mandatory = $true)]
        [string]$CategoryName,

        [Parameter(Mandatory = $true)]
        [string]$CounterName,

        [Parameter(Mandatory = $true)]
        [string]$InstanceName,

        [AMPerformanceOperator]$Operator = [AMPerformanceOperator]::Below,

        [int]$Amount = 10,

        [int]$TimePeriod = 3,

        [AMTimeMeasure]$TimePeriodUnit = [AMTimeMeasure]::Milliseconds,

        [switch]$Wait = $true,
        [int]$Timeout = 0,
        [AMTimeMeasure]$TimeoutUnit = [AMTimeMeasure]::Seconds,
        [int]$TriggerAfter = 1,

        [string]$Notes = "",

        [ValidateNotNullOrEmpty()]
        [AMCompletionState]$CompletionState = [AMCompletionState]::Production,

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        $Connection
    )

    if ($PSBoundParameters.ContainsKey("Connection")) {
        $Connection = Get-AMConnection -Connection $Connection
    } else {
        $Connection = Get-AMConnection
    }
    if (($Connection | Measure-Object).Count -gt 1) {
        throw "Multiple AutoMate Servers are connected, please specify which server to create the new performance condition on!"
    }

    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
    if (-not $Folder) {
        # Place the task in the users condition folder
        $Folder = $user | Get-AMFolder -Type CONDITIONS
    }

    switch ($Connection.Version.Major) {
        10      { $newObject = [AMPerformanceTriggerv10]::new($Name, $Folder, $Connection.Alias) }
        11      { $newObject = [AMPerformanceTriggerv11]::new($Name, $Folder, $Connection.Alias) }
        default { throw "Unsupported server major version: $_!" }
    }
    $newObject.CompletionState = $CompletionState
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
    Get-AMCondition -ID $newObject.ID -Connection $Connection
}
