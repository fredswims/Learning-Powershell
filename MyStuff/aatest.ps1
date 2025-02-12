Function Test-PathEnv {
    [cmdletbinding()]
    Param()
    
    $splitter = [System.IO.Path]::PathSeparator
    $pathenv = [System.Environment]::GetEnvironmentVariable("PATH")
    if ($pathenv) {
        # $env:PATH -split $splitter | Foreach-Object {
        $pathenv -split $splitter | Foreach-Object {
            # create a custom object based on each path
            [pscustomobject]@{
                Computername = [System.Environment]::MachineName
                Path         = $_
                Exists       = Test-Path $_
            }
        } 
    }
    else {
        Write-error "Failed to find an environmental path"
    }
}

Function makeobject {
    [cmdletbinding()]
    Param(
        [string]$Computername = [System.Environment]::MachineName,
        [string]$Path         = (join-path -Path $env:homepath -ChildPath 'Mystuff'),
        [string]$Filter
    )
    $Files = get-item -Path (Join-Path $Path $Filter)
    foreach ($File in $Files) {
        [pscustomobject]@{
            PSTypeName = 'My.Object'
            Name         = $File.Name
            FullName      =$File.Fullname
        }
    }    
}
clear-host
$files=makeobject -Filter "*object*.ps1"
$files |Get-Member
$files


Function Test22 {
    foreach ($Num in 1..10) {
        [pscustomobject]@{
            PSTypeName  = 'My.Object'
            Number      = $Num
        }
    }    
}
Clear-Host
$numbers=Test22

foreach ($file in 1..10) {write-host $file}

$a=test-pathenv
$count=1;foreach ($path in $env:path -split($splitter = [System.IO.Path]::PathSeparator)){"{0} {1} " -f $count++,  $path}

$splitter = [System.IO.Path]::PathSeparator
$pathenv = [System.Environment]::GetEnvironmentVariable("PATH")
$count=1
foreach ($path in $pathenv -split($splitter)) {"{0} {1} " -f $count++,  $path}


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


