function New-AMSystemPermission {
    <#
        .SYNOPSIS
            Assigns security to an Automate system.

        .DESCRIPTION
            New-AMPermission assigns security to the Automate server.

        .PARAMETER InputObject
            The user or group to assign security to.

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
            if ($obj.Type -in @("User","UserGroup")) {
                $currentPermissions = $obj | Get-AMSystemPermission
                if ($null -eq $currentPermissions) {
                    switch ($connection.GetCompatibility()) {
                        10 { $newObject = [AMSystemPermissionv10]::new($connection.Alias) }
                        11 {                            
                            if (Test-AMFeatureSupport -Connection $connection -Feature Credentials -Action Ignore) {
                                $newObject = [AMSystemPermissionv11dot4]::new($connection.Alias)
                            } else {
                                $newObject = [AMSystemPermissionv11]::new($connection.Alias)
                            }
                        }
                    }
                    $newObject.GroupID                              = $obj.ID
                    $newObject.DeployPermission                     = $Deploy.IsPresent
                    $newObject.EditDashboardPermission              = $EditDashboard.IsPresent
                    $newObject.EditDefaultPropertiesPermission      = $EditDefaultProperties.IsPresent
                    $newObject.EditLicensingPermission              = $EditLicensing.IsPresent
                    $newObject.EditPreferencesPermission           = $EditPreferences.IsPresent
                    $newObject.EditServerSettingsPermission         = $EditServerSettings.IsPresent
                    $newObject.ToggleTriggeringPermission           = $ToggleTriggering.IsPresent
                    $newObject.ViewCalendarPermission               = $ViewCalendar.IsPresent
                    $newObject.ViewDashboardPermission              = $ViewDashboard.IsPresent
                    $newObject.ViewDefaultPropertiesPermission      = $ViewDefaultProperties.IsPresent
                    $newObject.ViewLicensingPermission              = $ViewLicensing.IsPresent
                    $newObject.ViewPreferencesPermission            = $ViewPreferences.IsPresent
                    $newObject.ViewReportsPermission                = $ViewReports.IsPresent
                    $newObject.ViewServerSettingsPermission         = $ViewServerSettings.IsPresent
                    if (Test-AMFeatureSupport -Connection $connection -Feature RevisionManagement -Action Ignore) {
                        $newObject.EditRevisionManagementPermission = $EditRevisionManagement.IsPresent
                        $newObject.ViewRevisionManagementPermission = $ViewRevisionManagement.IsPresent
                        $newObject.ViewRecycleBinPermission         = $ViewRecycleBin.IsPresent
                    }
                    if (Test-AMFeatureSupport -Connection $connection -Feature Credentials -Action Ignore) {
                        $newObject.EditCredentialsPermission      = $EditCredentials.IsPresent
                        $newObject.EditVaultConnectionsPermission = $EditCredentialsConnections.IsPresent
                        $newObject.ViewCredentialsPermission      = $ViewCredentials.IsPresent
                        $newObject.ViewVaultConnectionsPermission = $ViewCredentialsConnections.IsPresent
                    }

                    $splat += @{
                        Resource = "/system_permissions/create"
                        RestMethod = "Post"
                        Body = $newObject.ToJson()
                        Connection = $obj.ConnectionAlias
                    }
                    if ($PSCmdlet.ShouldProcess($connection.Name, "Creating system permission for: $(Join-Path -Path $obj.Path -ChildPath $obj.Name)")) {
                        Invoke-AMRestMethod @splat | Out-Null
                        Write-Verbose "Assigned system permissions to $($obj.Type) '$($obj.Name)'!"
                        Get-AMSystemPermission -ID $newObject.ID
                    }
                } else {
                    Write-Warning "$($obj.Type) '$($obj.Name)' already has system permissions!"
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
