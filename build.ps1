#requires -Modules PlatyPS
foreach ($file in Get-ChildItem -Path .\Functions -File -Recurse) {

    # Update modify dates
    $modifyDate = Get-Date $file.LastWriteTime -Format "MM/dd/yyyy"
    $content = $file | Get-Content
    $contentChanged = $false
    :contentloop foreach ($i in 0..($content.Count - 1)) {
        if ($content[$i] -like "*Date Modified*") {
            $oldModifyDate = $content[$i].Split(":")[1].Trim()
            if ($modifyDate -ne $oldModifyDate) {
                $content[$i] = $line.Replace($oldModifyDate, $modifyDate)
                $contentChanged = $true
            }
            break contentloop
        }
    }
    if ($contentChanged) {
        $content | Set-Content -Path $file.FullName
    }
}

# Generate help markdown files
New-MarkdownHelp -Module "AutoMatePS" -OutputFolder ".\Docs" -Force

# Update module manifest
$functions = Get-ChildItem ".\Functions\Public\*.ps1" | Select-Object -ExpandProperty BaseName
Update-ModuleManifest -Path ".\AutoMatePS.psd1" -FunctionsToExport $functions

Remove-Module -Name "AutoMatePS" -Force
Import-Module -Name "AutoMatePS" -Force

# Validate parameter help
$helps = $functions | ForEach-Object {Get-Help $_}
foreach ($help in $helps) {
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