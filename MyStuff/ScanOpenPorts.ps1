#https://techcommunity.microsoft.com/t5/ITOps-Talk-Blog/PowerShell-Basics-How-to-Scan-Open-Ports-Within-a-Network/ba-p/924149
#PowerShell Basics: How to Scan Open Ports Within a Network$port =80 # like 80 (enter port value)
$network =(192.168.86) #“enter network value” #like (192.168.0)
$range = 1..254
$ErrorActionPreference= ‘silentlycontinue’
$(Foreach ($add in $range)
{ $ip = “{0}.{1}” –F $network,$add
Write-Progress “Scanning Network” $ip -PercentComplete (($add/$range.Count)*100)
If(Test-Connection –BufferSize 32 –Count 1 –quiet –ComputerName $ip)
{ $socket = new-object System.Net.Sockets.TcpClient($ip, $port)
If($socket.Connected) { “$ip port $port open”
$socket.Close() }
else { “$ip port $port not open ” }
}
}) | Out-File C:\reports\portscan.csv