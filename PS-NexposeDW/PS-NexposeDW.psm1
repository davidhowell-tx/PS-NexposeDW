# Get a list of the included scripts and import them
$ModulePath = Split-Path $MyInvocation.MyCommand.Path -Parent
Get-ChildItem -Path $ModulePath -Filter *.ps1 -Recurse | ForEach-Object {
    if ($_.FullName -notlike '*.Tests.ps1') {
        . $_.FullName
    }
}

# Config
Set-Variable -Name "NexposeDWConfigPath" -Value "$Env:AppData\PS-NexposeDW.conf" -Scope Global
Export-ModuleMember -Variable $NexposeDWConfigPath
Export-ModuleMember -Function Get-NPDWConfig
Export-ModuleMember -Function Set-NPDWConfig

# Queries
Export-ModuleMember -Function Invoke-NPDWQuery