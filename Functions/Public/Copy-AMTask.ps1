function Copy-AMTask {
    <#
        .SYNOPSIS
            Copies an AutoMate Enterprise task.

        .DESCRIPTION
            Copy-AMTask can copy a task object within, or between servers.

        .PARAMETER InputObject
            The object to copy.

        .PARAMETER Name
            The new name to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to copy the object to.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            Task

        .OUTPUTS
            Task

        .EXAMPLE
            # Copy task "Start Service" from server1 to server2
            Get-AMTask "Start Service" -Connection server1 | Copy-AMTask -Folder (Get-AMFolder TASKS -Connection server2) -Connection server2

        .EXAMPLE
            # Copy task "Start Service" with new name "Restart Service"
            Get-AMTask "Start Service" | Copy-AMTask -Name "Restart Service"

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
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        $Connection
    )

    BEGIN {
        if ($PSBoundParameters.ContainsKey("Connection")) {
            $Connection = Get-AMConnection -Connection $Connection
            $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Task") {
                if ($PSBoundParameters.ContainsKey("Connection")) {
                    # Copy from one AutoMate server to another
                    if ($obj.ConnectionAlias -ne $Connection.Alias) {
                        if ((Get-AMConnection -Connection $obj.ConnectionAlias).Version.Major -ne $Connection.Version.Major) {
                            throw "Source server and destination server are different versions! This module does not support changing task versions."
                        }
                        if ($PSBoundParameters.ContainsKey("Folder")) {
                            if ($Folder.ConnectionAlias -ne $Connection.Alias) {
                                throw "Folder specified exists on $($Folder.ConnectionAlias), the folder must exist on $($Connection.Name)!"
                            }
                        } else {
                            $Folder = Get-AMFolder -ID $user.TaskFolderID -Connection $Connection
                        }
                    }
                } else {
                    $Connection = Get-AMConnection -Connection $obj.ConnectionAlias
                    if (-not $PSBoundParameters.ContainsKey("Folder")) {
                        $Folder = Get-AMFolder -ID $obj.ParentID -Connection $obj.ConnectionAlias
                    }
                    $user = Get-AMUser -Connection $Connection | Where-Object {$_.Name -ieq $Connection.Credential.UserName}
                }
                
                if (-not $PSBoundParameters.ContainsKey("Name")) { $Name = $obj.Name }
                switch ($Connection.Version.Major) {
                    10      { $copyObject = [AMTaskv10]::new($Name, $Folder, $Connection.Alias) }
                    11      { $copyObject = [AMTaskv11]::new($Name, $Folder, $Connection.Alias) }
                    default { throw "Unsupported server major version: $_!" }
                }

                $copyObject.CreatedBy = $user.ID
                $currentObject = Get-AMTask -ID $obj.ID -Connection $obj.ConnectionAlias
                $copyObject.AML             = $currentObject.AML
                $copyObject.CompletionState = $currentObject.CompletionState
                $copyObject.Enabled         = $currentObject.Enabled
                $copyObject.LockedBy        = $currentObject.LockedBy
                $copyObject.Notes           = $currentObject.Notes
                $copyObject | New-AMObject -Connection $Connection
                Get-AMTask -ID $copyObject.ID -Connection $Connection
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
