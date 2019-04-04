/* automatic variables
help automatic_variables

$^
$$
$?

$$ | clip
$$ | Set-Clipboard

cls
try{
copy-item irv ellen # doesn't exists
}
catch{
if ($? -eq $false) {"bad:{0}" -f $error[0]}
}
finally {
    'the end'
}


@'
##################################
Project X is a go

Meet Eagle 1 at WP Alpha

Further comms is hereby prohibited
##################################
This message will self destruct in 
5 seconds
'@
5..1| %{$_;Sleep 1;}
"Goodbye"
rm $(.{$MyInvocation.ScriptName})