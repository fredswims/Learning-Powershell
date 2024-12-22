"Saturday"
#define type accelerator for type accelerators #https://blogs.technet.microsoft.com/heyscriptingguy/2013/07/08/use-powershell-to-find-powershell-type-accelerators/
$xlr=[psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
$xlr::Add('accelerators',$xlr)
write-information -informationAction "continue" -MessageData "Try this======[accelerators]::get"

#Try this to get OverloadDefinition
[datetime]::DaysInMonth
<#
OverloadDefinitions
-------------------
static int DaysInMonth(int year, int month)
#>
[datetime]::DaysInMonth(2018,04)
[datetime]::DaysInMonth((get-date).year, (get-date).Month)

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
#>