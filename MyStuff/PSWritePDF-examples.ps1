<#
https://evotec.xyz/merging-splitting-and-creating-pdf-files-with-powershell/
Install-Module PSWritePDF -Force


#>
"The value of PSScriptRoot is {0}" -f $psScriptroot
"The value of PSCommandPath is {0}" -f $PSCommandPath
"The value of MyInvocation.PSCommandPath is {0}" -f $MyInvocation.PSCommandPath
read-host "Wait"
push-location $env:HOMEPATH
new-item -ItemType Directory PDFTemp
push-location PDFTemp
if (!$?) {read-host "About to exit"; exit}
New-PDF {
    New-PDFText -Text 'Hello ', 'World' -Font HELVETICA, TIMES_ITALIC -FontColor GRAY, BLUE -FontBold $true, $false, $true
    New-PDFText -Text 'Testing adding text. ', 'Keep in mind that this works like array.' -Font HELVETICA -FontColor RED
    New-PDFText -Text 'This text is going by defaults.', ' This will continue...', ' and we can continue working like that.'
    New-PDFList -Indent 3 {
        New-PDFListItem -Text 'Test'
        New-PDFListItem -Text '2nd'
    }

    New-PDFText -Text 'Hello ', 'World' -Font HELVETICA, TIMES_ITALIC -FontColor GRAY, BLUE -FontBold $true, $false, $true
    New-PDFText -Text 'Testing adding text. ', 'Keep in mind that this works like array.' -Font HELVETICA -FontColor RED
    New-PDFText -Text 'This text is going by defaults.', ' This will continue...', ' and we can continue working like that.'
    New-PDFList -Indent 3 {
        New-PDFListItem -Text 'Test'
        New-PDFListItem -Text '2nd'
    }
} -FilePath "$PSScriptRoot\Example01_Simple.pdf" -Show


