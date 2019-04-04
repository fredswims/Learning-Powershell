cd $env:OneDrive
cd swimclub/2017
$ClubDirectory=Get-Location

$PSEmailServer = "smtp.gmail.com"
$SMTPPort = 587
$SMTPUsername = "HewlettSwimClub@gmail.com"
$EncryptedPasswordFile =join-path $ClubDirectory "EmailPassword1.txt"

$SecureStringPassword = Get-Content -Path $EncryptedPasswordFile | ConvertTo-SecureString -AsPlainText -Force

$EmailCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SMTPUsername, $SecureStringPassword
#$EmailCredential = New-Object -TypeName System.Management.Automation.PSCredential ($SMTPUsername, $SecureStringPassword)

$MailTo = "fredswims@gmail.com" #******replace this with the real receipient
$MailFrom = "HewlettSwimClub@gmail.com" #this isn't the real deal. It uses the $SMPTUserName and $SecureStringPassword.
$MailSubject="Your Childs Swim Times"
$MailAttachment=join-path $pwd "/zachary Renzin.txt"
$Mailbody="See attachment"

Send-MailMessage -From $MailFrom -To $MailTo -Subject $MailSubject -Body $MailBody -BodyAsHtml -Attachments $MailAttachment -Port $SMTPPort -Credential $EmailCredential -UseSsl


<#
$PSEmailServer = "smtp.gmail.com"
$SMTPPort = 587
$SMTPUsername = "yourgmail"
$EncryptedPasswordFile = "EmailPassword.txt"
$SecureStringPassword = Get-Content -Path $EncryptedPasswordFile | ConvertTo-SecureString
$EmailCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SMTPUsername,$SecureStringPassword
$MailTo = "test@example.com"
$MailFrom = "yourgmail@gmail.com"
$MailSubject="subject"
$Mailbody="body which can include HTML"
$MailAttachment="path\file.txt"

Send-MailMessage -From $MailFrom -To $MailTo -Subject $MailSubject -Body $MailBody -BodyAsHtml -Attachments $MailAttachment -Port $SMTPPort -Credential $EmailCredential -UseSsl
#>