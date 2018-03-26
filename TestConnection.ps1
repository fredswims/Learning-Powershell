test-connection 192.168.0.1
Test-NetConnection www.google.com -InformationLevel Detailed
test-netconnection -Port 80 -InformationLevel Detailed
test-



$Items = Get-WMIObject -class "Win32_NetworkAdapterConfiguration" -computername . `
 | Where{$_.IpEnabled -Match "True"}
$ipinfo = "IPAddress : " + $Items.IPAddress + "`n"
$ipinfo = $ipinfo + "Subnet : " + $Items.IPSubnet + "`n"
$ipinfo = $ipinfo + "DNS Servers : " + $Items.DNSServerSearchOrder + "`n"
$ipinfo
$items|Get-Member

netstat -an
Test-Connection 131.253.34.233:443


$IP = "google.com"
$port = 80
$client = new-Object Net.Sockets.TcpClient
$Connection = $client.BeginConnect($IP,$port,$null,$null)
$TimeOut = $Connection.AsyncWaitHandle.WaitOne(2000,$false)
if(!$TimeOut)   {$client.Close()
   echo "Port $port is closed on $IP."
     }
else {echo "Port $port up on $IP"}