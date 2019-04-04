#convert an excel date to a string
[datetime]::FromOADate($exceldate).toshortdatestring()

#The best way to match dates for a particular day.
(get-date).date # returns Monday, February 11, 2019 12:00:00 AM
#You don't have to set the hour, minutes, seconds, milliseconds, etc.
(get-date).date -eq [datetime]::Today
get-date  -eq [datetime]::now

# Normalize the source and the filter side of the expression.
(get-winevent system).where( {$psitem.timecreated.date -eq (get-date).adddays(-1).date})
Get-Childitem $dir -recurse | Where-Object { $_.LastWriteTime.Date -eq (Get-Date).Date.Adddays(-1)}


#great article https://blogs.msdn.microsoft.com/powershell/2006/09/17/the-wonders-of-date-math-using-windows-powershell/
[dateTime]::Now
# versus
[datetime]::Today
#Here is how you find out which processes have been started in the last hour:
$1HourAgo = [DateTime]::Now.AddHours(-1)
Get-Process |where-object {$_.StartTime -ge $1HourAgo}

#So all you have to do to get the Application Events for the last 24 hours is:
$24HoursAgo = [DateTime]::Now.AddHours(-24)
$Events = Get-Eventlog -New 1024 Application | Where-Object {$24HoursAgo -le $_.TimeWritten}
$Events |Group-Object EntryType,Source |Format-Table Count,Name -Auto

$pig = Get-Date
$pig | Select-Object * # see all the properties.

#Get all of TODAY  (get-date).ToShortDateString() -> 4/11/2017 as a string
# so the following is string comparison.
Get-ChildItem | Where-Object {$_.LastWriteTime.ToShortDateString() -eq (get-date).ToShortDateString()}
Get-ChildItem | Where-Object {$_.CreationTime.ToShortDateString() -eq (get-date).ToShortDateString()}
#Everything from today
get-childitem * |?{$_.LastWriteTime -gt (get-date -hour 0 -minute 0 -second 0).addseconds(-1)}
#you can also do this to get 00:00:00
$startdate=get-date -format d # string
$startdate=[datetime]$startdate # cast string to datetime
$startdate
$startdate=$startdate.AddDays(-10) #so many days ago.
Get-ChildItem |Where-Object {$_.lastaccesstime -le $startdate}

# then use

# earlier than today. 4/10/2017 12:00 AM
Get-ChildItem |Where-Object {$_.lastaccesstime -le (get-date -format g -hour 0 -minute 0 -Second 0 -Millisecond 0)}

# earlier than today  Monday, April 10, 2017
Get-ChildItem |Where-Object {$_.lastaccesstime.date -lt (get-date -DisplayHint date)}
#  Thursday, March 30, 2017 12:00:00 AM
Get-ChildItem |Where-Object {$_.lastWritetime.date -lt ((get-date -DisplayHint Date -hour 0 -minute 0 -Second 0 -Millisecond 0).AddDays(-11))}

# Sunday, April 9, 2017 10:09:03 PM
Get-ChildItem |Where-Object {$_.lastaccesstime.date -lt (get-date).AddDays(-1)}

#  2017-04-10
Get-ChildItem |Where-Object {$_.lastWritetime.date -eq (get-date -Format yyy-MM-dd)}
# 04/10/2017 ****************** best  entire day to the millisecond.
Get-ChildItem |Where-Object {$_.lastWritetime.date -like "*$(get-date -Format MM/dd/yyyy)*"}

$days = -10
$ThisMonth = (get-date).AddDays($days).month
$ThisYear = (get-date).AddDays($days).year
$ThisDay = (get-date).AddDays($days).day
$ThisDate = [string]$ThisMonth + "/" + [string]$ThisDay + "/" + [string]$ThisYear
$ThisDate
Get-ChildItem |Where-Object {$_.lastWritetime.date -like "*" + $ThisDate + "*"}

$days = -10
$TargetDate = (get-date).AddDays($days)
$ThisMonth = $TargetDate.Month
$ThisYear = $TargetDate.Year
$ThisDay = $TargetDate.day
$ThisDate = [string]$ThisMonth + "/" + [string]$ThisDay + "/" + [string]$ThisYear
$ThisDate
Get-ChildItem |Where-Object {$_.lastWritetime.date -like "*" + $ThisDate + "*"}

# for a specific date so many days a
$days = -100
$TargetDate = (get-date).AddDays($days)
$ThisMonth = $TargetDate.Month
$ThisYear = $TargetDate.Year
$ThisDay = $TargetDate.day
$ThisDate = [string]($TargetDate.Month) + "/" + [string]($TargetDate.Day) + "/" + [string]($TargetDate.Year)
$ThisDate
Get-ChildItem |Where-Object {$_.lastWritetime.date -like "*" + $ThisDate + "*"}


#Different Tactic for specific date
Get-ChildItem | Where-Object {
    $myTemp = $_.LastAccessTime
    $mytemp.Year -eq 2017 -and $mytemp.Month -lt 3 -and $myTemp.Day -ge 1

    # ***********  Then substitue get-date parts for constants used in expression above.
    $days = -1
    $TargetDate = (get-date).AddDays($days)
    Get-ChildItem | Where-Object {
        $myTemp = $_.LastAccessTime
        $mytemp.Year -eq $TargetDate.Year -and $mytemp.Month -eq $targetDate.Month -and $myTemp.Day -eq $TargetDate.day
    }


    Get-ChildItem -recurse | Where-Object {
        $myTemp = $_.LastWriteTime
        ($mytemp.Year -eq 2017 -and $mytemp.Month -lt 3 -and $myTemp.Day -ge 1) -or ($mytemp.Year -eq 2016 -and $myTemp.Month -eq 4 )
    } |Sort-Object -Property lastwritetime| Format-Table lastwritetime, fullname

    Get-ChildItem | Where-Object {$_.LastWriteTime.ToShortDateString() -eq (get-date).ToShortDateString()}

    $fred = Get-EventLog SYSTEM -AFormat-Tableer (get-date).adddays(-10)
    $fred|Get-Member
    $fred | Format-Table entryType, message
    $fred | Where-Object {$_.EntryType -eq "Warning"}


$profile
