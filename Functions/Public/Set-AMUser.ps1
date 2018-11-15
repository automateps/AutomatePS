function Set-AMUser {
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise user.

        .DESCRIPTION
            Set-AMUser can change properties of a user object.

        .PARAMETER InputObject
            The object to modify.

        .PARAMETER Notes
            The new notes to set on the object.

        .EXAMPLE
            # Change notes for a user
            Get-AMUser -Name David | Set-AMUser -Notes "Email address: david@example.com"

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
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
            if ($obj.Type -eq "User") {
                $updateObject = Get-AMUser -ID $obj.ID -Connection $obj.ConnectionAlias
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
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
