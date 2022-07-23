# https://stackoverflow.com/questions/716521/listing-files-in-recycle-bin
(New-Object -ComObject Shell.Application).NameSpace(0x0a).Items()
|Select-Object @{n="OriginalLocation";e={$_.ExtendedProperty("{9B174B33-40FF-11D2-A27E-00C04FC30871} 2")}},Name | Out-GridView
# | export-csv -delimiter "\" -path C:\Users\UserName\Desktop\recycleBinFiles.txt -NoTypeInformation

<#
 (gc C:\Users\UserName\Desktop\recycleBinFiles.txt | select-object -Skip 1)
| Where-Object {$_.Replace('"','')}
| set-content C:\Users\UserName\Desktop\recycleBinFiles.txt
 #>