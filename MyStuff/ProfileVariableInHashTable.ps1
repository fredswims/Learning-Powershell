$hString = @'
remove-variable hash
$hash=@{}
$hash.add('a','Profile.CurrentUserCurrentHost')
$hash.add('b',(Invoke-Expression ('$'+$hash.a)) )
'@
invoke-expression $hString
$hash.Values

#Wont run as a single line because $hash.a isn't availablel when assigning element 'b'
Remove-Variable hash
$hash=@{}
#$hash=@{'a'='Profile.CurrentUserAllHosts';'b'=$Profile.CurrentUserAllHosts}
#$hash=@{'a'='Profile.CurrentUserAllHosts';'b'=(Invoke-Expression $('$'+$hash.a))}
$hash=@{'a'='Profile.CurrentUserAllHosts';'b'=(Invoke-Expression ('$'+$hash.a))}
$hash

# inline version
remove-variable hash
$hash=@{}
$hash.add('a','Profile.CurrentUserCurrentHost')
$hash.add('b',(Invoke-Expression ('$'+$hash.a)) )
$hash

# for a simple variable
$AString=@'
remove-variable hash
$fred="ellen"
$hash=@{}
$hash.add('a','fred')
$hash.add('b', (get-variable -valueonly $hash.a))
'@

invoke-expression $AString
$hash

# This fails
$AString=@'
remove-variable hash
$fred="ellen"
$hash=@{}
$hash.add('a','Profile.CurrentUserCurrentHost')
$hash.add('b', (get-variable -valueonly $hash.a))
'@
invoke-expression $AString
$hash

