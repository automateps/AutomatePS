# Load module functions
Get-ChildItem -Path "$PSScriptRoot\Functions\Public\*.ps1" | ForEach-Object {
    . $_.FullName
    Export-ModuleMember -Function $_.BaseName
}
# Load supporting functions
Get-ChildItem -Path "$PSScriptRoot\Functions\Private\*.ps1" | ForEach-Object {
    . $_.FullName
}

Set-Variable -Name AMScheduleDateFormat -Value "MM/dd/yyyy HH:mm:ss" -Scope Global
Set-Variable -Name AMGuidRegex -Value "^(\{{0,1}([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\}{0,1})$" -Scope Global