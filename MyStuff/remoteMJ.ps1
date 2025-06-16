<# 
Get the services on MJ (the remote) and Book4Edge
Create two files
Author: Fred Jacobowitz
Date: 2025-06-16
 #>
Clear-Host 
write-host "setting up variables"
$remoteSystem="mj"
$remoteFolder = (join-path "C:\Users\Maraj\Onedrive"-ChildPath Documents)
$remoteFile = "MarasServices.txt"
$remoteFullPath = (join-path -path $remoteFolder -ChildPath $remoteFile)

$thisComputerFolder = (join-path -path $env:OneDrive -ChildPath Documents)
$thisComputerFolder = $env:TEMP

$fredsFile = "FredsServices.txt"

$thisComputerMarasFileFullPath = (join-path -Path $thisComputerFolder -ChildPath $remotefile)
$thisComputerFredsFileFullPath = (join-path -Path $thisComputerFolder -ChildPath $fredsFile)

Write-Host "Get-PSSession"
Get-PSSession | Remove-PSSession
# Measure-Command -Expression {$session = New-PSSession -ComputerName mj}
# Can the remote system can accept PowerShell remoting connections?
if (Test-WsMan -ComputerName $remoteSystem) { Write-Host "The remote system $remoteSystem is Online" } 
else { 
    Write-Host "The remote system $remoteSystem is OffLine" 
    throw "The remote system $remoteSystem is OffLine"
}

$session = New-PSSession -ComputerName $remoteSystem
Invoke-Command -session $session -scriptblock { 
    if (Test-Path $using:remoteFullPath ) {remove-item $using:remoteFullPath -Verbose}
}
Invoke-Command -session $session -scriptblock {
    $ServicesRemote=Get-Service -Name * 
    $ServicesRemote | sort-object name | out-file $using:remoteFullPath -Verbose
}
Invoke-Command -session $session -scriptblock {
    get-item $using:remoteFullPath | Select-Object fullname, LastWriteTime
}
Copy-Item -Verbose -FromSession $session -Path $remotefullpath `
    -Destination (Join-path $thisComputerFolder -ChildPath $remoteFile)

if (Test-Path $thisComputerFredsFileFullPath ) {remove-item $thisComputerFredsFileFullPath -Verbose}    
$Services=Get-Service -Name * 
$Services | sort-object name | out-file -FilePath $thisComputerFredsFileFullPath -verbose
Get-ChildItem -path @($thisComputerFredsFileFullPath, $thisComputerMarasFileFullPath) | `
    format-list -Property FullName, LastWriteTime, Length
(Exit-PSSession)
Write-Host "Finis"
<#
Compare-Object `
 -ReferenceObject (get-content $thisComputerFredsFileFullPath) `
 -DifferenceObject (get-content $thisComputerMarasFileFullPath)
#>
<# 
Get-Service | Where-Object {$_.DependentServices} |Format-List -Property Name, DependentServices, @{
        Label="NoOfDependentServices"
        Expression={$_.DependentServices.Count}
    }
 #>