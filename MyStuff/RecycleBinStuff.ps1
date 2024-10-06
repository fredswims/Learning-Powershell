$sb = {function Get-RecycleBin 
    {
        (New-Object -ComObject Shell.Application).NameSpace(0x0a).Items() |
	        Select-Object Name, Size, Path
    }
    Get-RecycleBin
}
# Invoke-Command -ComputerName $computer -ScriptBlock $sb
Invoke-Command  -ScriptBlock $sb


        (New-Object -ComObject Shell.Application).NameSpace(0x0a).Items() |
	        Select-Object Name, Size, Path
    }
}