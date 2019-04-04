#see https://blogs.technet.microsoft.com/heyscriptingguy/2016/08/12/use-powershell-to-report-on-sharepoint-content-with-custom-dingbat-characters/

                                            (0x2700..0x27BF).ForEach({[char]$_})

#Sample output (first 20 symbols):
#Sample output (first 20 symbols)

#There are many ways to show the dingbat characters in the PowerShell ISE, and here are a few:

# Using ToChar Method
0x2764.ToChar($_)

# Using System.Convert
[Convert]::ToChar(0x2764)

#Using Type Casting
[char]0x2764

Get-EventLOG -

#Here’s one more example to print the numbers as symbols by using PowerShell:

 -join ((0x2776..0x277F).ToChar($_))