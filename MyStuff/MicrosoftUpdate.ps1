# https://devblogs.microsoft.com/powershell/preview-updating-powershell-7-2-with-microsoft-update/S
# must be elevated
$pwshRegPath = "HKLM:\SOFTWARE\Microsoft\PowerShellCore"
if (!(Test-Path -Path $pwshRegPath)) {
    throw "PowerShell 7 is not installed"
}

Set-ItemProperty -Path $pwshRegPath -Name UseMU -Value 1 -Type DWord
