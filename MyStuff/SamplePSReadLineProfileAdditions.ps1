using namespace System.Management.Automation
using namespace System.Management.Automation.Language
# file SamplePSReadlineProfileFred.ps1
# amendments to SamplePSReadLineProfile.ps1
    Write-Warning "In Script [$($PSCommandPath)]: [$([datetime]::now)]"
    Read-Host "pause"
Set-PSReadLineOption -EditMode windows
Set-PSReadLineOption -PredictionViewStyle ListView # toggle with F2

<#
function Toggle-PSReadLineEditMode {
    $currentMode = (Get-PSReadLineOption).EditMode
    if ($currentMode -eq 'Windows') {
        Set-PSReadLineOption -EditMode Emacs
        Write-Host "Switched to Emacs mode"
    } else {
        Set-PSReadLineOption -EditMode Windows
        Write-Host "Switched to Windows mode"
    }
}

Set-PSReadLineKeyHandler -Chord Ctrl+e -ScriptBlock { Toggle-PSReadLineEditMode }
#>


# Set-PSReadLineKeyHandler -Key Ctrl+V `
# copy from SamplePSReadLineProfile.ps1
# changing key sequence
<# 
Set-PSReadLineKeyHandler -Key Alt+W `
                         -BriefDescription PasteAsHereString `
                         -LongDescription "Paste the clipboard text as a here string" `
                         -ScriptBlock {
    param($key, $arg)

    Add-Type -Assembly PresentationCore
    if ([System.Windows.Clipboard]::ContainsText())
    {
        # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
        $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n","`n").TrimEnd()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
    }
    else
    {
        [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
    }
}

 #>
 
<# 
Playground
PSReadLine\Get-PSReadLineKeyHandler # to see all the key definitions
	implemented as alt+ctrl+?

get-psreadlineoption | Format-List *
set-psreadLineOption -DingTone 1000
[Microsoft.PowerShell.PSConsoleReadLine]::ding()
[Microsoft.PowerShell.PSConsoleReadLine]|get-member -static
 #>
