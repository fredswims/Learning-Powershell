$param = @{
    SmtpServer = 'smtp.gmail.com'
    Port = 587
    UseSsl = $true
    Credential  = 'fred.jacobowitz@gmail.com'
    From = 'fredjacobowitz@gmail.com'
    To = 'fredswims@gmail.com'
    Subject = 'Sending emails through Gmail with Send-MailMessage'
    Body = "Check out the PowerShellMagazine.com website!"
    
}
 
Send-MailMessage @param
<#
http://www.powershellmagazine.com/2012/10/25/pstip-sending-emails-using-your-gmail-account/

Note that if you use two-factor authentication you’ll need to set up and use an Application Specific Password. See https://support.google.com/accounts/answer/185833?hl=en
#>