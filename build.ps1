using module AutomatePS  # Expose custom types so PlatyPS can create help
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")] param ()
#requires -Modules PlatyPS

# Update module manifest
$functions = Get-ChildItem ".\Functions\Public\*.ps1" | Select-Object -ExpandProperty BaseName
$scripts = Get-ChildItem .\Types | ForEach-Object { "types\$($_.Name)" }
if ($PSCmdlet.ShouldProcess("Updating module manifest")) {
    #Update-ModuleManifest -Path ".\AutomatePS.psd1" -FunctionsToExport $functions
    $manifestSplat = @{
        Guid = "410dd814-d087-4645-a62e-0388a22798c0"
        Path = ".\AutomatePS.psd1"
        Author = "AutomatePS"
        Description = "AutomatePS provides PowerShell integration with HelpSystems AutoMate Enterprise"
        RootModule = "AutomatePS"
        PowerShellVersion = "5.0"
        FormatsToProcess = "AutomatePS.Format.ps1xml"
        ScriptsToProcess = $scripts
        FunctionsToExport = $functions
        HelpInfoUri = "https://github.com/AutomatePS/AutomatePS"
        ProjectUri = "https://github.com/AutomatePS/AutomatePS"
        ModuleVersion = "4.0.0"
    }
    New-ModuleManifest @manifestSplat
}

# Re-import module to update help
Remove-Module -Name "AutomatePS" -Force
Import-Module -Name ".\AutomatePS.psd1" -Force

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