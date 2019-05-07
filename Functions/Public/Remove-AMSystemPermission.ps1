function Remove-AMSystemPermission {
    <#
        .SYNOPSIS
            Removes AutoMate Enterprise system permissions.

        .DESCRIPTION
            Remove-AMSystemPermission removes the provided system permissions.

        .PARAMETER InputObject
            The permissions object(s) to remove.

        .INPUTS
            SystemPermission objects are deleted by this function.

        .OUTPUTS
            None

        .EXAMPLE
            # Remove system permissions for user "MyUsername"
            Get-AMUser "MyUsername" | Get-AMSystemPermission | Remove-AMSystemPermission

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
        foreach ($obj in $InputObject) {
            switch ($obj.Type) {
                "SystemPermission" {
                    $affectedUser = Get-AMObject -ID $obj.GroupID -Types User,UserGroup -Connection $obj.ConnectionAlias
                    if ($PSCmdlet.ShouldProcess($obj.ConnectionAlias, "Removing $($obj.Type): $($affectedUser.Name)")) {
                        Write-Verbose "Removing system permission for '$($affectedUser.Name) (Type: $($affectedUser.Type))'."
                        Invoke-AMRestMethod -Resource "system_permissions/$($obj.ID)/delete" -RestMethod Post | Out-Null
                    }
                }
                default {
                    Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
                }
            }
        }
    }
}
