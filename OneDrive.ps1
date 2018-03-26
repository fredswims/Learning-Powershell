#OneDrive 1.0.2 2016-11-08
#https://www.powershellgallery.com/packages/OneDrive/1.0.2
#Install-Module OneDrive -RequiredVersion 1.0.2

#get-ODDrives -AccessToken 
#$Authentication=Get-ODAuthentication "Authorization: bearer EwAIA61DBAAUGCCXc8wU/zFu9QnLdZXy+YnElFkAAX/PORpRS8wlKl+Bpf4QQ/9+dNskcFwcPzlu/jB9AzR/W0VRZfWwFmHkaHD56dBcJYPwJdk1i48lBHRHXO45Oh6ThJGSaHviYC/q6fQN80GRCXm5AXtnx/aTaK+l1rmXTHxBTUmmqc3rU9Snc9ysvJBDfNWSIvPwWqaTUM9eJk3EUIo0rrHT5AXCigPwSDF2m+aYAMxYFs6jVfF9muH6gtUGqAbwMYMRKeSLbpSPwlNjnfnThARwRpV6lXDypkCxIJMQJIPs6yX2rei3FlMjhEXfeh6hKT9EpsbW3HerG+omHHIJyuIBuFh2Qsd5NlcGWZ8bzdIhddHSTSggXUJmr4gDZgAACLJxF9P5RYSj2AGp0ct4iuRNpXMT8hXGb3VorFpDU1AmuAgxzfknoRHU0qW142V4WTLDIR94QXG6qQjJPOWw3Cad60agHyCux1hMHTLD2Ye8fc5YCYOpZPI/xed1N2Q5kCZOSIQYEGrk6nsa5n9su9FQFrFU++ttMCkESbLIuflWuQMd6YZC9kPT+LysPVmv9ZBR1J0WKuwHJnNFu5thDRX1Z7+Mjt1WS0HSWFw2V35y4uC5eAtvEXSZvtW+xfujufD9LZ/BD1FxwBU+yLqafCRkaysiTU8cVAgOEoIj1cpZlLVKCFNE4xlGKE1A+1ZtofIPZsveS1QIjSxFKEQMlVgMyG8XRzLjftGRSp0xtQEf/LSmJLRxbksk8BPQIHaLkmxLJ9OsmKmsetZS56q0U92Ze5Y+JvhNDNT04kJhVkIif0d5XqQe9T8t8s/a6Ns1P4O5DT5fTpReNU8gBBjMN4253r/Vp4IPiCIZHmdgSpw4KucEXy4AHWh9SNPfHEIyh0RVOYUbU+JddyHApYzWhBfbOLeKA3zsGmXGfqjvMDaxP6/VO58krbnbW2UASEpknGMcj/4AEby4GTdTTK7JJZpwfWOqpHUQ0P0osF51GbHpeHxero7ZPuXPY7BQcTB8rRPGCgI="
#$AuthToken=$Authentication.access_token


#Get temporary Authorization Token https://dev.onedrive.com/auth/msa_oauth.htm

$AuthToken="EwAIA61DBAAUGCCXc8wU/zFu9QnLdZXy+YnElFkAAY0S7iIecybsAZXJzsB6ePR/QssJjR8hPck7Kzsn4lcn8/ByhI8NmEpROhij4bAFaNkBzOCkPEQ00PI9Gk1TTn+slcPsV8igMwIs3dQGnPvlUNyAWDSO0C3TxMlJoKCWAj7qSC7Z0R8cS7lPsRF8Ccw0TO4ml1Ox0KGahIHfy6kSSfRnC3vIX03ZIxmO+SyyzOpSI0ElbfQnLVeO/5vw7nZ9IypsaOLG1pB7OUmqFg7IdtBPTQeu6Z/3pQSM2qA7Uxv5IoAPOre3CvhKpdSKzp7HIwMofoh1Fz8Cs78qtXC+mwi4TVbWO6hwTD5OteWn5LFW8m8pxCRpDk4HXZcwdaMDZgAACNc3yBgOk+Sy2AHB5sJMXzMa/zOBVN7cHvAmYcfZuBWkFiWj22TCs3hsMgQdB8Jnzbf0PanWQ1DxZSoHHrPActPurc4RAw/NCW5QWk2s/giZHV2nC0Ig8I9QiVIIyd/ajPhARrYbvTIfVG+k43X2Oe5p9rcNHikQTK4c4GMAy959q6CWdlA44nipY8R6c0agNYBqyHwxQ2vBXPDaVM47SLhOm+7vpevejBJGovgqP1s7eKACJVJmdk9cdL/W50UnzBCTnc/kXBwH2hrAfsa8sMFv6IPL4VLEqdJpqG05F9TsXcqGNSK+NcclndVlidRi8X4uQLcaxu/7J8zGl/+B0n3cQk1KadVze+gmVYOTNKrOonnBtxpVoRZP50A+PMsD0+1SIdeu+9ZVZh1a3u11d5711QCJc38Aq69rxruI2Xo0lKYOzLSfsFPFz5//OCpxUBAIRUdCTmWABbkQYv6Zx87iU0yxG5E+3Nw+hO0zce2bBWSbqZ5uFOXv0MSlj2eBc3r2yA9AuIubIKTvDyEEfy2hCmugwcQBqzA94nyPa2CYhOIBdEZLvDeow1oetJ14LdBR2/wl43cLf6Xg+b/KqEwFo++sJ5cJmRFGsmiZSu2HA/aiCzX8MAZUKOeIpCISRJplCgI="


Get-ODChildItems -AccessToken $AuthToken -Path "/" | FT
Get-ODChildItems -AccessToken $AuthToken -Path "/Pictures 1" |FT name
#Get-ODChildItems -AccessToken $AuthToken -Path "/Pictures 1/NoahShoot2016Dec3" | ft name
$mypics=Get-ODChildItems -AccessToken $AuthToken -Path "/Pictures 1/NoahShoot2016Dec3" | sort -Property name 
$mypics.Count

$mypics=Get-ODChildItems -AccessToken $AuthToken -Path "/Pictures 1/NoahShoot2016Dec3" | FT


#on local drive
get-childitem -name | Where-Object {$_.CreationTime -gt "12/2/2016 11:59 PM"} | FT
get-childitem -name | Where-Object {$_.Name -contains "DSC05634.jpg"}

$iFiles=get-childitem | Where-Object {$_.name -gt "DSC05603.jpg"} | ft name 
$iFiles=get-childitem | Where-Object {$_.name -gt "DSC05826.arv" -and $_.name -lt "DSC05850.zzz"} 

$ifiles.Count
foreach ($file in $iFiles)  {Echo $file}
}
ForEach-Object -Process {echo $_.name} -InputObject $ifiles
help Add-ODItem
Add-ODItem -AccessToken $AuthToken -path  "/Pictures 1/NoahShoot2016Dec3" -localfile "K:\FredsPictures\NoahsPhotoShoot2016Dec3\DSC05921.ARW"
Add-ODItem -AccessToken $AuthToken -path  "/Pictures 1/NoahShoot2016Dec3" -localfile "DSC05930.ARW"