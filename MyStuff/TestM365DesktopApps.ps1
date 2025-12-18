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
Test-M365DesktopApps