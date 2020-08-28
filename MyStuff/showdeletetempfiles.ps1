function ShowDeleteTempFiles {
    param (
    )
    push-location $env:TEMP
    get-item *
    $path=@("*.tmp","*.log", "*.ses", "*.shd","tmp*", "Teamviewer","*.msi","PSES*","_ME*", "*.mtx")
    remove-item -whatif -verbose  -force -path $path
    get-item *
    Pop-Location
}
