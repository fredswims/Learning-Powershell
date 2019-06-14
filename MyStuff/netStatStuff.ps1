<#
find all the network connection created in this hour.
#>
Get-NetTCPConnection |? CreationTime  -gt (get-date).date.AddHours((get-date).hour) `
|sort-object creationtime `
|Select-Object localport, remoteport,creationtime,OwningProcess, `
@{name="Process";expression={(get-process -id $_.OwningProcess).name}} 
