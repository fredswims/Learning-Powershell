Clear-Host
$events=Get-EventLog -LogName System -Newest 1000
# $events| ForEach-Object -process {if($_.message -like "*ossible detection of CVE:*") {write-host }}  
$events| ForEach-Object -begin {get-date;$counter=0} -process `
{if($_.message -like "*ossible detection of CVE:*") `
 {write-host $counter;write-host ("ID:{0} - {1}" -f $_.eventid, $_.message);$events[$counter]|format-list *}  ;$counter++}  

<# 
function writep {
 for ($i = 0; $i -le 100; $i += 10) {
    # This loop simulates a task and displays the progress bar
    Write-Progress -Activity "Simulated Task" `
                   -Status "Processing: $i% complete" `
                   -PercentComplete $i `
                   -ProgressAction Continue
    Start-Sleep -Seconds 5}
 }
 #>