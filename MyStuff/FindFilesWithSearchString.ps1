Get-ChildItem *.txt -recurse | Select-String -pattern “one” | group path | select name
select-string -path *.txt -SimpleMatch "one"
