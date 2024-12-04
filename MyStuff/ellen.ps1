function ellen {
Write-Warning "In function $($MyInvocation.MyCommand.Name):"
"I am here {0}" -f (get-location)
write-host ($(get-location))
get-content $MyInvocation.ScriptName
}
ellen