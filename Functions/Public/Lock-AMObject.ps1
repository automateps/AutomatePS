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
            Date Modified  : 08/08/2018

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
            $connection = Get-AMConnection -Connection $obj.ConnectionAlias
            switch ($obj.Type) {
                "Workflow"  { $update = Get-AMWorkflow -ID $obj.ID -Connection $connection  }
                "Task"      { $update = Get-AMTask -ID $obj.ID -Connection $connection      }
                "Condition" { $update = Get-AMCondition -ID $obj.ID -Connection $connection }
                "Process"   { $update = Get-AMProcess -ID $obj.ID -Connection $connection   }
                default     { Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj  }
            }

            $user = Get-AMUser -Connection $connection | Where-Object {$_.Name -ieq $connection.Credential.UserName}
            $update.LockedBy = $user.ID
            $update | Set-AMObject
            Write-Verbose "Locked $($obj.Type) '$($obj.Name)'."
        }
    }
}
