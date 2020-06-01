function Lock-AMObject {
    <#
        .SYNOPSIS
            Locks an Automate object.

        .DESCRIPTION
            Lock-AMObject receives Automate object(s) on the pipeline, or via the parameter $InputObject, and locks the object(s).

        .PARAMETER InputObject
            The object(s) to be locked.

        .INPUTS
            The following objects can be locked by this function:
            Workflow
            Task
            Process

        .OUTPUTS
            None

        .EXAMPLE
            Get-AMWorkflow "My Workflow" | Lock-AMObject

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    [Alias("Lock-AMCondition")]
    [Alias("Lock-AMProcess")]
    [Alias("Lock-AMTask")]
    [Alias("Lock-AMWorkflow")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
            switch ($obj.Type) {
                {$_ -in "Workflow","Task","Condition","Process"} {
                    $update = Get-AMObject -ID $obj.ID -Types $obj.Type -Connection $connection
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
            $user = Get-AMUser -Connection $connection | Where-Object {$_.Name -ieq $connection.Credential.UserName}
            $update.LockedBy = $user.ID
            $update | Set-AMObject
            Write-Verbose "Locked $($obj.Type) '$($obj.Name)'."
        }
    }
}