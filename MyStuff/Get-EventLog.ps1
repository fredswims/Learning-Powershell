#events that shutdown the system.
#remember
[datetime]::now
[datetime]::today
(get-date).date

(get-winevent system).where( {$psitem.timecreated.date -eq (get-date).adddays(-1).date})


$log=get-eventlog -LogName System
foreach($line in $log) {if($line.eventid -in 41,1074,6006,6008){$line.eventid, $line.InstanceId, $line.message }}

#**************
get-winevent -LogName system | where-object      {$_.id -in 1,41,1001,1074,6006,6008 -and $_.timecreated.date -eq (get-date).date} |select-object timecreated, id, InstanceId, message  |format-list *
get-eventlog -LogName System | Where-Object {$_.eventid -in 1,41,1001,1074,6006,6008} | select-object eventid, InstanceId, message | Out-File -FilePath freds.txt

get-eventlog -LogName System -newest 100 -Before (get-date).addhours(-2)
get-eventlog -LogName System -newest 100 -Before (get-date -date "2/2/2019 14:00:00")
get-eventlog -logname *
get-eventlog -logname  application
get-eventlog -logname application -newest 10
get-eventlog -logname application -newest 10 | format-list -property *
get-eventlog -logname application -entrytype warning -newest 10
get-winevent -newest 10 -logname application
get-winevent -listlog *
get-winevent -listlog Setup | format-list -Property *
(Get-WinEvent -ListLog Application).ProviderNames

#system crashed
get-winevent -LogName system | where-object  {$_.id -eq 41 } |select-object * |Out-File -FilePath ./freds.txt
get-winevent -LogName system | where-object  {$_.id -in 41,1074,6006,6008,1001 } |select-object * |Out-File -FilePath ./freds.txt


get-eventlog -LogName System | Where-Object {$_.eventid -eq 41} | select-object eventid, InstanceId, message -first 1 |format-list *| Out-File -FilePath freds.txt
get-winevent -LogName system | where-object  {$_.id -eq 41 } |select-object id, InstanceId, message -First 1 |format-list * |Out-File -FilePath ./freds.txt -Append
get-eventlog -LogName System | Where-Object {$_.eventid -eq 41} | select-object * -first 1 | Out-File -FilePath freds.txt
get-winevent -LogName system | where-object  {$_.id -eq 41 } |select-object * -First 1 |Out-File -FilePath ./freds.txt -Append


#So all you have to do to get the Application Events for the last 24 hours (not two days ago) is:
$24HoursAgo = [DateTime]::Now.AddHours(-24)
$Events = Get-Eventlog -New 1024 Application | Where-Object {$24HoursAgo -le $_.TimeWritten}
$Events |Group-Object EntryType,Source |Format-Table Count,Name -Auto
