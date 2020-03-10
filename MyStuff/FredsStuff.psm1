function showkeepass {start-process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\KeePass 2.lnk"
}
Export-ModuleMember -Function 'showkeepass'
function ShowMedicalHistory {invoke-item (join-path $env:HOMEPATH\dropbox\private\MedicalSpecial "Medical Conditions.docx")
}
Export-ModuleMember -Function 'ShowMedicalHistory'
function ShowMedicalFolder {invoke-item "$env:HOMEPATH\Google Drive\Medical"
}
Export-ModuleMember -Function 'ShowMedicalFolder'
