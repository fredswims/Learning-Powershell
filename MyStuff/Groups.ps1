function GetMySID {
    $target="'"+$env:userdomain+"\"+$env:username+"'"
    $sid=Get-LocalGroupMember -group homeusers|Where-Object name -eq $target |select-object sid
    return $sid
}
function ShowMyGroups {
    $sid=GetMySID
    foreach ($name in get-localGroup) `
    {
        Get-LocalGroupMember -group $name `
        # | where-object SID -eq ($sid).sid.value `
        # | select-object @{ Name = 'Group'; Expression = { $name } }, name, sid, "principalsource", objectClass
    }
}
