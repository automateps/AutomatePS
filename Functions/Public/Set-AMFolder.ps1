function Set-AMFolder {
    <#
        .SYNOPSIS
            Sets properties of an Automate folder.

        .DESCRIPTION
            Set-AMFolder can change properties of a folder object.

        .PARAMETER InputObject
            The object to modify.

        .PARAMETER Notes
            The new notes to set on the object.

        .EXAMPLE
            # Modify folder notes
            Get-AMFolder Test | Set-AMFolder -Notes "This folder contains test workflows"

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMFolder.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Notes
    )
    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "Folder") {
                if ($obj.Path -ne "\") {
                    $updateObject = Get-AMFolder -ID $obj.ID -Connection $obj.ConnectionAlias
                    $shouldUpdate = $false
                    if ($PSBoundParameters.ContainsKey("Notes")) {
                        if ($updateObject.Notes -ne $Notes) {
                            $updateObject.Notes = $Notes
                            $shouldUpdate = $true
                        }
                    }
                    if ($shouldUpdate) {
                        $updateObject | Set-AMObject
                    } else {
                        Write-Verbose "$($obj.Type) '$($obj.Name)' already contains the specified values."
                    }
                } else {
                    Write-Error "Root folders cannot be modified.  Folder specified: $(Join-Path -Path $obj.Path -ChildPath $obj.Name)"
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
