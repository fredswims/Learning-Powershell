# I am having a problem with PsReadline beta and F2
$dirs=$env:psmodulepath -split ";"
$dir=$dirs[0]
$module="psreadline"
if (test-path (join-path $dir "x$($module)") ) {
    rename-item (join-path $dir "x$($module)") -NewName (join-path $dir $module) -Confirm 
} 
else { rename-item (join-path $dir $module) -NewName (join-path $dir "x$($module)") -Confirm }
