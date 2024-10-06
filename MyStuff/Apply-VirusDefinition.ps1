# function fjApplyVirusDefinition {
# FAJ Sept 2024 
# File -> 'Apply-VirusDefinition.ps1'
Write-Warning "In function $($MyInvocation.MyCommand.Name):"
$file = join-path $env:HOME "Downloads\mpam-fe.exe"
$sourceUrl = "https://go.microsoft.com/fwlink/?LinkID=121721&arch=arm64"
if (test-path -Verbose -Path $file) { remove-item $file -Verbose }
# download latest virus definition file.
# Use Start-BitsTransfer to download the file. 
$parameters = @{
    Source      = $sourceUrl
    Destination = $file
    DisplayName = $file
}
$parameters
Start-BitsTransfer @parameters -verbose
# Start-BitsTransfer -Source $sourceUrl -Destination $file -DisplayName $file -Verbose

# apply the file
if (test-path $file) { 
    # wait for file to be applied - like invoke-command but waits for it to complete.
    start-process -Verbose -Wait -filepath $file
    write-warning "$file applied"
    $parameters = @{
        FilePath     = "Chrome.exe"
        ArgumentList = 'https://www.microsoft.com/en-us/wdsi/definitions/antimalware-definition-release-notes'
    }
    $parameters
    start-process @parameters -Verbose
    # start-process chrome.exe -ArgumentList 'https://www.microsoft.com/en-us/wdsi/definitions/antimalware-definition-release-notes'
}
else { write-error ("File '$file' was not found.") }
if (test-path $file) { remove-item $file -Verbose }
Write-Warning "Leaving function $($MyInvocation.MyCommand.Name):"
# }#fjApplyVirusDefinition