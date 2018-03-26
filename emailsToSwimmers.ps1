<#
Create time-file for each swimmer.
Send them an email using the file as an attachment.
2018-02-26 FAJ
#>

cd $env:OneDrive
cd swimclub/2017
$ClubDirectory=Get-Location

#voila********************
#assign calculated properties
$TimeSplat=@{name="Time"; expression={$_.ftime}}
$MeetSplat=@{name="Meet"; expression={($_.meet).substring(0,15)}}
$HeatSplat=@{name="Heat"; expression={($_.heat).substring(1)}}

#import the current version of this file: \PowershellEvents.xlsx
$AllEvents=""
$AllEvents =Import-Excel -Path .\PowershellEvents.xlsx -HeaderRow 1 -sheet "Sheet1"

#a list of events by swimmer
write-host "Number of events $($AllEvents.Count)"
$AllEvents | Sort-Object -Property swimmer, event, time |
format-table -GroupBy swimmer -Property $TimeSplat, Event, $MeetSplat,heat| Out-File -FilePath .\"AllTimesBySwimmer.txt" -Force 


#get a list of names
$Names = @()
$allevents | Sort-Object -Property "Swimmer" -unique | foreach {$Names += $_.swimmer}
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
cd SwimmerEvents
foreach ($SwimmerName in $names){
$AllEvents |Where-Object -Property Swimmer -EQ $SwimmerName | 
Sort-Object -Property event, time |
ft -Property  $TimeSplat, event, $MeetSplat, $HeatSplat -AutoSize|Out-File -FilePath .\$SwimmerName.txt -Force
(get-content -path .\$SwimmerName.txt) | foreach-object { "$_`n"} |Set-Content -path .\$SwimmerName.txt
}
write-host "Number of files: "  (get-item *.txt).count
Get-Item * | ft name, CreationTime, LastWriteTime

#Email procedure block begins here.
cd $env:OneDrive
cd swimclub/2017/SwimmerEvents
$thisLocation=Get-Location
$EmailCount=0
foreach ($SwimmerName in $names){
if ($SwimmerName -like "Lane*")  {
    write-host "Skipping $swimmername"
    }
else {
#for Hewlett Swim Club account go to My Account and select Apps with Account Access and turn on Allow less secure apps
#turn it off when you finish.
#if using my account get a special app password.Then go back and disable it.
#In either case the password goes in a file referenced by $EncryptedPasswordFile
$thisEmailAddr=""
$thisEmailAddr=$AllEvents |Where-Object -Property Swimmer -EQ $SwimmerName | Select-Object -property emailAddr -First 1
$PSEmailServer = "smtp.gmail.com"
$SMTPPort = 587
$SMTPUsername = "HewlettSwimClub@gmail.com" 
$EncryptedPasswordFile =join-path $ClubDirectory "EmailPassword1.txt"
$SecureStringPassword = Get-Content -Path $EncryptedPasswordFile | ConvertTo-SecureString -AsPlainText -Force

$EmailCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SMTPUsername, $SecureStringPassword
#$EmailCredential = New-Object -TypeName System.Management.Automation.PSCredential ($SMTPUsername, $SecureStringPassword)

$MailTo = $thisEmailAddr.emailAddr
$MailFrom = "HewlettSwimClub@gmail.com"
$MailSubject="Swim Times for $SwimmerName" 
$MailAttachment=join-path $pwd "/$SwimmerName.txt"
$Mailbody="See attachment"
write-host "Mail to $MailTo"
write-host "With Subject $MailSubject"
write-host "With Attachment $MailAttachment"
Send-MailMessage -From $MailFrom -To $MailTo -Subject $MailSubject -Body $MailBody -BodyAsHtml -Attachments $MailAttachment -Port $SMTPPort -Credential $EmailCredential -UseSsl
$EmailCount ++
$EmailCredential=$null
sleep -Seconds 1
#https://l.facebook.com/l.php?u=https%3A%2F%2Fmyaccount.google.com%2Fapppasswords&h=ATMI3QwBcWhefoF4aXylC1e4SaTAe0e25b_n-G7cWvcxnEcuU0Fl0H9kiVkISnscMufWcTANKohrdBpB-j1sF-w1srWlJwdX4VLfpc5aiTmyJUEX
}
}
write-host "Email sent $EmailCount"


<#
Get the email addresses from othe Access Data Base
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
$oCmd  = New-Object System.Data.OleDb.OleDbCommand($strQuery, $oConn)
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