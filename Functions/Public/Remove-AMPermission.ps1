function Remove-AMPermission {
    <#
        .SYNOPSIS
            Removes Automate permissions.

        .DESCRIPTION
            Remove-AMPermission removes the provided permissions.

        .PARAMETER InputObject
            The permissions object(s) to remove.

        .INPUTS
            Permission objects are deleted by this function.

        .OUTPUTS
            None

        .EXAMPLE
            # Remove system permissions for user "MyUsername"
            Get-AMFolder "FTP Workflows" | Get-AMPermission | Remove-AMPermission

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Position = 0, ParameterSetName = "ByPipeline", ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    PROCESS {
        :objectloop foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                "Permission" {
                    $construct = Get-AMObject -ID $obj.ConstructID -Connection $obj.ConnectionAlias
                    if (($construct | Measure-Object).Count -eq 1) {
                        $affectedUser = Get-AMObject -ID $obj.GroupID -Types User,UserGroup -Connection $obj.ConnectionAlias
                        if (($affectedUser | Measure-Object).Count -eq 1) {
                            if ($PSCmdlet.ShouldProcess($obj.ConnectionAlias, "Removing permission from $($construct.Type) '$($construct.Name)': $($affectedUser.Name)")) {
                                Write-Verbose "Removing permission from $($construct.Type) '$($construct.Name)' for '$($affectedUser.Name) (Type: $($affectedUser.Type))'."
                                Invoke-AMRestMethod -Resource "$(([AMTypeDictionary]::$($construct.Type)).RestResource)/$($obj.ConstructID)/permissions/$($obj.ID)/delete" -RestMethod Post -Connection $obj.ConnectionAlias | Out-Null
                            }
                        } else {
                            Write-Warning "Multiple objects found for user/group ID $($obj.ConstructID)! No action will be taken."
                            continue objectloop
                        }
                    } else {
                        Write-Warning "Multiple objects found for construct ID $($obj.ConstructID)! No action will be taken."
                        continue objectloop
                    }
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
        }
    }
}