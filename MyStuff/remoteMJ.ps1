<# 
Get the services on MJ (the remote) and Book4Edge
Create two files
Author: Fred Jacobowitz
Date: 2025-06-16
 #>
Clear-Host 
    # Write-Warning "In Script $($MyInvocation.MyCommand.Name): "
    write-host "Beginning script $PSCommandPath on $env:computername" 
write-host "setting up variables"
$remoteSystem = "mj"
$remoteFolder = (join-path "C:\Users\Maraj\Onedrive"-ChildPath Documents)
$remoteFile = "MarasServices.txt"
$remoteFullPath = (join-path -path $remoteFolder -ChildPath $remoteFile)

$thisComputerFolder = (join-path -path $env:OneDrive -ChildPath Documents)
$thisComputerFolder = $env:TEMP

$fredsFile = "FredsServices.txt"

$thisComputerMarasFileFullPath = (join-path -Path $thisComputerFolder -ChildPath $remotefile)
$thisComputerFredsFileFullPath = (join-path -Path $thisComputerFolder -ChildPath $fredsFile)

Get-PSSession | Remove-PSSession
# Measure-Command -Expression {$session = New-PSSession -ComputerName mj}
# Can the remote system can accept PowerShell remoting connections?
try {
    
    Write-Host "Is \\$remoteSystem Online?"
    if (Test-WsMan -ComputerName $remoteSystem) {
        Write-Host "The remote system \\$remoteSystem is Online" 
    } 
    else { 
        Write-Warning "The remote system $remoteSystem is OffLine" 
        throw "The remote system $remoteSystem is OffLine"
    }
    
    
    Write-Host "Get-PSSession"
    $session = New-PSSession -ComputerName $remoteSystem
    
    Invoke-Command -session $session -scriptblock {get-process -id $pid} 
    Invoke-Command -session $session -scriptblock { 
        if (Test-Path $using:remoteFullPath ) { remove-item $using:remoteFullPath -Verbose }
    }
    Invoke-Command -session $session -scriptblock {
        $ServicesRemote = Get-Service -Name * 
        # the next line can be executed locally. out-file $remoteFile
        $ServicesRemote | sort-object name | out-file $using:remoteFullPath -Verbose
    }
    Invoke-Command -session $session -scriptblock {
        get-item $using:remoteFullPath | Select-Object fullname, LastWriteTime
    }
    Copy-Item -Verbose -FromSession $session -Path $remotefullpath `
        -Destination (Join-path $thisComputerFolder -ChildPath $remoteFile)
    
    if (Test-Path $thisComputerFredsFileFullPath ) { remove-item $thisComputerFredsFileFullPath -Verbose }    
    $Services = Get-Service -Name * 
    $Services | sort-object name | out-file -FilePath $thisComputerFredsFileFullPath -verbose
    Get-ChildItem -path @($thisComputerFredsFileFullPath, $thisComputerMarasFileFullPath) | `
        format-list -Property FullName, LastWriteTime, Length
}

catch {
    <#Do this if a terminating exception happens#>
    write-host "In the catch block."
}

finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
    write-host "In the Finally block"
    write-host "remove sessions"
    (Get-PSSession | Remove-PSSession)
    Write-Host  "$pscommandpath Finis"
}
<#
Compare-Object `
 -ReferenceObject (get-content $thisComputerFredsFileFullPath) `
 -DifferenceObject (get-content $thisComputerMarasFileFullPath)
#>
<# 
Get-Service | Where-Object {$_.DependentServices} |Format-List -Property Name, DependentServices, @{
        Label="NoOfDependentServices"
        Expression={$_.DependentServices.Count}
    }
 #>