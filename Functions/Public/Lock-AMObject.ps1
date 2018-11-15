function Lock-AMObject {
    <#
        .SYNOPSIS
            Locks an AutoMate Enterprise object.

        .DESCRIPTION
            Lock-AMObject receives AutoMate Enterprise object(s) on the pipeline, or via the parameter $InputObject, and locks the object(s).

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
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject
    )

    PROCESS {
        foreach ($obj in $InputObject) {
            $connection = Get-AMConnection -Connection $obj.ConnectionAlias
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

New-Alias -Name Lock-AMCondition  -Value Lock-AMObject -Scope Global
New-Alias -Name Lock-AMProcess    -Value Lock-AMObject -Scope Global
New-Alias -Name Lock-AMTask       -Value Lock-AMObject -Scope Global
New-Alias -Name Lock-AMWorkflow   -Value Lock-AMObject -Scope Global