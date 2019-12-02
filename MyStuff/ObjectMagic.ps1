#https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/object-magic-part-1
#In PowerShell, most data are represented as PSObjects, a specific object “wrapper” added by PowerShell. To get to this specific wrapper, objects have a secret property called “PSObject”. Let’s take a look:
#https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/object-magic-part-3
# get any object
$object = Get-Process -Id $pid

# try and access the PSObject
$object.PSObject

# get another object
$object = "Hello"

# try again
$object.PSObject

#As you’ll see, the secret “PSObject” is basically a description for the object. And there is a ton of useful information embedded. Here’s some:

# get any object
$object = Get-Process -Id $pid

# try and access the PSObject
$object.PSObject

# find useful information
$object.PSObject.TypeNames | Out-GridView -Title Type
$object.PSObject.Properties | Out-GridView -Title Properties
$object.PSObject.Methods | Out-GridView -Title Methods



#https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/object-magic-part-2
# get any object
$object = Get-Process -Id $pid

# try and access the PSObject
$object.PSObject.Properties.Where{$_.IsSettable}.Name
#The result is a list of properties in Process objects that can be assigned new values:

#Likewise, you can easily figure out all properties that currently have no value (are empty):

# get any object
$object = Get-Process -Id $pid

# try and access the PSObject
$object.PSObject.Properties.Where{$null -eq $_.Value}.Name 


# get any object
$object = Get-ChildItem .\fred.ps1
# try and access the PSObject
$object.PSObject.Properties.Where{$_.IsSettable}.Name 


#Part 3
# get any object
$object = Get-Process -Id $pid

# try and access the PSObject
$propNames = $object.PSObject.Properties.Where{$null -ne $_.Value}.Name
$object | Select-Object -Property $propNames
#This will output only the properties that have a value. 
#You could even make sure the properties are sorted:

# get any object
$object = Get-Process -Id $pid

# try and access the PSObject
$propNames = $object.PSObject.Properties.Where{$null -ne $_.Value}.Name | Sort-Object
$object | Select-Object -Property $propNames