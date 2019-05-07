function Add-AMUserGroupMember {
    <#
        .SYNOPSIS
            Adds users to an AutoMate Enterprise user group.

        .DESCRIPTION
            Add-AMUserGroupMember can add users to a user group.

        .PARAMETER InputObject
            The user group to modify.

        .PARAMETER User
            The user name(s), or object(s) to add to the user group.

        .INPUTS
            The following AutoMate object types can be modified by this function:
            UserGroup

        .OUTPUTS
            None

        .EXAMPLE
            # Add all users to a user group
            Get-AMUserGroup "All Users" | Add-AMUserGroupMember -User *

        .EXAMPLE
            # Add a user to a user group (using user object)
            Get-AMUserGroup | Add-AMUserGroupMember -User (Get-AMUser "John")

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        $User
    )
    PROCESS {
        foreach ($obj in $InputObject) {
            if ($obj.Type -eq "UserGroup") {
                $update = Get-AMUserGroup -ID $obj.ID -Connection $obj.ConnectionAlias
                $shouldUpdate = $false
                foreach ($u in $User) {
                    if ($u.PSObject.Properties.Name -contains "Type") {
                        if ($u.Type -ne "User") {
                            throw "Unsupported input type '$($u.Type)' encountered!"
                        }
                    } elseif ($u -is [string]) {
                        $tempUser = Get-AMUser -Name $u -Connection $obj.ConnectionAlias
                        if ($tempUser) {
                            $u = $tempUser
                        } else {
                            throw "User '$u' not found!"
                        }
                    }
                    if ($u.ConnectionAlias -eq $obj.ConnectionAlias) {
                        if ($update.UserIDs -notcontains $u.ID) {
                            $update.UserIDs += $u.ID
                            $shouldUpdate = $true
                            Write-Verbose "Adding user '$($u.Name)' to user group '$($obj.Name)'."
                        } else {
                            Write-Verbose "User '$($u.Name)' already present in user group '$($obj.Name)'."
                        }
                    } else {
                        Write-Warning "User '$($u.Name)' on server $($u.ConnectionAlias) can not be added to user group '$($obj.Name)' on server $($obj.ConnectionAlias)."
                    }
                }
                if ($shouldUpdate) {
                    $update | Set-AMObject
                    Write-Verbose "Completed adding users to user group '$($obj.Name)'."
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
