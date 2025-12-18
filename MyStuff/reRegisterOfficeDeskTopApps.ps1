Get-ItemProperty "HKCU:\Software\Classes\ms-word\shell\open\command"

Function Test-M365DesktopApps {
    $apps = @(
        @{ Name = "Word"; ProgID = "Word.Application" },
        @{ Name = "Excel"; ProgID = "Excel.Application" },
        @{ Name = "PowerPoint"; ProgID = "PowerPoint.Application" },
        @{ Name = "Outlook"; ProgID = "Outlook.Application" }
    )

    foreach ($app in $apps) {
        try {
            $comObj = New-Object -ComObject $app.ProgID
            if ($comObj) {
                Write-Host "$($app.Name): ✅ Desktop app is installed and COM-accessible." -ForegroundColor Green
                $comObj.Quit() | Out-Null
            }
        }
        catch {
            Write-Host "$($app.Name): ❌ Not available as a desktop COM object. May default to web." -ForegroundColor Yellow
        }
    }
}

Get-ItemProperty "HKCU:\Software\Classes\ms-word\shell\open\command"

$wordPath = "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
New-Item -Path "HKCU:\Software\Classes\ms-word\shell\open\command" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Classes\ms-word\shell\open\command" -Name "(Default)" -Value "`"$wordPath`" `"%1`""