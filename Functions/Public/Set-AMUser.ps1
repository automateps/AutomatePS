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

        .PARAMETER Domain
            The domain the user will authenticate against if running Automate version 23.1 or later.  On earlier versions specifying this parameter will enable AD authentication, but the domain passed in is ignored and the machine domain is used instead.

        .PARAMETER ForceReset
            Force the user to reset their password on login.

        .PARAMETER UseSecureConnection
            Use encryption when authenticating against Active Directory.

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
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium",DefaultParameterSetName="AutomateAuth")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        [Parameter(ParameterSetName = "AutomateAuth")]
        [ValidateNotNullOrEmpty()]
        [Security.SecureString]$Password,

        [Parameter(ParameterSetName = "ADAuth")]
        [ValidateNotNullOrEmpty()]
        [string]$Domain,
        
        [Parameter(ParameterSetName = "AutomateAuth")]
        [switch]$ForceReset,
        
        [Parameter(ParameterSetName = "ADAuth")]
        [switch]$UseSecureConnection,

        [AllowEmptyString()]
        [string]$Notes
    )

    BEGIN {
        switch ($PSCmdlet.ParameterSetName) {
            "AutomateAuth" { $AuthProvider = [AMAuthProvider]::Automate }
            "ADAuth"       { $AuthProvider = [AMAuthProvider]::AD }
        }
    }

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
                if (Test-AMFeatureSupport -Connection $obj.ConnectionAlias -Feature MultiDomainUser -Action Ignore) {
                    if ($PSBoundParameters.ContainsKey("Password")) {
                        if ($AuthProvider -eq [AMAuthProvider]::AD) {
                            $AuthProvider = [AMAuthProvider]::Automate
                            $updateObject.AuthProvider = $AuthProvider
                        }
                        $updateObject.Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
                        $shouldUpdate = $true
                    }
                    if ($PSBoundParameters.ContainsKey("Domain")) {
                        if ($AuthProvider -eq [AMAuthProvider]::Automate) {
                            $AuthProvider = [AMAuthProvider]::AD
                            $updateObject.AuthProvider = $AuthProvider
                            $shouldUpdate = $true
                        }
                        if ($updateObject.Domain -ne $Domain) {
                            $updateObject.Domain = $Domain
                            $shouldUpdate = $true
                        }
                    }
                    if ($PSBoundParameters.ContainsKey("ForceReset")) {
                        if ($AuthProvider -eq [AMAuthProvider]::AD) {
                            throw "The -ForceReset parameter only applies to users that authenticate with Automate.  Please specify -Password to switch the user to Automate authentication."
                        }
                        if ($updateObject.ForceReset -ne $ForceReset) {
                            $updateObject.ForceReset = $ForceReset
                            $shouldUpdate = $true
                        }
                    }
                    if ($PSBoundParameters.ContainsKey("UseSecureConnection")) {
                        if ($AuthProvider -eq [AMAuthProvider]::Automate) {
                            throw "The -UseSecureConnection parameter only applies to users that authenticate with AD.  Please specify -Domain to switch the user to AD authentication."
                        }
                        if ($updateObject.UseSecureConnection -ne $UseSecureConnection) {
                            $updateObject.UseSecureConnection = $UseSecureConnection
                            $shouldUpdate = $true
                        }
                    }
                } else {
                    if ($PSBoundParameters.ContainsKey("Password")) {
                        $updateObject.Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
                        $shouldUpdate = $true
                    }
                    if ($PSBoundParameters.ContainsKey("Domain")) {
                        $updateObject.Password = "<!*!>"
                        $shouldUpdate = $true
                    }
                    if ($PSBoundParameters.ContainsKey("ForceReset")) {
                        throw "The -ForceReset parameter is not supported by this version of Automate."
                    }
                    if ($PSBoundParameters.ContainsKey("UseSecureConnection")) {
                        throw "The -UseSecureConnection parameter is not supported by this version of Automate."
                    }
                }


                

                if ($PSBoundParameters.ContainsKey("AutomateAuth") -or $PSBoundParameters.ContainsKey("ADAuth")) {
                    if ($AuthProvider -eq [AMAuthProvider]::AD) {
                        if (Test-AMFeatureSupport -Connection $obj.ConnectionAlias -Feature MultiDomainUser -Action Ignore) {
                            $updateObject.AuthProvider = $AuthProvider
                            $updateObject.Domain = $Domain
                            $updateObject.UseSecureConnection = $UseSecureConnection.IsPresent
                        } else {                    
                            $updateObject.Password = "<!*!>"
                        }
                    } else {
                        $updateObject.Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
                        if (Test-AMFeatureSupport -Connection $obj.ConnectionAlias -Feature MultiDomainUser -Action Ignore) {
                            $updateObject.AuthProvider = $AuthProvider
                            $updateObject.ForceReset = $ForceReset.IsPresent
                        }
                    }
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