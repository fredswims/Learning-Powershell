$drivers=get-windowsdriver -online
$drivers | gm
$drivers | where {providername -EQ "HP"} | ft providername, driver
$drivers | where providername -eq "HP"
$drivers | where ClassName -eq "Printer"

get-windowsdriver -online | where {$_.providername -EQ "HP"} | ft providername, driver
get-windowsdriver -online | where providername -EQ "STMicroelectronics" | ft providername, driver
get-content C:\Windows\System32\DriverStore\FileRepository\hpvyt12.inf_amd64_2894b4009d8cb4f5\hpvyt12.inf
$ST= get-windowsdriver -online | where providername -EQ "STMicroelectronics" 
