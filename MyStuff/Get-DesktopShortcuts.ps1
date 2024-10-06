# https://social.technet.microsoft.com/Forums/en-US/fddb6ec0-cc48-43f0-929e-bf25d07fbf48/get-target-path-of-shortcuts?forum=winserverpowershell
function Get-DesktopShortcuts{
    param ([Parameter(Mandatory = $true,
    HelpMessage = "Enter the name of a directory.")]
    [String]$Folder="."
    )
    $Shortcuts = Get-ChildItem -Recurse $Folder -Include *.lnk
    # $Shortcuts = Get-ChildItem -Recurse "C:\users\public\Desktop" -Include *.lnk
    $Shell = New-Object -ComObject WScript.Shell
    foreach ($Shortcut in $Shortcuts)
    {
        $Properties = @{
        ShortcutName = $Shortcut.Name;
        ShortcutFull = $Shortcut.FullName;
        ShortcutPath = $shortcut.DirectoryName
        Target = $Shell.CreateShortcut($Shortcut).targetpath
        }
        New-Object PSObject -Property $Properties
    }

[Runtime.InteropServices.Marshal]::ReleaseComObject($Shell) | Out-Null
}

# $Output = Get-DesktopShortcuts $Folder

# $Output | Out-GridView