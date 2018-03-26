param(
[string]$filename= $(Read-host "Specify input cvs filename")

foreach ($ellen in $fred) {
if($ellen.swimmer -like "Zach*")  
}
}

foreach($element in $irv){$c = $c + " " + [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($element))};$c
$ellen=$fred.tochararray() 
$c="";foreach($element in $ellen[14..16]){$c = $c + [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($element))};$c
[system.convert]::touint32($ellen[5])
$fred.EndsWith("`r`n")

$noah=@"
get-childitem
;
ls *;
"@
$noah = @"
this is some 
multiple line 
text!
"@
$string1=@"
fred
ellen
bea
irv
"@
$c="";foreach($element in (Get-Content -raw -path "ellen1.txt").ToCharArray()){$c = $c + "|" + [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($element))};$c
(history -count 1).CommandLine

$hearstring=@"
fred
ellen
bea
irv
"@
$hearstring=@"
get-childitem
$pwd
get-process
"@



Sort-Object -Property BasePriority | Format-Table -GroupBy basepriority -wrap | more

$fred | select-string -List "zach" | Sort-Object -Property Meet | format-table -groupby Meet
foreach ($ellen in $fred) {if($ellen.swimmer -like "Zach*"){$ellen}}

$fred | Sort-Object -Property swimmer |format-table -GroupBy swimmer
$mylast=get-history -id (get-history).count


#voila********************
$AllEvents =Import-Excel -Path .\powershellboysevents.xlsx -HeaderRow 1 
#a list of events by swimmer
$AllEvents | Sort-Object -Property swimmer, event, time |format-table -GroupBy swimmer -Property Event, meet, @{name="Time"; expression={$_.ftime}}


#get a list of names
$Names = @()
$allevents | Sort-Object -Property "Swimmer" -unique | foreach {$Names += $_.swimmer}
#end

#events for a swimmer
$aSplat=@{name="Time"; expression={$_.ftime}}
$SwimmerName="Zachary Renzin"
$ThisSwimmer=$AllEvents |Where-Object -Property Swimmer -EQ $SwimmerName
#$sorted =$thisSwimmer |Sort-Object -Property event, time 
#$sorted |ft -Property swimmer, event, meet, @{name="Time"; expression={$_.ftime}}|Out-File -FilePath .\$SwimmerName.txt 
$thisSwimmer |Sort-Object -Property event, time |
ft -Property swimmer, event, meet, $aSplat |
Out-File -FilePath .\$SwimmerName.txt 
#end

foreach ($SwimmerName in $names){
$ThisSwimmer=$AllEvents |Where-Object -Property Swimmer -EQ $SwimmerName
$sorted =$thisSwimmer |Sort-Object -Property event, time 
$sorted |ft -Property swimmer, event, meet, $asplat |Out-File -FilePath .\$SwimmerName.txt -CONFIRM
}

foreach ($SwimmerName in $names){
$AllEvents |Where-Object -Property Swimmer -EQ $SwimmerName | 
Sort-Object -Property event, time |
ft -Property swimmer, event, meet, $aSplat |Out-File -FilePath .\$SwimmerName.txt
}