$count=0
$Addresses= Get-Content -path "C:\Users\Super Computer\Documents\SlonimContactList.txt"
$addresses | ForEach-Object -Begin {
    Write-Verbose "Begin block" -Verbose
    } -Process {

    #Write-Verbose $_ -Verbose
    #$_

    $Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)
$Mail.To = $_
#


$mail.To
$Mail.Subject = "Dr. Slonim's new email address is aeSlonim@gmail.com"
$Mail.Body ="Please update your records. Dr. Slonim's new email address is aeSlonim@gmail.com"
#$Mail.Send()
$count =$count+1

#Start-Sleep -Seconds 2



    } -End {
        $count
        Write-Verbose "End Block" -Verbose

}





<#
$Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)
$Mail.To = "fredjacobowitz@gmail.com"
$mail.To
$Mail.Subject = "Dr.. Slonim's new email address is AESlonim@gmail.com"
$Mail.Body ="Please update your records. Dr. Slonim's new email address is AESlonim@gmail.com"
$Mail.Send()
#Start-Sleep -Seconds 2
$Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)
$mail.To ="fredswims@gmail.com"
$Mail.Subject = "Dr. Slonim's new email address is AESlonim@gmail.com"
$Mail.Body ="Please update your records. Dr. Slonim's new email address is AESlonim@gmail.com"
$Mail.Send()
#>
#$address=Get-Content -path "C:\Users\freds_000\Documents\test.txt"

#$address |  ForEach {Write-Host $_}
