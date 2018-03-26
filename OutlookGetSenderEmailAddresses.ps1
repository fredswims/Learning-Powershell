Clear-Host
$Folder = "Deleted Items"
Add-Type -Assembly "Microsoft.Office.Interop.Outlook"
$Outlook = New-Object -ComObject Outlook.Application
$Namespace = $Outlook.GetNameSpace("MAPI")
$NameSpace.Folders.Item(6)
$Email = $NameSpace.Folders.Item(6).Folders.Item($Folder).Items
$Email | Sort-Object SenderEmailAddress -Unique | FT SenderEmailAddress