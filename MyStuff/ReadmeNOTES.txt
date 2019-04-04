start-process ms-settings:windowsupdate
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
-----
The persistent history you mention is provided by PSReadLine. It is separate from the session-bound Get-History.

The history is stored in a file defined by the property (Get-PSReadlineOption).HistorySavePath. View this file with Get-Content (Get-PSReadlineOption).HistorySavePath, or a text editor, etc. Inspect related options with Get-PSReadlineOption. PSReadLine also performs history searches via ctrl+r.

Get-Content (Get-PSReadlineOption).HistorySavePath | ? { $_ -like '*docker cp*' }
-----
system variables
gci env: 
cd $env:homepath

 `uname -a` isn't useful here as it reports the kernel information which is Microsoft (as WSL doesn't use the Linux kernel). 

Instead try `lsb_release -a` which will tell you the distro information. Depending on if you're using Ubuntu 14 or 16, you should be able to follow the install instructions using the package repository via `apt` which will automatically install the dependencies. If using the downloaded .deb and using dpkg, you'll have to manually install the dependencies that are missing.

https://4sysops.com/archives/a-powershell-implementation-of-netstat-exe/
https://github.com/MSAdministrator/PSNetStat

how to install modules
https://kevinmarquette.github.io/2017-05-27-Powershell-module-building-basics/
https://activedirectorypro.com/install-powershell-modules/

logging see logging.ps1
https://gallery.technet.microsoft.com/scriptcenter/Enhanced-Script-Logging-27615f85#content

function prompt {([system.io.fileinfo](pwd).path).basename + '> '}
"function prompt"
function prompt {([system.io.fileinfo](pwd).path).basename + " > "}
#function prompt {(split-path $pwd -leaf) +'> '}
#function prompt {'{0}> ' -f (split-path $pwd -leaf)}

$mystring='Fred ARTHUR Jacobowitz'
(Get-Culture).TextInfo.ToTitleCase($mystring.ToLower())