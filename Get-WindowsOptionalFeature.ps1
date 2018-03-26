#Must run elevated.
Get-WindowsOptionalFeature -Online
Get-WindowsOptionalFeature -online | where {$_.State -eq "Enabled"} | Format-Table
Get-WindowsOptionalFeature -online | where {$_.State -eq "Disabled"} | Format-Table
#Disable-WindowsOptionalFeature –FeatureName NetFx3 –Online
#Enable-WindowsOptionalFeature –FeatureName NetFx3 –Online
