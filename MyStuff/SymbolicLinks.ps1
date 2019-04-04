# isolate symbolic links

Get-ChildItem -Attributes Reparsepoint # will also appear gci -directory

Get-ChildItem -Attributes !ReparsePoint #not reparsepoint

new-item musicx -ItemType Symboliclink -value ($env:HOMEDRIVE + $env:HOMEPATH +"\music")
