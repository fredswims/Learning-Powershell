#http://www.happysysadm.com/2017/01/the-new-way-to-check-computer.html
$fred=Get-ComputerInfo
$fred | Get-Member
$fred.OsUptime
$fred.CsPhysicallyInstalledMemory
get-computerinfo *mem*

<# very slow - working on fix #>
<# https://github.com/PowerShell/PowerShell/issues/3080 #>
<# https://technet.microsoft.com/en-us/library/ff700227.aspx #>
<# 1-run as adminstrator #>
get-service winrm
<# 2-The value of the Status property in the output should be “Running”. #>
<# 3-To configure Windows PowerShell for remoting, type the following command: #> 
Enable-PSRemoting –force
if ( (get-service winrm).status -eq 'Stopped')  {Enable-PSRemoting -force}
else {Write-Host "winrm is already running with status " (get-service winrm).status}
$fred = Get-ComputerInfo *print*
