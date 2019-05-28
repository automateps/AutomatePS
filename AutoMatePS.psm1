# Load module functions
Get-ChildItem -Path "$PSScriptRoot\Functions\Public\*.ps1" | ForEach-Object {
    . $_.FullName
    Export-ModuleMember -Function $_.BaseName -Alias *
}
# Load supporting functions
Get-ChildItem -Path "$PSScriptRoot\Functions\Private\*.ps1" | ForEach-Object {
    . $_.FullName
}

Set-Variable -Name AMScheduleDateFormat -Value "MM/dd/yyyy HH:mm:ss" -Scope Global
Set-Variable -Name AMGuidRegex -Value "^(\{{0,1}([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\}{0,1})$" -Scope Global

if ($global:PSVersionTable.PSVersion.Major -gt 5) {
    Write-Warning "AutomatePS is not fully compatible with PowerShell Core (v6 and greater) due to a JSON conversion issue (see https://github.com/PowerShell/PowerShell/issues/9610 for specifics).  'Get' functions will work.  However, most functions that modify objects will not work, or may produce unexpected results.  Use at your own risk."
}