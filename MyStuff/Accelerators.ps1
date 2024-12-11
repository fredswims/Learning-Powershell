# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_type_accelerators?view=powershell-7.4
#define type accelerator for type accelerators #https://blogs.technet.microsoft.com/heyscriptingguy/2013/07/08/use-powershell-to-find-powershell-type-accelerators/
$xlr=[psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
$xlr::Add('accelerators',$xlr)

[psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::get  #this is the one
[psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')|Get-Member
[psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')|Get-Member -Static


[accelerators]::get
[accelerators]

[psobject].Assembly.GetType(“System.Management.Automation.TypeAccelerators”)::get #this works

#Try this to get OverloadDefinition
[datetime]::DaysInMonth
<#
OverloadDefinitions
-------------------
static int DaysInMonth(int year, int month)
#>
[datetime]::DaysInMonth(2018,04)
[datetime]::DaysInMonth((get-date).year, (get-date).Month)

[System.Convert]|get-member -static

#https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/converting-ieee754-float-part-1
# Take 3FA8FE3B, split it into pairs, reverse the order, then convert to a number:
$bytes = 0x3B, 0xFE, 0xA8, 0x3F
[BitConverter]::ToSingle($bytes, 0)

<#
As it turns out, the hex value 0x3FA8FE3B returns the sensor value 1.320258.
Today, we focused on the BitConverter class that provides methods to convert byte arrays to numeric values.
Tomorrow, we look at the other part: splitting text hex values into pairs and reversing the order.
Learning points for today:
Use [BitConverter] to convert raw bytes and byte arrays into other numeric formats. The class comes with a multitude of methods:

#>
#Get all the methods in the accelerator
[BitConverter] | Get-Member -Static | Select-Object -ExpandProperty Name
[datetime] |Get-Member -Static | Select-Object -ExpandProperty Name
<#To see the syntax for any of these methods, enter them without parenthesis:
[BitConverter]::ToUInt32

OverloadDefinitions
-------------------
static uint32 ToUInt32(byte[] value, int startIndex)

# Use reflection to access the TypeAccelerators class
$typeAcceleratorsType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")

# Get the Get method from TypeAccelerators class
$getMethod = $typeAcceleratorsType.GetMethod('Get', [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Static)
$typeAccelerators = $getMethod.Invoke($null, @())

# Display the accelerators
$typeAccelerators.GetEnumerator() | Sort-Object Key | ForEach-Object {Write-Output "$($_.Key) = $($_.Value.FullName)"}

#>

# Use reflection to access the internal type accelerators dictionary
$acceleratorsField = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators").GetField("typeAccelerators", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Static)
$accelerators = $acceleratorsField.GetValue($null)

# Display the accelerators
$accelerators.GetEnumerator() | Sort-Object Key | ForEach-Object { Write-Output "$($_.Key) = $($_.Value.FullName)"}


# List all type accelerators in PowerShell
[System.Management.Automation.PSTypeName]::GetAccelerators().GetEnumerator() | Sort-Object Key | ForEach-Object {
    Write-Output "$($_.Key) = $($_.Value)"
}



# Use reflection to list all type accelerators
$acceleratorsField = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators").GetField("typeAccelerators", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Static)
$accelerators = $acceleratorsField.GetValue($null)

# Display the accelerators
$accelerators.GetEnumerator() | Sort-Object Key | ForEach-Object { 
    "$($_.Key) = $($_.Value.FullName)"
}
