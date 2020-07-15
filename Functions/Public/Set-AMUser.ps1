function Set-AMUser {
    <#
        .SYNOPSIS
            Sets properties of an Automate user.

        .DESCRIPTION
            Set-AMUser can change properties of a user object.

        .PARAMETER InputObject
            The object to modify.

        .PARAMETER Password
            The password for the user.

        .PARAMETER UseActiveDirectory
            Authenticate against Active Directory.  If not specified, Automate authentication is used.

        .PARAMETER Notes
            The new notes to set on the object.

        .EXAMPLE
            # Change password for a user that authenticates against Automate
            Get-AMUser -Name John | Set-AMUser -Password (Read-Host -Prompt "Enter password" -AsSecureString)

        .NOTES
            The API requires that the password be passed in on every update call.  Therefore, it is required to either specify the -Password parameter or -UseActiveDirectory whenever calling this function, even if only updating the Notes property for the user.

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/Set-AMUser.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = "AutomatePassword")]
        [ValidateNotNullOrEmpty()]
        [Security.SecureString]$Password,

        [Parameter(Mandatory = $true, ParameterSetName = "ActiveDirectoryPassword")]
        [switch]$UseActiveDirectory,

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
                if ($UseActiveDirectory.IsPresent) {
                    $updateObject.Password = "<!*!>"
                    $shouldUpdate = $true
                } else {
                    $updateObject.Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
                    $shouldUpdate = $true
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