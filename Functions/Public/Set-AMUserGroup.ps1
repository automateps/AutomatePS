function Set-AMUserGroup {
    <#
        .SYNOPSIS
            Sets properties of an AutoMate Enterprise user group.

        .DESCRIPTION
            Set-AMUserGroup can change properties of a user group object.

        .PARAMETER InputObject
            The user group to modify.

        .PARAMETER Notes
            The new notes to set on the object.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            UserGroup

        .EXAMPLE
            # Changes notes for a single user group
            Get-AMUserGroup "Users" | Set-AMUserGroup -Notes "Group containing all users"

        .EXAMPLE
            # Empty notes for all user groups
            Get-AMUserGroup | Set-AMUserGroup -Notes ""

        .LINK
            https://github.com/AutomatePS/AutomatePS
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
            if ($obj.Type -eq "UserGroup") {
                $updateObject = Get-AMUserGroup -ID $obj.ID -Connection $obj.ConnectionAlias
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
