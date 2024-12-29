function Get-SpecialFolders {
    [CmdletBinding()]
    param (
        [string]$ComputerName = $env:COMPUTERNAME
    )
    

    #Get the path of each special folder.
    # https://learn.microsoft.com/en-us/dotnet/api/system.environment.specialfolder?view=net-9.0
    <# 
// Sample for the Environment.GetFolderPath method
using System;

class Sample
{
    public static void Main()
    {
    Console.WriteLine();
    Console.WriteLine("GetFolderPath: {0}",
                 Environment.GetFolderPath(Environment.SpecialFolder.System));
    
}
/*
This example produces the following results:

GetFolderPath: C:\WINNT\System32
*/
 #>
    Write-Warning "In function $($MyInvocation.MyCommand.Name)"
    write-host 'Get the path of a Special folder using [Environment]::GetFolderPath(''MyDocuments'').'
    # How to get the pathname of a Special folder.
    write-host ("The Special Folder [{0}] is located at [{1}]" -f 'MyDocuments', [Environment]::GetFolderPath('MyDocuments'))

    #Force an error
    $error.Clear()
    $EAP = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    [Environment]::GetFolderPath('BadSpelling')
    $ErrorActionPreference = $EAP

    # Get the error message
    # $error.Count
    $msg = $error[0].Exception.Message
    # $start=$msg.IndexOf("again:")+7
    $VirtualFolders = $msg.Substring($msg.IndexOf("again:") + 7).Trim().trim('"').Replace(" ", "").Split(",") | Sort-Object

    # get the path of each virtual folder.
    # foreach ($vFolder in $VirtualFolders) {"[{0}] = [{1}]" -f $vFolder,[Environment]::GetFolderPath($vFolder)}
    # Follow-up is to return as an object.
    # $VirtualFolders | ForEach-Object -Process {Write-Host "[$_] = [$([Environment]::GetFolderPath($_))]"}

    foreach ($vFolder in $VirtualFolders) {
        $hash = @{
            SpecialFolder = $vFolder
            Path          = [Environment]::GetFolderPath($vFolder)
        }
        $Object = New-Object PSObject -Property $hash
        $Object
    }

    if ($error.Count -eq 1) { $error.Clear() } else { Write-Warning "There were other errors" }
}
Get-SpecialFolders
    <# 
[AdminTools] = [C:\Users\freds\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Administrative Tools]
[ApplicationData] = [C:\Users\freds\AppData\Roaming]
[CDBurning] = [C:\Users\freds\AppData\Local\Microsoft\Windows\Burn\Burn]
[CommonAdminTools] = [C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools]
[CommonApplicationData] = [C:\ProgramData]
[CommonDesktopDirectory] = [C:\Users\Public\Desktop]
[CommonDocuments] = [C:\Users\Public\Documents]
[CommonMusic] = [C:\Users\Public\Music]
[CommonOemLinks] = []
[CommonPictures] = [C:\Users\Public\Pictures]
[CommonProgramFiles] = [C:\Program Files\Common Files]
[CommonProgramFilesX86] = [C:\Program Files (x86)\Common Files]
[CommonPrograms] = [C:\ProgramData\Microsoft\Windows\Start Menu\Programs]
[CommonStartMenu] = [C:\ProgramData\Microsoft\Windows\Start Menu]
[CommonStartup] = [C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup]
[CommonTemplates] = [C:\ProgramData\Microsoft\Windows\Templates]
[CommonVideos] = [C:\Users\Public\Videos]
[Cookies] = [C:\Users\freds\AppData\Local\Microsoft\Windows\INetCookies]
[Desktop] = [C:\Users\freds\OneDrive\Desktop]
[DesktopDirectory] = [C:\Users\freds\OneDrive\Desktop]
[Favorites] = [C:\Users\freds\Favorites]
[Fonts] = [C:\windows\Fonts]
[History] = [C:\Users\freds\AppData\Local\Microsoft\Windows\History]
[InternetCache] = [C:\Users\freds\AppData\Local\Microsoft\Windows\INetCache]
[LocalApplicationData] = [C:\Users\freds\AppData\Local]
[LocalizedResources] = []
[MyComputer] = []
[MyDocuments] = [C:\Users\freds\OneDrive\Documents]
[MyMusic] = [C:\Users\freds\Music]
[MyPictures] = [C:\Users\freds\OneDrive\Pictures]
[MyVideos] = [C:\Users\freds\Videos]
[NetworkShortcuts] = [C:\Users\freds\AppData\Roaming\Microsoft\Windows\Network Shortcuts]
[Personal] = [C:\Users\freds\OneDrive\Documents]
[PrinterShortcuts] = []
[ProgramFiles] = [C:\Program Files]
[ProgramFilesX86] = [C:\Program Files (x86)]
[Programs] = [C:\Users\freds\AppData\Roaming\Microsoft\Windows\Start Menu\Programs]
[Recent] = [C:\Users\freds\AppData\Roaming\Microsoft\Windows\Recent]
[Resources] = [C:\windows\resources]
[SendTo] = [C:\Users\freds\AppData\Roaming\Microsoft\Windows\SendTo]
[StartMenu] = [C:\Users\freds\AppData\Roaming\Microsoft\Windows\Start Menu]
[Startup] = [C:\Users\freds\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup]
[System] = [C:\windows\system32]
[SystemX86] = [C:\windows\SysWOW64]
[Templates] = [C:\Users\freds\AppData\Roaming\Microsoft\Windows\Templates]
[UserProfile] = [C:\Users\freds]
[Windows] = [C:\windows]
 #>