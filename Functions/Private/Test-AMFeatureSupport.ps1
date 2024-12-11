function Test-AMFeatureSupport {
    <#
        .SYNOPSIS
            Tests if new features are supported on the connected server.

        .DESCRIPTION
            Test-AMFeatureSupport tests if new features are supported on the connected server.

        .PARAMETER Connection
            The connection to check for feature support.

        .PARAMETER Feature
            The feature to test support for.

        .PARAMETER Action
            The action to take if the feature is not supported.

        .EXAMPLE
            # Test if email conditions are supported, throw an error if not.
            if (Test-AMFeatureSupport -Connection server1 -Feature EmailCondition -Action Throw) {
                # Do something
            }

        .LINK
            https://github.com/AutomatePS/AutomatePS
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Connection,

        [Parameter(Mandatory = $true)]
        [ValidateSet("EmailCondition","FileSystemConditionPollingMode","ApiRuntimeVariables","MultiDomainUser","ApiKeyAuthentication")]
        $Feature,

        [ValidateSet("Throw","Warn","Ignore")]
        $Action
    )

    $featureVersions = @{
        EmailCondition                 = [Version]"11.0.0.0"
        FileSystemConditionPollingMode = [Version]"11.1.20.0"
        ApiRuntimeVariables            = [Version]"11.4.0.0"
        MultiDomainUser                = [Version]"23.1.0.0"
        ApiKeyAuthentication           = [Version]"23.1.0.0"
    }

    if ($Connection -is [string]) {
        $serverConnection = Get-AMConnection -Connection $Connection
    } elseif ($Connection -is [AMConnection]) {
        $serverConnection = $Connection
    }
    if ($serverConnection.GetServerVersion() -lt $featureVersions[$Feature]) {
        $message = "Feature '$Feature' is not supported in version $($serverConnection.Version), version $($featureVersions[$Feature]) or greater is required."
        switch ($Action) {
            "Warn" {
                Write-Warning -Message $message
            }
            "Throw" {
                throw $message
            }
            default {}
        }
        return $false
    } else {
        return $true
    }
}