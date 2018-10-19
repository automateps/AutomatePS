function Unlock-AMObject {
    <#
        .SYNOPSIS
            Unlocks an AutoMate Enterprise object.

        .DESCRIPTION
            Unlock-AMObject receives AutoMate Enterprise object(s) on the pipeline, or via the parameter $InputObject, and unlocks the object(s).

        .PARAMETER InputObject
            The object(s) to be unlocked.

        .INPUTS
            The following objects can be unlocked by this function:
            Workflow
            Task
            Process

        .EXAMPLE
            Get-AMWorkflow "My Workflow" | Unlock-AMObject

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 10/19/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                {$_ -in "Workflow","Task","Condition","Process"} {
                    $update = Get-AMObject -ID $obj.ID -Types $obj.Type -Connection $obj.ConnectionAlias
                }
                default     { Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj  }
            }
            $update.LockedBy = ""
            $update | Set-AMObject
            Write-Verbose "Unlocked $($obj.Type) '$($obj.Name)'."
        }
    }
}