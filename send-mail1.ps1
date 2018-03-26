$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$Username = "fredjacobowitz@gmail.com"
$Password = "Oak4leighoak4leigh"

$to = "fredswims@gmail.com"
$cc = "user2@domain.com"
$subject = "Email Subject"
$body = "Insert body text here"
$attachment = "C:\test.txt"

$message = New-Object System.Net.Mail.MailMessage
$message.subject = $subject
$message.body = $body
$message.to.add($to)
#$message.cc.add($cc)
$message.from = $username
#$message.attachments.add($attachment)

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$smtp.send($message)
write-host "Mail Sent"


Send-Mai
Send-MailMessage -From fredjacobowitz@gmail.com -Subject "test message" -To fredswims@gmail.com -Body "this is the body" -Credential fredjacobowitz, Oak4leighoak4leigh -Port 587 -SmtpServer smtp.gmail.com -UseSsllMessage -From fredjacobowitz@gmail.com -Subject "new address" -To fredswims@gmail.com -Body "change me email address to" -Port 587 -SmtpServer smtp.gmail.com -UseSsl
Send-MailMessage -From fredjacobowitz@gmail.com -Subject "test message" -To fredswims@gmail.com -Body "this is the body" -Credential fredjacobowitz, Oak4leighoak4leigh -Port 587 -SmtpServer smtp.gmail.com -UseSsl