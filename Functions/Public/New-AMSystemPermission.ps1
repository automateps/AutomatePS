function New-AMSystemPermission {
    <#
        .SYNOPSIS
            Assigns security to an AutoMate Enterprise system.

        .DESCRIPTION
            New-AMPermission assigns security to the AutoMate Enterprise server.

        .PARAMETER InputObject
            The user or group to assign security to.

        .EXAMPLE
            # Denies user 'John' access to task 'Test'
            Get-AMTask -Name "Test" | New-AMPermission -Principal 'John'

        .NOTES
            Author(s):     : David Seibel
            Contributor(s) :
            Date Created   : 07/26/2018
            Date Modified  : 08/08/2018

        .LINK
            https://github.com/davidseibel/AutoMatePS
    #>
    [CmdletBinding()]
    param(
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
            $connection = Get-AMConnection $obj.ConnectionAlias
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
                        AMServer = $obj.ConnectionAlias
                    }
                    Invoke-AMRestMethod @splat | Out-Null
                    Write-Verbose "Assigned system permissions to $($obj.Type) '$($obj.Name)'!"
                } else {
                    Write-Warning "$($obj.Type) '$($obj.Name)' already has system permissions!"
                }
            } else {
                Write-Error -Message "Unsupported input type '$($obj.Type)' encountered!" -TargetObject $obj
            }
        }
    }
}
