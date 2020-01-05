#this looks for a specific RecordId as part of the where-object
get-winevent -LogName Microsoft-Windows-Powershell/Operational -MaxEvents 1000|Where-Object {$psitem.recordId -eq 62680}
#can you add recordId into the -FilterHashtable? No, see https://docs.microsoft.com/en-us/previous-versions/powershell/module/Microsoft.PowerShell.Diagnostics/Get-WinEvent?view=powershell-4.0
Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-Powershell/Operational';  Id='4104';RecordId ='62680' }
#Pretty weird that you can't search on RecordId.
Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-Powershell/Operational';  Id='4104';StartTime ='1/4/2020 5:20:48 PM'; EndTime ='1/4/2020 5:20:49 PM' }|format-list recordId,message
$myEvent=Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-Powershell/Operational';  Id='4104';StartTime ='1/4/2020 5:20:48 PM'; EndTime ='1/4/2020 5:20:49 PM' }
Get-WinEvent -FilterHashtable @{ LogName='Microsoft-Windows-Powershell/Operational';  Id='4104';StartTime ='1/4/2020 5:20:48 PM'; EndTime ='1/4/2020 5:20:49 PM' } -Verbose
# wait there is hope
# https://evotec.xyz/powershell-everything-you-wanted-to-know-about-event-logs/
$XML = @'
<QueryList>
    <Query Id="0" Path="microsoft-windows-powershell/operational">
        <Select Path="microsoft-windows-powershell/operational"> *[System[EventRecordID=62680]]
        </Select>
    </Query>
</QueryList>
'@

$Time = Start-TimeLog
$Events = Get-WinEvent -FilterXML $XML
$Events|Select-Object RecordId, Message
# but it looks like it truncated Message.