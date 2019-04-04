<#
 Format a string expression
http://ss64.com/ps/syntax-f-operator.html
#>
# Create sequential folders like Chapter(n)
1..20 | % {md -WhatIf "Chapter $_"}

#Convert Ascii Code to Character for letters A thru K
65..75 | % { "The first placeholder {0} and a second placeholder {1}" -F $_, [char]$_ }

#Create Directories with suffix A through K. Use Parens to group the formatted expression.
65..75 | % { md -WhatIf -path ("Chapter {0}" -f [char]$_) } 


"fred", "Ellen", "Bea", "Irv" | % { md -Path $_ -WhatIf }

Write-Output Fred Ellen Bea Irv | Set-Content -Path TESTFILE  

Write-Output Fred Ellen Bea Irv | % { md -Path $_ -WhatIf }

$fred=@('Fred', 'Ellen', 'Bea', 'Irv')

#why doesn't this work?
[array]$fred=@"
fred
ellen
bea
irv
mara
pj

"@

$fred.GetType()
$fred | % { md -path $_ -WhatIf}
