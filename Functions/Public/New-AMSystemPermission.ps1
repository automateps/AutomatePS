function New-AMSystemPermission {
    <#
        .SYNOPSIS
            Assigns security to an AutoMate Enterprise system.

        .DESCRIPTION
            New-AMPermission assigns security to the AutoMate Enterprise server.

        .PARAMETER InputObject
            The user or group to assign security to.

		.PARAMETER FullControl
			Sets all permissions to allow for the specified user(s) or group(s).

		.PARAMETER Deploy
			Allow or deny permission to deploy agents onto remote computers.

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

		.PARAMETER ViewDashboard
            Allow or deny permission to view the dashboard panel of SMC.

		.PARAMETER ViewDefaultProperties
			Allow or deny permission to view default properties which affect the behavior of individual workflows, tasks, agents, and other objects.

		.PARAMETER ViewLicensing
			Allow or deny permission to view product license information.

		.PARAMETER ViewPreferences
			Allow or deny permission to view preferences which affect an assortment of visual and operational characteristics in SMC.

		.PARAMETER ViewReports
			Allow or deny permission to view reports, including charts and tables.

		.PARAMETER ViewRevisionManagement
			Allow or deny permission to view the Revision Management information.

		.PARAMETER ViewServerSettings
			Allow or deny permission to view server level settings, such as Data Store, Load Management, SQL Connections and more.

        .EXAMPLE
            # Denies user 'John' access to task 'Test'
            Get-AMTask -Name "Test" | New-AMPermission -Principal 'John'

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 11/15/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $InputObject,

        [switch]$FullControl = $false,
        [switch]$Deploy = $false,
        [switch]$EditDashboard = $false,
        [switch]$EditDefaultProperties = $false,
        [switch]$EditLicensing = $false,
        [switch]$EditPreferences = $false,
        [switch]$EditRevisionManagement = $false,
        [switch]$EditServerSettings = $false,
        [switch]$ToggleTriggering = $false,
        [switch]$ViewCalendar = $false,
        [switch]$ViewDashboard = $false,
        [switch]$ViewDefaultProperties = $false,
        [switch]$ViewLicensing = $false,
        [switch]$ViewPreferences = $false,
        [switch]$ViewReports = $false,
        [switch]$ViewRevisionManagement = $false,
        [switch]$ViewServerSettings = $false
    )

    BEGIN {
        if ($FullControl.ToBool()) {
            $Deploy = $true
            $EditDashboard = $true
            $EditDefaultProperties = $true
            $EditLicensing = $true
            $EditPreferences = $true
            $EditRevisionManagement = $true
            $EditServerSettings = $true
            $ToggleTriggering = $true
            $ViewCalendar = $true
            $ViewDashboard = $true
            $ViewDefaultProperties = $true
            $ViewLicensing = $true
            $ViewPreferences = $true
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
                    switch ($connection.Version.Major) {
                        10 { $newObject = [AMSystemPermissionv10]::new($connection.Alias) }
                        11 {
                            $newObject = [AMSystemPermissionv11]::new($connection.Alias)
                            $newObject.EditRevisionManagementPermission = $EditRevisionManagement.ToBool()
                            $newObject.ViewRevisionManagementPermission = $ViewRevisionManagement.ToBool()
                        }
                        default { throw "Unsupported server major version: $_!" }
                    }
                    $newObject.GroupID                         = $obj.ID
                    $newObject.DeployPermission                = $Deploy.ToBool()
                    $newObject.EditDashboardPermission         = $EditDashboard.ToBool()
                    $newObject.EditDefaultPropertiesPermission = $EditDefaultProperties.ToBool()
                    $newObject.EditLicensingPermission         = $EditLicensing.ToBool()
                    $newObject.EditPreferencesPermission       = $EditPreferences.ToBool()
                    $newObject.EditServerSettingsPermission    = $EditServerSettings.ToBool()
                    $newObject.ToggleTriggeringPermission      = $ToggleTriggering.ToBool()
                    $newObject.ViewCalendarPermission          = $ViewCalendar.ToBool()
                    $newObject.ViewDashboardPermission         = $ViewDashboard.ToBool()
                    $newObject.ViewDefaultPropertiesPermission = $ViewDefaultProperties.ToBool()
                    $newObject.ViewLicensingPermission         = $ViewLicensing.ToBool()
                    $newObject.ViewPreferencesPermission       = $ViewPreferences.ToBool()
                    $newObject.ViewReportsPermission           = $ViewReports.ToBool()
                    $newObject.ViewServerSettingsPermission    = $ViewServerSettings.ToBool()

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
