<#
Create time-file for each swimmer.
Send them an email using the file as an attachment.
Select #region TimeFiles and run selection.
But first you have to create  \PowershellEvents.xlsx.
It contains two sheets. Refer to the README tab in the file.
The first sheet comes from the SwimRiteNow.xlsx Boys (Girls) events.
The second sheet contains the email addresse extracted from the database using a query.
The plan is to install Ofice 365 and user the MS Access DLLs.
2018-02-26 FAJ
#>
#https://github.com/dfinke/ImportExcel
#Install-Module -Name ImportExcel -Scope CurrentUser -Force
#region TimeFiles
Set-Location $env:OneDrive
Set-Location swimclub/2018
$ClubDirectory = Get-Location
$SwimmerEventsDir = "SwimmerEvents"
if (test-path $SwimmerEventsDir) {} else {new-item -ItemType Directory -Name $SwimmerEventsDir}

#voila********************
#assign calculated properties
$TimeSplat = @{name = "Time"; expression = {$_.ftime}}
$MeetSplat = @{name = "Meet"; expression = {($_.meet).substring(0, 20)}}
$HeatSplat = @{name = "Heat"; expression = {($_.heat).substring(1)}}
$SwimmerMeetSplat = @{name = "SwimmerMeat"; expression = { + $_Swimmer + " " + ($_.meet).substring(0, 20)}}
#import the current version of this file: \PowershellEvents.xlsx
$AllEvents = ""
cls
$AllEvents = Import-Excel -Path .\PowershellEvents.xlsx -HeaderRow 1 -sheet "Boys"

#a list of events by swimmer
write-host "Number of events $($AllEvents.Count)"
$AllEvents | Sort-Object -Property swimmer, event, time |
    Format-Table -Autosize -GroupBy swimmer -Property $TimeSplat, Event, heat, meet| Out-File -FilePath .\"AllTimesBySwimmer.txt" -Force

#Use this section for finding swimmers elibible for the Champs.
#For the final run, prep the data with only dual meets
#Swimmers had to be in at least two meats since we have four dual meets.
#Lane 5 unofficial swims in official heats count toward eligibility, but unoffical heats do not; the 8&U unoffical heats; U1, U2, U5 etc.
#Get rid of Swimmers like Lane 1 and Lane 2, etc
#Currently, we want to print all the meets the swimmers are in so we can tell them why the are or are not eligbile for Champs.
#$AllEvents | Sort-Object -Property swimmer, meet,event, time | Format-Table -Autosize -GroupBy swimmer -Property meet, $TimeSplat, Event, heat| Out-File -FilePath .\"AllTimesBySwimmerMeet.txt" -Force
#$AllEvents | Sort-Object -Property $SwimmerMeetSplat -unique meet,event, time | Format-Table -Autosize -GroupBy swimmer -Property meet, $TimeSplat, Event, heat| Out-File -FilePath .\"AllTimesBySwimmerMeet.txt" -Force
#AllEvents | Sort-Object -Property Swimmer,Meet -Unique | Format-Table Swimmer, Meet,Event, heat | more
($Allevents).where( {($_.heat -notlike "'U*") -and ($_.swimmer.substring(0, 6) -notin ("Lane 1", "Lane 2", "Lane 3", "Lane 4", "Lane 5", "Lane 6"))} ) | `
    Sort-Object -Property "Age Group", Swimmer, Meet -Unique | `
    Format-Table -autosize -groupby "Age Group" -property Swimmer, Meet, Event, $TimeSplat, heat | `
    Out-File -FilePath .\"EligibleForChamps.txt" -Force

The names are sorted by first name, last name. I can group them by age group, .... etc.

#Export to excel
$ToExcel=($Allevents).where( {($_.heat -notlike "'U*") -and ($_.swimmer.substring(0, 6) -notin ("Lane 1", "Lane 2", "Lane 3", "Lane 4", "Lane 5", "Lane 6"))} ) | `
Sort-Object -Property "Age Group", Swimmer, Meet -Unique

$ExcelParams = @{
    Path    = 'Excel.xlsx'
    Show    = $true
    Verbose = $true
}
Remove-Item -Path $ExcelParams.Path -Force -EA Ignore
$ToExcel | Select-Object -Property "Age Group",Swimmer, Meet, Event, $TimeSplat, Heat | Export-Excel @ExcelParams

#get a list of names
$Names = @()
$allevents | Sort-Object -Property "Swimmer" -unique | ForEach-Object {$Names += $_.swimmer}
write-host "number of swimmers $($names.count)"

#Setup splat for Calculated Property; give the column the name Time.

#test a single name
<#
$SwimmerName="Zachary Renzin"
$ThisSwimmer=$AllEvents |Where-Object -Property Swimmer -EQ $SwimmerName
$ThisSwimmer |Sort-Object -Property event, time |ft -Property $TimeSplat,  event, $MeetSplat, $HeatSplat |Out-File -FilePath .\$SwimmerName.txt -force

#>


#for each swimmer
<#use block below
cd SwimmerEvents
foreach ($SwimmerName in $names){
$ThisSwimmer=$AllEvents |Where-Object -Property Swimmer -EQ $SwimmerName
$sorted =$thisSwimmer |Sort-Object -Property event, time
$sorted |ft -Property event, meet, $TimeSplat, heat |Out-File -FilePath .\$SwimmerName.txt -force
}
#>

#for each swimmer

Set-Location $SwimmerEventsDir
foreach ($SwimmerName in $names) {
    $AllEvents |Where-Object -Property Swimmer -EQ $SwimmerName |
        Sort-Object -Property event, time |
        Format-Table -Property  $TimeSplat, event, $HeatSplat, meet  -AutoSize|Out-File -FilePath .\$SwimmerName.txt -Force
    (get-content -path .\$SwimmerName.txt) | foreach-object { "$_`n"} |Set-Content -path .\$SwimmerName.txt
}
write-host "Number of files: "  (get-item *.txt).count
Get-Item * | ft name, CreationTime, LastWriteTime
#endregion TimeFiles

#region Emails
#Email procedure block begins here.
Set-Location $env:OneDrive
Set-Location swimclub/2017/SwimmerEvents
$thisLocation = Get-Location
$EmailCount = 0
foreach ($SwimmerName in $names) {
    if ($SwimmerName -like "Lane*") {
        write-host "Skipping $swimmername"
    }
    else {
        #for Hewlett Swim Club account go to My Account and select Apps with Account Access and turn on Allow less secure apps
        #turn it off when you finish.
        #if using my account get a special app password.Then go back and disable it.
        #In either case the password goes in a file referenced by $EncryptedPasswordFile
        $thisEmailAddr = ""
        $thisEmailAddr = $AllEvents |Where-Object -Property Swimmer -EQ $SwimmerName | Select-Object -property emailAddr -First 1
        $PSEmailServer = "smtp.gmail.com"
        $SMTPPort = 587
        $SMTPUsername = "HewlettSwimClub@gmail.com"
        $EncryptedPasswordFile = join-path $ClubDirectory "EmailPassword1.txt"
        $SecureStringPassword = Get-Content -Path $EncryptedPasswordFile | ConvertTo-SecureString -AsPlainText -Force

        $EmailCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SMTPUsername, $SecureStringPassword
        #$EmailCredential = New-Object -TypeName System.Management.Automation.PSCredential ($SMTPUsername, $SecureStringPassword)

        $MailTo = $thisEmailAddr.emailAddr
        $MailFrom = "HewlettSwimClub@gmail.com"
        $MailSubject = "Swim Times for $SwimmerName"
        $MailAttachment = join-path $pwd "/$SwimmerName.txt"
        $Mailbody = "See attachment"
        write-host "Mail to $MailTo"
        write-host "With Subject $MailSubject"
        write-host "With Attachment $MailAttachment"
        Send-MailMessage -From $MailFrom -To $MailTo -Subject $MailSubject -Body $MailBody -BodyAsHtml -Attachments $MailAttachment -Port $SMTPPort -Credential $EmailCredential -UseSsl
        $EmailCount ++
        $EmailCredential = $null
        sleep -Seconds 1
        #https://l.facebook.com/l.php?u=https%3A%2F%2Fmyaccount.google.com%2Fapppasswords&h=ATMI3QwBcWhefoF4aXylC1e4SaTAe0e25b_n-G7cWvcxnEcuU0Fl0H9kiVkISnscMufWcTANKohrdBpB-j1sF-w1srWlJwdX4VLfpc5aiTmyJUEX
    }
}
write-host "Email sent $EmailCount"
#endregion Emails

<# Alternate
Get the email addresses from othe Access Data Base
The problem here is DLL hell.
As of Spring 2017 Super Computer is running 64 bit version of Office 2010
but even so I could only get the 32 bit DLL to work.
I had to make an MDB copy of the database and operate against it.
Actually, I am not certain if I ever got it to run!
https://blogs.technet.microsoft.com/heyscriptingguy/2009/08/13/hey-scripting-guy-can-i-query-a-microsoft-access-database-with-a-windows-powershell-script/
https://technet.microsoft.com/en-us/library/2009.05.scriptingguys.aspx
#>

Set-Location $env:onedrive\swimclub\2017

$strQuery = "SELECT
 [aqRoster].FirstName ,[aqRoster].[Lastname] ,[aqRoster].[email]
 FROM [aqRoster]
 ORDER BY [Lastname] DESC ;"

$strConn = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=C:\Users\freds_000\OneDrive\swimclub\2017\SwimRiteNow.mdb"
#$strConn = "Provider=Microsoft.ACE.OLEDB.12.0; Data Source=C:\Users\freds_000\OneDrive\swimclub\2017\SwimRiteNow.mdb"
$oConn = New-Object System.Data.OleDb.OleDbConnection $strConn
$oCmd = New-Object System.Data.OleDb.OleDbCommand($strQuery, $oConn)
$oConn.Open()
$oReader = $oCmd.ExecuteReader()

[void]$oReader.Read()
do {
    $oJumper = New-Object PSObject
    $oJumper | Add-Member NoteProperty FirstName     $oReader[0]
    $oJumper | Add-Member NoteProperty LastName  $oReader[1]
    $oJumper | Add-Member NoteProperty email    $oReader[2]
    $oJumper
}while ([void]$oReader.Read())
$oReader.Close()
$oConn.Close()




$path = "SwimRiteNow.accdb"
$adOpenStatic = 3
$adLockOptimistic = 3

$cn = new-object -comobject ADODB.Connection
$rs = new-object -comobject ADODB.Recordset

$cn.Open("Provider = Microsoft.Jet.OLEDB.4.0;Data Source = C:\Users\freds_000\OneDrive\swimclub\2017\SwimRiteNow.accdb")
$rs.Open("SELECT TOP 1 [aqRoster].[FirstName],
  [aqRoster].[lastname], [aqRoster].[email]
  FROM [aqRoster]
  ORDER BY [aqRoster].[LastName]",
    $cn, $adOpenStatic, $adLockOptimistic)

$rs.MoveFirst()
Write-host "The winner will likely be " $rs.Fields.Item("FirstName").Value
