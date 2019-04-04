# https://dennisaa.wordpress.com/2015/09/06/powershell-remoting-across-homegroup-machines/
# this is the sequence of steps that must be done to set-up Powershell Remoting.
# You have to run an elevated session for some of these commands.
winrm quickconfig
Get-service winrm
enable-psremoting -force
winrm s winrm/config/client '@{TrustedHosts="VAIOFRED"}'
$session=New-PSSession -ComputerName "Supercomputer" -Credential Get-Credential


# Good reference material on trouble shooting
# https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/use/troubleshooting
# see what TrustedHost is set to
winrm g winrm/config/client
# or the Powershell way
Get-Item WSMan:localhost\Client\TrustedHosts
# store them somewhere
Get-Item WSMan:localhost\Client\TrustedHosts | Out-File C:\OldTrustedHosts.txt
# later restore via
Set-Item WSMan:localhost\Client\TrustedHosts -Value '<paste values from text file>'## Credentials ##


function Do-It() {
    [CmdletBinding()]
    Param()
    $session = New-PSSession -ComputerName "VaioFred" -Credential Get-Credential
    $session = New-PSSession -ComputerName "Supercomputer" -Credential Get-Credential

    Invoke-Command -Session $session -ScriptBlock {
        $VerbosePreference = $using:VerbosePreference
        Write-Verbose "Test"
        Get-Location
        #Get-ChildItem -Path c:\ -Filter *.txt
        Get-ChildItem -filter *.txt
    }
}
 Do-it
# or do this single line.

 for($i=1; $i -le 1; $i++){Write-Host -ForegroundColor Green $i;invoke-command  -Session $session -ScriptBlock {Get-Process}}
 for($i=1; $i -le 1; $i++){Write-Host -ForegroundColor Green $i;invoke-command  -Session $session -ScriptBlock {dir env:}}
