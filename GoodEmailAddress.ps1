Function Global:Test-Email {
Param(
[String]$Message = "Wrong#gmail.com"
        )
Begin {
Clear-Host
       }
Process {
If ($Message -As [System.Net.Mail.MailAddress])
        {
          Write-Host "$Message is a good email address"
         }
else
        {
          Write-Host "$Message is a bad email address"
        }
      } # End of Process 
} # End of function

Test-Email