Start-Transcript
cd $env:HOMEPATH
cd documents
if (test-path fred.dat) {remove-item fred.dat}
new-item fred.dat
set-content -value "hello world" -Path fred.dat
get-content fred.dat
remove-item fred.dat
Stop-Transcript

