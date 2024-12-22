# this might have to be from a elevated process

Get-AppxPackage -allusers Microsoft.WindowsFeedbackHub| ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
