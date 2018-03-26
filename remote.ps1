# https://dennisaa.wordpress.com/2015/09/06/powershell-remoting-across-homegroup-machines/
winrm quickconfig 
Get-service winrm
enable-psremoting -force
winrm s winrm/config/client '@{TrustedHosts="VAIOFRED"}'
$session=New-PSSession -ComputerName "Supercomputer" -Credential Get-Credential



function Do-It() {
 [CmdletBinding()]
 Param()
$session=New-PSSession -ComputerName "VaioFred" -Credential Get-Credential

$session=New-PSSession -ComputerName "Supercomputer" -Credential Get-Credential

 Invoke-Command -Session $session -ScriptBlock {
 $VerbosePreference = $using:VerbosePreference
 Write-Verbose "Test"
 Get-Location
 #Get-ChildItem -Path c:\ -Filter *.txt
 Get-ChildItem -filter *.txt
 }


 Do-it

 for($i=1; $i -le 1; $i++){Write-Host -ForegroundColor Green $i;invoke-command  -Session $session -ScriptBlock {Get-Process}}
 