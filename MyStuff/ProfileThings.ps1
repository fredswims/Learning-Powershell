function Get-ProfilePaths1 {
	# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/checking-profile-scripts-part-1
	$profile.PSObject.Properties.Name | Where-Object { $_ -ne 'Length' } | ForEach-Object { [PSCustomObject]@{Profile = $_; Present = Test-Path $profile.$_; Path = $profile.$_ } }  
} #end function

function Get-ProfilePaths2 {
	# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/checking-profile-scripts-part-2
	# calculate the parent paths that can contain profile scripts
	$Paths = @{
		AllUser_WPS     = $pshome
		CurrentUser_WPS = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath "WindowsPowerShell"
		AllUser_PS      = "$env:programfiles\PowerShell\*"
		CurrentUser_PS  = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath "PowerShell"
	}

	# check all paths for PowerShell scripts ending on "profile.ps1"
	$Paths.Keys | ForEach-Object {
		$key = $_
		$path = Join-Path -Path $paths[$key] -ChildPath '*profile.ps1'
		Get-ChildItem -Path $Path |
		ForEach-Object {
			# create a custom object with all relevant details for any
			# found profile script

			# name of PowerShell host is the prefix of profile file name
			if ($_.Name -like '*_*') {
				$hostname = $_.Name.Substring(0, $_.Name.Length - 12)
			}
			else {
				$hostname = 'any'
			}
			[PSCustomObject]@{
				# scope and PowerShell version is found in the 
				# name of the parent folder
				Scope      = $key.Split('_')[0]
				PowerShell = $key.Split('_')[1]
            
				Host       = $hostname
				Path       = $_.FullName
			}
		}
	}
} #end function

write-warning "calling ProfilePaths1"
$list1=Get-ProfilePaths1
$list1|format-table * -AutoSize
write-warning "calling ProfilePaths2"
$list2=Get-Profilepaths2
$list2|format-table * -AutoSize