# https://adamtheautomator.com/how-to-send-email-securely-with-powershell/
# Dependency Loop 
# https://stackoverflow.com/questions/58351619/install-package-dependency-loop-detected-for-package-microsoft-data-sqlite
# I had a terrible time installing the packages.
# Finally did something like this (elevated)



Install-Package -Name 'MailKit' -Source Nuget -scope CurrentUser -SkipDependencies
Install-Package -Name 'MimeKit' -Source Nuget -scope CurrentUser -SkipDependencies
Install-Package -Name 'MimeKit' -Source Nuget -scope CurrentUser
Install-Package -Name 'MailKit' -Source Nuget -scope CurrentUser


# Add-Type -Path "C:\\Program Files\\PackageManagement\\NuGet\\Packages\\MailKit.2.8.0\\lib\\netstandard2.0\\MailKit.dll"
Add-Type -Path "C:\Users\freds_000\AppData\Local\PackageManagement\NuGet\Packages\MailKit.2.8.0\lib\netstandard2.0\MailKit.dll"

# Add-Type -Path "C:\\Program Files\\PackageManagement\\NuGet\\Packages\\MimeKit.2.9.1\\lib\\netstandard2.0\\MimeKit.dll"
Add-Type -Path "C:\Users\freds_000\AppData\Local\PackageManagement\NuGet\Packages\MimeKit.2.9.1\lib\netstandard2.0\MimeKit.dll"

$SMTP     = New-Object MailKit.Net.Smtp.SmtpClient
$Message  = New-Object MimeKit.MimeMessage
$TextPart = [MimeKit.TextPart]::new("plain")
$TextPart.Text = "Holly shit this works just fine"
$MyEmailAtGmail="fred.jacobowitz@gmail.com"
$ToEmail="FredSwims@gmail.com"
$AppSpecificPassword="saapkakeagtwpnjd"

$Message.From.Add($MyEmailAtGmail)
$Message.To.Add($ToEmail)
$Message.Subject = 'Test Message'
$Message.Body    = $TextPart

$SMTP.Connect('smtp.gmail.com', 587, $False)
$SMTP.Authenticate($MyEmailAtGmail, $AppSpecificPassword )

$SMTP.Send($Message)
$SMTP.Disconnect($true)
$SMTP.Dispose()