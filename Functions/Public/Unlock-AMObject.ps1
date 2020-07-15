function Unlock-AMObject {
    <#
        .SYNOPSIS
            Unlocks an Automate object.

        .DESCRIPTION
            Unlock-AMObject receives Automate object(s) on the pipeline, or via the parameter $InputObject, and unlocks the object(s).

        .PARAMETER InputObject
            The object(s) to be unlocked.

        .INPUTS
            The following objects can be unlocked by this function:
            Workflow
            Task
            Process

        .EXAMPLE
            Get-AMWorkflow "My Workflow" | Unlock-AMObject

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Unlock-AMObject.md
    #>
    [CmdletBinding()]
    [Alias("Unlock-AMCondition")]
    [Alias("Unlock-AMProcess")]
    [Alias("Unlock-AMTask")]
    [Alias("Unlock-AMWorkflow")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                {$_ -in "Workflow","Task","Condition","Process"} {
                    $update = Get-AMObject -ID $obj.ID -Types $obj.Type -Connection $obj.ConnectionAlias
                }
                default { Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj  }
            }
            $update.LockedBy = ""
            $update | Set-AMObject
            Write-Verbose "Unlocked $($obj.Type) '$($obj.Name)'."
        }
    }
}