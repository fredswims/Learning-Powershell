Start-RecordSession -verbose
cd $HOME
new-item -ItemType File -Name fred.dat -Verbose
copy-item fred.dat ellen.dat -Verbose
remove-item fred.dat -verbose
"next line is a copy file but it will fail - I removed the verbose switch"
copy-item fred.dat ellen.dat 

Stop-RecordSession -verbose

