Start-Transcript -IncludeInvocationHeader -force -path ./ThisLog.out
$ErrorActionPreference="STOP"
try {
    Clear-History -Verbose
    Set-Location $home\temp
    set-location $PSScriptRoot -Verbose -PassThru
    Get-ChildItem * -Verbose
    remove-item ellen.out -verbose
    copy-item fred.out ellen.out
    copy-item fred.out ellen.out -verbose
    Get-History -Verbose
    Stop-Transcript -Verbose

}
catch {
    $error[0]
}