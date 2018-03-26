https://blogs.msdn.microsoft.com/powershell/2018/01/10/powershell-core-6-0-generally-available-ga-and-supported/

Versions
  $PStableVersion

64 Powershell is installed here
  c:\windows\system32\WindowsPowerShell\V1.0
powershell.exe
powershell_ise.exe

32 bit (referred to as x86 is installed here.
  C:\WINDOWS\syswow64\WindowsPowerShell\v1.0

https://docs.microsoft.com/en-us/powershell/scripting/setup/starting-the-32-bit-version-of-windows-powershell?view=powershell-5.1

Core is installed here
  "C:\Program Files\PowerShell\6.0.0\pwsh.exe"

system variables
gci env: 
cd $env:homepath

 `uname -a` isn't useful here as it reports the kernel information which is Microsoft (as WSL doesn't use the Linux kernel). 

Instead try `lsb_release -a` which will tell you the distro information. Depending on if you're using Ubuntu 14 or 16, you should be able to follow the install instructions using the package repository via `apt` which will automatically install the dependencies. If using the downloaded .deb and using dpkg, you'll have to manually install the dependencies that are missing.
