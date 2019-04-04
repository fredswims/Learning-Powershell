#format operator

$fred="Fred Jacobowitz"
$ellen="Ellen Jacobowitz"

'My name is {0} and my sister''s name is {1}' -f $fred, $ellen
#Optional format string(s) can be included to add padding/alignment and display dates/times/percentages/hex etc correctly, see the -f format page for full details.
#https://ss64.com/ps/syntax-operators.html

$String='My name is {0} and my sister''s name is {1}' -f $fred, $ellen


write-host $string
write-host "My name is $fred and my sister's name is $ellen"
write-host "My name is $($fred) and my sister's name is $($ellen)"
#NO GOOD
write-host 'My name is $($fred) and my sister''s name is $($ellen)'

