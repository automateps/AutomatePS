function Copy-AMProcess {
    <#
        .SYNOPSIS
            Copies an Automate process.

        .DESCRIPTION
            Copy-AMProcess can copy a process object within, or between servers.

        .PARAMETER InputObject
            The object to copy.

        .PARAMETER Name
            The new name to set on the object.

        .PARAMETER Folder
            The folder to place the object in.

        .PARAMETER Connection
            The server to copy the object to.

        .INPUTS
            The following Automate object types can be modified by this function:
            Process

        .OUTPUTS
            Process

        .EXAMPLE
            # Copy process "Start Service" from server1 to server2
            Get-AMProcess "Start Service" -Connection server1 | Copy-AMProcess -Folder (Get-AMFolder PROCESSES -Connection server2) -Connection server2

        .EXAMPLE
            # Copy process "Start Service" with new name "Restart Service"
            Get-AMProcess "Start Service" | Copy-AMProcess -Name "Restart Service"

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Copy-AMProcess.md
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [ValidateScript({$_.Type -eq "Folder"})]
        $Folder,

        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter([AMConnectionCompleter])]
        $Connection
    )

    BEGIN {
        if ($PSBoundParameters.ContainsKey("Connection")) {
            $Connection = Get-AMConnection -Connection $Connection
            if (($Connection | Measure-Object).Count -eq 0) {
                throw "No Automate server specified!"
            } elseif (($Connection | Measure-Object).Count -gt 1) {
                throw "Multiple Automate servers specified, please specify one server to copy the process to!"
            }
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Process") {
                if ($PSBoundParameters.ContainsKey("Connection")) {
                    # Copy from one Automate server to another
                    if ($obj.ConnectionAlias -ne $Connection.Alias) {
                        if ($PSBoundParameters.ContainsKey("Folder")) {
                            if ($Folder.ConnectionAlias -ne $Connection.Alias) {
                                throw "Folder specified exists on $($Folder.ConnectionAlias), the folder must exist on $($Connection.Name)!"
                            }
                        } else {
                            $Folder = Get-AMDefaultFolder -Connection $Connection -Type PROCESSES
                        }
                    }
                } else {
                    $Connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
                    if (-not $PSBoundParameters.ContainsKey("Folder")) {
                        $Folder = Get-AMFolder -ID $obj.ParentID -Connection $obj.ConnectionAlias
                    }
                }

                if (-not $PSBoundParameters.ContainsKey("Name")) { $Name = $obj.Name }
                switch ($Connection.Version.Major) {
                    10                   { $copyObject = [AMProcessv10]::new($Name, $Folder, $Connection.Alias) }
                    {$_ -in 11,22,23,24} { $copyObject = [AMProcessv11]::new($Name, $Folder, $Connection.Alias) }
                    default              { throw "Unsupported server major version: $_!" }
                }

                if ($PSBoundParameters.ContainsKey("Connection") -and $obj.ConnectionAlias -ne $Connection.Alias) {
                    # If an object with the same ID doesn't already exist, use the same ID (when copying between servers)
                    if ((Get-AMProcess -ID $obj.ID -Connection $Connection -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
                        $copyObject.ID = $obj.ID
                    }
                }

                $currentObject = Get-AMProcess -ID $obj.ID -Connection $obj.ConnectionAlias
                $copyObject.CommandLine = $currentObject.CommandLine
                $copyObject.EnvironmentVariables = $currentObject.EnvironmentVariables
                $copyObject.RunProcessAs         = $currentObject.RunProcessAs
                $copyObject.WorkingDirectory     = $currentObject.WorkingDirectory
                $copyObject.CompletionState      = $currentObject.CompletionState
                $copyObject.Enabled              = $currentObject.Enabled
                $copyObject.LockedBy             = $currentObject.LockedBy
                $copyObject.Notes                = $currentObject.Notes
                $copyObject | New-AMObject -Connection $Connection
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
