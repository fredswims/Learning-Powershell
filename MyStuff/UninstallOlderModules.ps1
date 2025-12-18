# See all installed versions
$SomeModule="oh-my-posh"
Get-InstalledModule $SomeModule -AllVersions

# Remove a specific version
Uninstall-Module $SomeModule -RequiredVersion 2.3.0

# Remove all but the latest
Get-InstalledModule $SomeModule -AllVersions |
    Sort-Object Version -Descending |
    Select-Object -Skip 1 |
    ForEach-Object { Uninstall-Module $_.Name -RequiredVersion $_.Version }