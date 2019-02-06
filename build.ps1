using module AutoMatePS  # Expose custom types so PlatyPS can create help
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")] param ()
#requires -Modules PlatyPS

# Update module manifest
$functions = Get-ChildItem ".\Functions\Public\*.ps1" | Select-Object -ExpandProperty BaseName
if ($PSCmdlet.ShouldProcess("Updating module manifest")) {
    Update-ModuleManifest -Path ".\AutoMatePS.psd1" -FunctionsToExport $functions
}

# Re-import module to update help
Remove-Module -Name "AutoMatePS" -Force
Import-Module -Name "AutoMatePS" -Force

# Validate parameter help
# Validate parameter help
$helps = $functions | ForEach-Object {
    if (Get-Command -Name $_ -ErrorAction SilentlyContinue) {
        Get-Help $_
    } else {
        Write-Warning "Could not find command $_."
    }
}
foreach ($help in $helps) {
    # Check for Description
    if ([string]::IsNullOrEmpty($help.Description.Text)) {
        Write-Warning "$($help.Name) does not have a description defined in help."
    }
    foreach ($parameter in $help.Parameters.Parameter) {
        if ($parameter -notmatch 'whatif|confirm') {
            if ([string]::IsNullOrEmpty($parameter.Description.Text)) {
                Write-Warning "$($help.Name) -$($parameter.Name) does not have a description defined in help."
            }
        }
    }
}

# Make sure the synopsis and description isn't the same on multiple functions (happens when a function is copied to create a new one).
foreach ($synopsisGroup in ($helps | Group-Object Synopsis | Where-Object {$_.Count -gt 1})) {
    Write-Warning "The following functions have the same Synopsis: $($synopsisGroup.Group.Name -join ", ")"
}
foreach ($descriptionGroup in ($helps | Group-Object @{Expression={$_.Description.Text}} | Where-Object {$_.Count -gt 1})) {
    Write-Warning "The following functions have the same Description: $($descriptionGroup.Group.Name -join ", ")"
}