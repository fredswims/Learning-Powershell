$count=0
$Addresses= Get-Content -path "C:\Users\Super Computer\Documents\ArchiveAddress.txt"
$addresses | ForEach-Object -Begin {
    Write-Verbose "Begin block" -Verbose
    }    -Process {
        $address=$_.trim()
 
If ($address -as [System.Net.Mail.MailAddress])
{
$Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)
$Mail.To = $address
#
$mail.To
$Mail.Subject = "Dr. Slonim's new email address is aeSlonim@gmail.com"
$Mail.Body ="Please update your records. Dr. Slonim's new email address is aeSlonim@gmail.com"
$Mail.Send()
$count =$count+1
Start-Sleep  -Milliseconds 250
}
else {Write-verbose  "$address is a bad email address" -DEBUG
#break
}

    } -End {
        $count
        Write-Verbose "End Block" -Verbose
}

