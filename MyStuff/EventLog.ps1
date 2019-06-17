# Windows Event Log
'Alias EventShutdown'
#function fEventShutdown {get-eventlog -logname system |? {$_.eventid -in 41,1074,6006,6008} }
function fEventShutdown ($arg = 0) {get-winevent -LogName system | where-object {$_.id -in 1, 41, 42, 107, 1074, 6006, 6008 -and $_.timecreated -ge [datetime]::today.Adddays(-$arg)} |select-object timecreated, id, InstanceId, message | sort-object -property timecreated |format-list *;get-date}
set-alias -name ShowShutdownEvent -value fEventShutdown -Option Readonly -force -passthru | format-list
#
#<
https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/who-is-starting-hidden-programs
Who is Starting Hidden Programs?
More
Ever wondered why your CPU load is so high at times, 
or why black windows open up for a split second? 
Then check your event log for program launches, and find out when and what was started automatically.
#>
Function ShowEventLog2 {
Get-EventLog -LogName System -InstanceId 1073748869 |
ForEach-Object {

    [PSCustomObject]@{
    Date = $_.TimeGenerated
    Name = $_.ReplacementStrings[0]
    Path = $_.ReplacementStrings[1]
    StartMode = $_.ReplacementStrings[3]
    User = $_.ReplacementStrings[4]


    }
}  | Out-GridView
}


Get-CimInstance -ClassName Win32_StartupCommand |
  Select-Object -Property Command, Description, User, Location |
  Out-GridView
