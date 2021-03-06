Function Test-PathEnv {
    [cmdletbinding()]
    Param()
    
    $splitter = [System.IO.Path]::PathSeparator
    
    $pathenv = [System.Environment]::GetEnvironmentVariable("PATH")
    if ($pathenv) {
        $env:PATH -split $splitter | Foreach-Object {
            # create a custom object based on each path
            [pscustomobject]@{
                Computername = [System.Environment]::MachineName
                Path         = $_
                Exists       = Test-Path $_
            }
        } 
    }
    else {
        Write-Warning "Failed to find an environmental path"
    }
}


$missing = Test-PathEnv | Where-object {-not $_.exists}
$savedUser = (Get-itemproperty -path HKCU:\Environment\).path
$savedSystem = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').path

foreach ($p in $missing.path) {
    Write-Host "Searching for $p" -ForegroundColor Yellow
    $user = (Get-itemproperty -path 'HKCU:\Environment\').path -split ";"
    if ($user -contains $p) {
        Write-Host "Found in HKCU" -ForegroundColor green
        $fix = $user | Where-Object {$_ -ne $p}
        $value = $fix -join ";"
        Set-ItemProperty -Path 'HKCU:\Environment\' -Name Path -Value $value -WhatIf

    }
    $system = (Get-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').path -split ";"
    if ($system -contains $p) {
        Write-Host "Found in HKLM" -ForegroundColor Green
        $fix = $system | Where-Object {$_ -ne $p}
        $value = $fix -join ";"
        Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Value $value -WhatIf
    }
}


