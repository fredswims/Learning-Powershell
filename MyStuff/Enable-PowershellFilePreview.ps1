<#
Enabling Preview of PowerShell Files in Windows Explorer
https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/enabling-preview-of-powershell-files-in-windows-explorer

When you view PowerShell scripts in Windows Explorer and have the preview pane open, by default you don’t get a code preview for your script files. The preview pane remains blank.
To enable the preview, simply use the function below:
Once you run the function, use this command:

 PS> Enable-PowerShellFilePreview

If you like, you can also set a font family and size for the preview. Note that this setting is shared with the Notepad:
PS> Enable-PowerShellFilePreview -Font Consolas -FontSize 100

No restart is required to see the effect. Just make sure the preview pane is visible in Windows Explorer, and select a PowerShell file.
#>
function Enable-PowerShellFilePreview
{
    [CmdletBinding()]
    param
    (
        [string]
        $Font = 'Courier New',

        [int]
        $FontSize = 60
    )

    # set the font and size (also applies to Notepad)
    $path = "HKCU:\Software\Microsoft\Notepad"
    Set-ItemProperty -Path $path -Name lfFaceName -Value $Font
    Set-ItemProperty -Path $path -Name iPointSize -Value $FontSize

    # enable the preview of PowerShell files
    $path = 'HKCU:\Software\Classes\.ps1'
    $exists = Test-Path -Path $path
    if (!$exists){
        $null = New-Item -Path $Path
    }
    $path = 'HKCU:\Software\Classes\.psd1'
    $exists = Test-Path -Path $path
    if (!$exists){
        $null = New-Item -Path $Path
    }

    $path = 'HKCU:\Software\Classes\.psm1'
    $exists = Test-Path -Path $path
    if (!$exists){
        $null = New-Item -Path $Path
    }


    Get-Item HKCU:\Software\Classes\* -Include .ps1,.psm1,.psd1 | Set-ItemProperty -Name PerceivedType -Value text
}