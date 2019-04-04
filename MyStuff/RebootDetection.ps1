 <#  
 .SYNOPSIS  
   SCCM Reboot Detection Method  
 .DESCRIPTION  
   This script will read the last time a system rebooted from the event  
   viewer logs. It then calculates the number of days since that time. If  
   the number of days equals or exceeds the RebootThreshold variable, the  
   script will exit with a return code 0 and no data output. No data output   
   is read by SCCM as a failure. If the number of days is less than the  
   RebootThreshold, then a message is written saying the system is within  
   the threshold and the script exits with a return code of 0. SCCM reads  
   an error code 0 with data output as a success.   
 .Author  
   Mick Pletcher  
 .Date  
   30 June 2015  
 #>  
   
 $RebootThreshold = 14  
 $Today = Get-Date  
 $Architecture = Get-WmiObject -Class Win32_OperatingSystem | Select-Object OSArchitecture  
 $Architecture = $Architecture.OSArchitecture  
 $LastReboot = get-winevent -filterhashtable @{logname='system';ID=1074} -maxevents 1 -ErrorAction SilentlyContinue  
 if ($Architecture -eq "32-bit") {  
      if ((Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reboot") -eq $false) {  
           New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reboot" | New-ItemProperty -Name Rebooted -Value 0 -Force | Out-Null  
      }  
      $Rebooted = Get-ItemProperty -Name Rebooted -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reboot"  
      $Rebooted = $Rebooted.Rebooted  
 } else {  
      if ((Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Reboot") -eq $false) {  
           New-Item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Reboot" | New-ItemProperty -Name Rebooted -Value 0 -Force | Out-Null  
      }  
      $Rebooted = Get-ItemProperty -Name Rebooted -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Reboot"  
      $Rebooted = $Rebooted.Rebooted  
 }  
 if ($LastReboot -eq $null) {  
      $Difference = $RebootThreshold  
 } else {  
      $Difference = New-TimeSpan -Start $Today -End $LastReboot.TimeCreated  
      $Difference = [math]::Abs($Difference.Days)  
 }  
 #Write-Host "Reboot Threshold:"$RebootThreshold  
 #Write-Host "Difference:"$Difference  
 #Write-Host "Rebooted:"$Rebooted  
 if (($Difference -lt $RebootThreshold) -and ($Rebooted -eq 0)) {  
      Write-Host "Success"  
      exit 0  
 }  
 if (($Difference -ge $RebootThreshold) -and ($Rebooted -eq 1)) {  
      Write-Host "Success"  
      exit 0  
 }  
 if (($Difference -ge $RebootThreshold) -and ($Rebooted -eq 0)) {  
      exit 0  
 }  
 if (($Difference -lt $RebootThreshold) -and ($Rebooted -eq 1)) {  
      exit 0  
 } 