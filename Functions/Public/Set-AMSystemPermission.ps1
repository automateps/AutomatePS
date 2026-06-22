function Set-AMSystemPermission {
    <#
        .SYNOPSIS
            Assigns security to an Automate system.

        .DESCRIPTION
            Set-AMPermission assigns security to the Automate server.

        .PARAMETER InputObject
            The system permission object to modify.

		.PARAMETER FullControl
			Sets all permissions to allow for the specified user(s) or group(s).

		.PARAMETER Deploy
			Allow or deny permission to deploy agents onto remote computers.

		.PARAMETER EditCredentials
			Allow or deny permission to edit credentials.

		.PARAMETER EditCredentialsConnections
			Allow or deny permission to edit credentials connections.

		.PARAMETER EditDashboard
			Allow or deny permission to edit the dashboard panel.

		.PARAMETER EditDefaultProperties
			Allow or deny permission to edit default properties.

		.PARAMETER EditLicensing
			Allow or deny permission to edit product license information.

		.PARAMETER EditPreferences
			Allow or deny permission to edit preferences.

		.PARAMETER EditRevisionManagement
			Allow or deny permission to edit the Revision Management information.

		.PARAMETER EditServerSettings
			Allow or deny permission to edit server level settings.

		.PARAMETER ToggleTriggering
			Allow or deny permission to turn global triggering on or off.

		.PARAMETER ViewCalendar
			Allow or deny permission to view the calendar of previous and future events.

		.PARAMETER ViewCredentials
			Allow or deny permission to view credentials.

		.PARAMETER ViewCredentialsConnections
			Allow or deny permission to view credentials connections.

		.PARAMETER ViewDashboard
            Allow or deny permission to view the dashboard panel of SMC.

		.PARAMETER ViewDefaultProperties
			Allow or deny permission to view default properties which affect the behavior of individual workflows, tasks, agents, and other objects.

		.PARAMETER ViewLicensing
			Allow or deny permission to view product license information.

		.PARAMETER ViewPreferences
			Allow or deny permission to view preferences which affect an assortment of visual and operational characteristics in SMC.

		.PARAMETER ViewRecycleBin
			Allow or deny permission to view the recycle bin.

		.PARAMETER ViewReports
			Allow or deny permission to view reports, including charts and tables.

		.PARAMETER ViewRevisionManagement
			Allow or deny permission to view the Revision Management information.

		.PARAMETER ViewServerSettings
			Allow or deny permission to view server level settings, such as Data Store, Load Management, SQL Connections and more.

        .EXAMPLE
            # Gives user 'John' full control
            Get-AMUser -Name "John" | New-AMSystemPermission -FullControl

        .LINK
            https://github.com/AutomatePS/AutomatePS/blob/master/Docs/New-AMSystemPermission.md
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [switch]$FullControl = $false,
        [switch]$Deploy = $false,
        [switch]$EditCredentials = $false,
        [switch]$EditCredentialsConnections = $false,
        [switch]$EditDashboard = $false,
        [switch]$EditDefaultProperties = $false,
        [switch]$EditLicensing = $false,
        [switch]$EditPreferences = $false,
        [switch]$EditRevisionManagement = $false,
        [switch]$EditServerSettings = $false,
        [switch]$ToggleTriggering = $false,
        [switch]$ViewCalendar = $false,
        [switch]$ViewCredentials = $false,
        [switch]$ViewCredentialsConnections = $false,
        [switch]$ViewDashboard = $false,
        [switch]$ViewDefaultProperties = $false,
        [switch]$ViewLicensing = $false,
        [switch]$ViewPreferences = $false,
        [switch]$ViewRecycleBin = $false,
        [switch]$ViewReports = $false,
        [switch]$ViewRevisionManagement = $false,
        [switch]$ViewServerSettings = $false
    )

    BEGIN {
        if ($FullControl.IsPresent) {
            $Deploy = $true
            $EditCredentials = $true
            $EditCredentialsConnections = $true
            $EditDashboard = $true
            $EditDefaultProperties = $true
            $EditLicensing = $true
            $EditPreferences = $true
            $EditRevisionManagement = $true
            $EditServerSettings = $true
            $ToggleTriggering = $true
            $ViewCalendar = $true
            $ViewCredentials = $true
            $ViewCredentialsConnections = $true
            $ViewDashboard = $true
            $ViewDefaultProperties = $true
            $ViewLicensing = $true
            $ViewPreferences = $true
            $ViewRecycleBin = $true
            $ViewReports = $true
            $ViewRevisionManagement = $true
            $ViewServerSettings = $true
        }
    }

    PROCESS {
        foreach ($obj in $InputObject) {
            $connection = Get-AMConnection -ConnectionAlias $obj.ConnectionAlias
            if ($obj.Type -in @("SystemPermission")) {
                $principal = Get-AMObject -Id $obj.GroupID -Types User,UserGroup
                $updateObject = $principal | Get-AMSystemPermission
                $shouldUpdate = $false

                if ($PSBoundParameters.ContainsKey("Deploy")) {
                    if ($updateObject.DeployPermission -ne $Deploy.IsPresent) {
                        $updateObject.DeployPermission = $Deploy.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("EditDashboard")) {
                    if ($updateObject.EditDashboardPermission -ne $EditDashboard.IsPresent) {
                        $updateObject.EditDashboardPermission = $EditDashboard.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("EditDefaultProperties")) {
                    if ($updateObject.EditDefaultPropertiesPermission -ne $EditDefaultProperties.IsPresent) {
                        $updateObject.EditDefaultPropertiesPermission = $EditDefaultProperties.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("EditLicensing")) {
                    if ($updateObject.EditLicensingPermission -ne $EditLicensing.IsPresent) {
                        $updateObject.EditLicensingPermission = $EditLicensing.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("EditPreferences")) {
                    if ($updateObject.EditPreferencesPermission -ne $EditPreferences.IsPresent) {
                        $updateObject.EditPreferencesPermission = $EditPreferences.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("EditServerSettings")) {
                    if ($updateObject.EditServerSettingsPermission -ne $EditServerSettings.IsPresent) {
                        $updateObject.EditServerSettingsPermission = $EditServerSettings.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("ToggleTriggering")) {
                    if ($updateObject.ToggleTriggeringPermission -ne $ToggleTriggering.IsPresent) {
                        $updateObject.ToggleTriggeringPermission = $ToggleTriggering.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("ViewCalendar")) {
                    if ($updateObject.ViewCalendarPermission -ne $ViewCalendar.IsPresent) {
                        $updateObject.ViewCalendarPermission = $ViewCalendar.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("ViewDashboard")) {
                    if ($updateObject.ViewDashboardPermission -ne $ViewDashboard.IsPresent) {
                        $updateObject.ViewDashboardPermission = $ViewDashboard.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("ViewDefaultProperties")) {
                    if ($updateObject.ViewDefaultPropertiesPermission -ne $ViewDefaultProperties.IsPresent) {
                        $updateObject.ViewDefaultPropertiesPermission = $ViewDefaultProperties.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("ViewLicensing")) {
                    if ($updateObject.ViewLicensingPermission -ne $ViewLicensing.IsPresent) {
                        $updateObject.ViewLicensingPermission = $ViewLicensing.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("ViewPreferences")) {
                    if ($updateObject.ViewPreferencesPermission -ne $ViewPreferences.IsPresent) {
                        $updateObject.ViewPreferencesPermission = $ViewPreferences.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("ViewReports")) {
                    if ($updateObject.ViewReportsPermission -ne $ViewReports.IsPresent) {
                        $updateObject.ViewReportsPermission = $ViewReports.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if ($PSBoundParameters.ContainsKey("ViewServerSettings")) {
                    if ($updateObject.ViewServerSettingsPermission -ne $ViewServerSettings.IsPresent) {
                        $updateObject.ViewServerSettingsPermission = $ViewServerSettings.IsPresent
                        $shouldUpdate = $true
                    }
                }
                if (Test-AMFeatureSupport -Connection $connection -Feature RevisionManagement -Action Ignore) {
                    if ($PSBoundParameters.ContainsKey("EditRevisionManagement")) {
                        if ($updateObject.EditRevisionManagementPermission -ne $EditRevisionManagement.IsPresent) {
                            $updateObject.EditRevisionManagementPermission = $EditRevisionManagement.IsPresent
                            $shouldUpdate = $true
                        }
                    }
                    if ($PSBoundParameters.ContainsKey("ViewRevisionManagement")) {
                        if ($updateObject.ViewRevisionManagementPermission -ne $ViewRevisionManagement.IsPresent) {
                            $updateObject.ViewRevisionManagementPermission = $ViewRevisionManagement.IsPresent
                            $shouldUpdate = $true
                        }
                    }
                    if ($PSBoundParameters.ContainsKey("ViewRecycleBin")) {
                        if ($updateObject.ViewRecycleBinPermission -ne $ViewRecycleBin.IsPresent) {
                            $updateObject.ViewRecycleBinPermission = $ViewRecycleBin.IsPresent
                            $shouldUpdate = $true
                        }
                    }
                }
                if (Test-AMFeatureSupport -Connection $connection -Feature Credentials -Action Ignore) {
                    if ($PSBoundParameters.ContainsKey("EditCredentials")) {
                        if ($updateObject.EditCredentialsPermission -ne $EditCredentials.IsPresent) {
                            $updateObject.EditCredentialsPermission = $EditCredentials.IsPresent
                            $shouldUpdate = $true
                        }
                    }
                    if ($PSBoundParameters.ContainsKey("EditCredentialsConnections")) {
                        if ($updateObject.EditVaultConnectionsPermission -ne $EditCredentialsConnections.IsPresent) {
                            $updateObject.EditVaultConnectionsPermission = $EditCredentialsConnections.IsPresent
                            $shouldUpdate = $true
                        }
                    }
                    if ($PSBoundParameters.ContainsKey("ViewCredentials")) {
                        if ($updateObject.ViewCredentialsPermission -ne $ViewCredentials.IsPresent) {
                            $updateObject.ViewCredentialsPermission = $ViewCredentials.IsPresent
                            $shouldUpdate = $true
                        }
                    }
                    if ($PSBoundParameters.ContainsKey("ViewCredentialsConnections")) {
                        if ($updateObject.ViewVaultConnectionsPermission -ne $ViewCredentialsConnections.IsPresent) {
                            $updateObject.ViewVaultConnectionsPermission = $ViewCredentialsConnections.IsPresent
                            $shouldUpdate = $true
                        }
                    }
                }

                $splat += @{
                    Resource = "/system_permissions/$($updateObject.ID)/update"
                    RestMethod = "Post"
                    Body = $updateObject.ToJson()
                    Connection = $obj.ConnectionAlias
                }
                if ($PSCmdlet.ShouldProcess($connection.Name, "Updating system permission for: $(Join-Path -Path $principal.Path -ChildPath $principal.Name)")) {
                    Invoke-AMRestMethod @splat | Out-Null
                    Write-Verbose "Assigned system permissions to $($principal.Type) '$($principal.Name)'!"
                    Get-AMSystemPermission -ID $updateObject.ID
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
