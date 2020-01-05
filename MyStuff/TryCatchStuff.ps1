<#

fred.jacobowitz@gmail.com
Jan 1, 2020, 2:58 AM (2 days ago)
to FredPowerShell

https://www.vexasoft.com/blogs/powershell/7255220-powershell-tutorial-try-catch-finally-and-error-handling-in-powershell

use a combination of -verbose (to see when a command runs w/o error) and catch{show where the error occurred.}

pwsh 7 preview
$ErrorActionPreference = "Stop"
Windows Terminal

try {remove-item -verbose  -path "fred.out"} catch{"catch block";get-error} finally{"wow"}

or replace get-error with
$ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Send-MailMessage -From ExpensesBot@MyCompany.Com -To WinAdmin@MyCompany.Com -Subject "HR File Read Failed!" -SmtpServer EXCH01.AD.MyCompany.Com -Body "We failed to read file $FailedItem. The error message was $ErrorMessage"
    Break
Windows Terminal
try {remove-item -verbose -ErrorAction "STOP" -path "fred.out"} catch{"catch block";$_.exception.message;$_.
exception.itemname;$_.exception.source;$_.exception | gm;$_.exception|select-object *} finally{"wow"}

In powershell
try {copy-item -verbose -ErrorAction "STOP" -path "fred.out" ellen.out} catch{"catch block"; $error[0]} finally{"wow"}

#>
#>
"The value of ErrorActionPreference is {0}" -f $ErrorActionPreference
#$ErrorActionPreference  ="STOP"
"The value of ErrorActionPreference is {0}" -f $ErrorActionPreference
$Error.Clear()
try {
    set-location $HOME
    $file="CrazyHourse.txt"
    if (!(test-path -path $file)) {
        "crazyhorse"|out-file $file
    }
    copy-item "$file" "$file.copy" -verbose -ErrorAction "Stop"
}
catch {
    write-warning "catch block begins"
    if ($PSVersionTable.PSVersion -like "7*"){
        #get-error
    }
    $error[0]
    write-warning "catch block ends"
}
Finally {
"Completed with {0} errors." -f $error.count
write-warning "Finis"
}
