<#
With Outbound Port Scanner you can determine, 
which outbound ports aren’t blocked by your firewall.

Outbound Port Scanner
port-scan.ps1
http://power-shell.com/2015/powershell-scripts/outbound-port-scanner/
This PowerShell tool is extremely helpful when you are behind firewall, and you are running service on a remote machine that you want to connect to it, but you are unable to find out which ports can be accessed and to which port to bind the service.

The Code:
You may want to select a port range (line 2).
The destination host listens on all TCP ports from 1 to 65535.


#>
#Select port range
$portrange = 20..1000
#Open connection for each port from the range
Foreach ($p in $portrange)
{
$Socket = New-Object Net.Sockets.TcpClient      
$ErrorActionPreference = 'SilentlyContinue'
#Connect on the given port
$Socket.Connect("178.33.250.62", $p) #*********** set IP address to service
#Determine if the connection is established
if ($Socket.Connected) {
Write-Host "Outbound port $p is open." -ForegroundColor Green
$Socket.Close()
}
else {
Write-Host "Outbound port $p is closed or filtered."}
} #end foreach