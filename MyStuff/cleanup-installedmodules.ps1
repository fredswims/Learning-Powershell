# ``https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/managing-installed-modules-part-2
function Cleanup-installedModules {
   

    # get all installed modules as a hash table
    # each key holds all versions of a given module
    $list = Get-InstalledModule |
    Get-InstalledModule -AllVersions |
    Group-Object -Property Name -AsHashTable -AsString

    # take all module names...
    $list.Keys | 
    ForEach-Object {
        # dump all present versions...
        $list[$_] | 
        # sort by version descending (newest first)
        Sort-Object -Property Version -Descending | 
        # and skip newest, returning all other
        Select-Object -Skip 1
    } |
    # remove outdated (check whether you really don't need them anymore)
    Uninstall-Module -WhatIf
}
Cleanup-installedModules