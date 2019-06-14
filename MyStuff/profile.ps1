"*** Version::2019-06-13.0"
#add to git
Write-Warning "In function $($MyInvocation.MyCommand.Name): Beginning Common Header"
#regionProfile
if ([Environment]::Is64BitProcess){"*** Is 64 bit process"}else {"*** Is 32 bit process"}
$MyInvocation|Select-Object *
#MyInvocation.Line is looks like (. single-quoted-path)
$ThisProfilePath = $MyInvocation.Line.replace(". ", "").trim("'")
if ($ThisProfilePath -eq "") {$ThisProfilePath = $MyInvocation.InvocationName}
write-host -foregroundColor 'yellow' "*** Sourcing Profile: $($ThisProfilePath)"
#$ProfileNames ="AllUsersAllHosts", "AllUsersCurrentHost", "CurrentUserAllHosts", "CurrentUserCurrentHost"
$ProfileNames = ($profile|Get-Member -membertype noteproperty).name
$count = 0
($ProfileNames).foreach( {if ($ThisProfilePath -eq $($Profile.$_)) {"This profile [{0}] has path {1}" -f $_, $ThisProfilePath ; $Count++}})
If ($count -ne 1) {write-host -foregroundColor 'red' "Which profile is this?"}
Remove-Variable "ProfileNames"; Remove-Variable "ThisProfilePath"; Remove-Variable "Count"
Write-Warning "In function $($MyInvocation.MyCommand.Name): Completed Common Header"
#
"*** PSVersionTable"
$PSVersionTable
get-executionPolicy -list |Format-Table
<#
Somethings to remember
This command sets an execution policy of AllSigned for only the current Windows PowerShell session.
This execution policy is saved in the PSExecutionPolicyPreference
environment variable ($env:PSExecutionPolicyPreference),
so it does not affect the value in the registry.
The variable and its value are deleted when the current session is closed.
https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Security/Set-ExecutionPolicy?view=powershell-5.1
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force
Set-ExecutionPolicy -Scope Process -ExecutionPolicy AllSigned or Unrestricted
get-executionPolicy -list | format-table
#>
#
'*** Define function for prompt'
FUNCTION prompt {'{0}> ' -f (split-path $pwd -leaf)}
#
function DirectorySize {Get-ChildItem -recurse -file | Measure-Object Length -Sum `
    |Select-Object @{name="Num of Files";expression ={"{0:n0}" -f $_.count}}, sum, @{name="GB";expression={[math]::round($_.sum/(1024*1024*1024),6)}}  |format-list * }
function fCheckForUpdates {start-process ms-settings:windowsupdate}
set-alias CheckForUpdates -value fCheckForUpdates -Option Readonly -force -passthru | format-list

function ms-settings ($arg) {start-process ms-settings:$arg}

#Show-ControlPanelItem system

function fCdProfile {push-location (split-path $profile -parent)}
set-alias -name CdProfile -value fCdProfile -Option Readonly -force -passthru | format-list

"Function: SourceProfile"
function SourceProfile {cdprofile;. .\profile.ps1} #something is wrong with this.
function fEditProfile {code $profile.currentuserallhosts}
set-alias -name EditProfile -value fEditProfile -Option Readonly -force -passthru | format-list
function EditProfileVS {code.exe $profile.currentuserallhosts}

function GetWindowsComputerInfo {Get-ComputerInfo -property Windows*}
function Push-ProfileToRepository {
    Write-Warning "In function $($MyInvocation.MyCommand.Name): "
    $Repository = (join-path $env:homepath \Dropbox\Private\Powershell\Profiles\CurrentUser)
    $thisPath = $Profile.CurrentUserAllHosts
    "Repository is {0}:" -f $Repository
    $RepositoryProfile = get-content (join-path $Repository \Profile.ps1) | select-object -first 1
    Write-Warning $RepositoryProfile
     "Working Profile is {0}:" -f $thisPath
    $thisProfile=get-content $thisPath |select-object -first 1
    Write-Warning $thisProfile;write-host ""
    if ($thisProfile -ne $RepositoryProfile) {write-warning "Version numbers are different."} else {write-warning "Version numbers are the same."}
    $temp=compare-object -referenceObject (get-content (join-path $Repository \Profile.ps1))  -DifferenceObject  (get-content $thisPath)
    if ($temp.count -eq 0){write-warning "Files are the same."}
    else {write-warning "Files are different in $($temp.count) places.";$temp|format-list *;copy-item -confirm -path $thisPath -destination $Repository}
 }
set-alias PushProfileToRepository -value Push-ProfileToRepository -Option Readonly -force -passthru | format-list; #remove-variable thisPath

#The powershell OneDrive directory $env:Onedrive\Documents\Powershell is owned by Fred@Fred.Jacobowitz.com and shared as \Powerhell with FredSwims@Outlook.com
function fGetProfile {
    Write-Warning "In function $($MyInvocation.MyCommand.Name): "
    $thisPath = (join-path $env:HomePath\Dropbox\Private\Powershell\Profiles\CurrentUser Profile.ps1)
    $thisDestination = $Profile.CurrentUserAllHosts
    "In Repository is {0}:" -f $thisPath
    write-warning (get-content $thisPath | select-object -first 1)
    "Working Profile is {0}:" -f $thisDestination
    write-warning (get-content $thisDestination|select-object -first 1)
    copy-item -confirm -path $thispath -destination (split-path -parent $profile)
}
set-alias GetProfileFromRepository -value fGetProfile -Option Readonly -force -passthru | format-list; #remove-variable thisPath#


function fGetDirDays ($days = 0) {get-childitem -file -path * | where-object {$_.LastWriteTime -gt [datetime]::today.Adddays(-$days)}| sort-object  lastwritetime}
set-alias -name lsl -value fGetDirDays -Option Readonly -force -passthru | format-list

#regionQuicken
<# Decaprecated
"QUICKEN***** function and alias"
#https://ss64.com/ps/call.html explanation of call operator "&"
#even though it looks like we are dot sourcing the file - it doesn't effect the launching namespace because it is calling 'start-process'
function fQuickn ($arg = "home") {
    push-location $env:homepath
    $runThis = join-path (resolve-path dropbox).path -ChildPath \Private\Q\LoadQuickenDb.ps1
    pop-location; "String is {0}" -f $runThis
    start-process powershell -Args "-noprofile -command & {. '$runThis' $arg.qdf -speak }"  #"note how $runThis is in single quotes - Super Computer"
    remove-variable runThis
}
set-alias -name Quickn -value fQuickn -Option Readonly -force -passthru | format-list
DECAPRECATED
#>
#region Quickn Q U I C K E N
"*** Version::2019-05-31.0"
function Show-Quickn ($arg = "home") {
    $arg+=".qdf"
    push-location $env:homepath
    $runThis = join-path (resolve-path dropbox).path -ChildPath \Private\Q\LoadQuickenDb1.ps1
    pop-location; "String is {0}" -f $runThis
    #This was the way to launch the old script before it was a function with params.
      #start-process powershell -Args "-noprofile -command & {. '$runThis' $arg.qdf -speak }"  #"note how $runThis is in single quotes - Super Computer"
    #This is to launch the script modified to be a function with params.
      powershell.exe -noprofile -file $runThis  -Filename $arg -Speak
    #Version::2019-06-07.0
    #Current invocation follows. Because 'Super Computer' has an embedded space we still need to muck with single quotes.
    #start-process -RedirectStandardError $env:homepath\fred.out Powershell.exe -Args "-noprofile -command & {. '$runThis'  -Filename $arg -Speak}"
<#     $command="-command  '$runThis' -Filename $arg -Speak"
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
    $encodedCommand = [Convert]::ToBase64String($bytes)
        start-process -RedirectStandardError $env:homepath\fred.out powershell.exe -args "-noprofile -encodedCommand $encodedCommand"
 #>    remove-variable runThis
}
set-alias -name Quickn -value Show-Quickn -Option Readonly -force -passthru | format-list
#endregion test
function QuicknLog {start-process notepad2 -args $env:homedrive\$env:homepath\Documents\Quicken\Powershell.out}
#end-region Quickn

'Alias ReadGmail'
function ShowGmail {Start-Process -filepath chrome.exe -argumentlist www.gmail.com}
#
function showContacts{start-process chrome.exe -ArgumentList "https://contacts.google.com/?hl=en&tab=mC"}
function showCalendar{start-process chrome.exe -ArgumentList "https://www.google.com/calendar?tab=wc"}

#https://peter.sh/experiments/chromium-command-line-switches/#load-extension
'Alias ReadGmail'
function ShowGmailIncognito {Start-Process -filepath chrome.exe -argumentlist "--incognito www.gmail.com"}
#
'Alias EventShutdown'
#function fEventShutdown {get-eventlog -logname system |? {$_.eventid -in 41,1074,6006,6008} }
function fEventShutdown ($arg = 0) {get-winevent -LogName system | where-object {$_.id -in 1, 41, 42, 107, 1074, 6006, 6008 -and $_.timecreated -ge [datetime]::today.Adddays(-$arg)} |select-object timecreated, id, InstanceId, message | sort-object -property timecreated |format-list *;get-date}
set-alias -name ShutdownEvent -value fEventShutdown -Option Readonly -force -passthru | format-list
#
function fSayIt {push-location $env:homepath; .\script\speakclip.ps1; pop-location}
set-alias -name SayIt -value fSayIt -Option Readonly -force -passthru | format-list

function StartExplorerHere {start-process explorer -ArgumentList (get-location)}

function startscanner {$scan="C:\Program Files (x86)\Canon\MP Navigator EX 2.0\mpnex20.exe";start-process $scan;Start-Sleep -seconds 1;if (get-process mpnex20){"Patience is a virtue."}else{"Oops!"}}

function Search-Google {
    Begin {
        Write-Warning "In function $($MyInvocation.MyCommand.Name): "
        $query = 'https://www.google.com/search?q='
    }
    Process {
        if ($args.Count -eq 0) {
            "Args were empty, commiting `$input to `$args"
            Set-Variable -Name args -Value (@($input) | ForEach-Object { $_ })
            "Args now equals $args"
            $args = $args.Split()
        }
        ELSE {
            "Args had value, using them instead"
        }
        <#
        Write-Host $args.Count, "Arguments detected"
        "Parsing out Arguments: $args"
        for ($i = 0; $i -le $args.Count; $i++) {
            $args | ForEach-Object { "Arg $i `t $_ `t Length `t" + $_.Length, " characters" }
        }
        $args | ForEach-Object { $query = $query + "$_+" }
        #>
    }
    End {
        <#
        $url = $query.Substring(0, $query.Length - 1)
        "Final Search will be $url `nInvoking..."
        Start-Process "$url"
#>
        $search = $args
        ($url=$query + $search) #display on console
        Start-Process $url
    }
}#END Search-Google
set-alias -name SearchGoogle -value Search-Google  -option readonly -force -passthru | format-list


function Start-TurboTax {start-process explorer "C:\Program Files (x86)\TurboTax\Home & Business 2018\32bit\turbotax.exe"}
set-alias -name ttax -value Start-TurboTax  -option readonly -force -passthru | format-list
function cdttax {set-location $env:homepath\Dropbox\Private\Tax\TurboTax}

# Get Last Command - copies the last n commands to the clipboard
Function CopyHistoryCommands($Number)
{
  $CommandLength = (Get-History | Measure-Object).Count
  $Start = $CommandLength - $Number + 1
  [array]$CommandRange = @()
  Foreach ($obj in ($Start..$CommandLength)) { $CommandRange+=$obj; $obj++ }
  #Foreach ($obj in ($Start .. $CommandLength)) {$CommandRange += $obj}
  (Get-History $CommandRange).CommandLine | Clip
  Write-Host -NoNewline "Last ";Write-Host -NoNewLine -ForegroundColor Green "$($Number) ";Write-Host "commands have been copied to the clipboard."
}

#copy by id to clipboard
function CopyHistoryById
{
    param ( [int]$Id = (Get-History -Count 1).Id );
    $history = Get-History -Id $Id -ErrorAction SilentlyContinue -ErrorVariable getHistoryError;
    if ($getHistoryError)
    {
        Write-Warning "$($MyInvocation.MyCommand.Name): $($getHistoryError.Exception.Message)";
    } # if ($getHistoryError) ...
    else
    {
        $history.CommandLine | clip.exe;
    } # if ($getHistoryError) ... else
}
#New-Alias -Force -ErrorAction SilentlyContinue chy Copy-History;

function Show-Desktop {
$x = New-Object -ComObject Shell.Application
$x.ToggleDesktop()
$x=$null
}
set-alias showDesktop -value Show-Desktop -Option Readonly -force -passthru | format-list
#"Version::2019-05-14.0"
function startkeepass {start-process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\KeePass 2.lnk"}

function EditMedicalHistory {invoke-item (join-path $env:HOMEPATH\dropbox\private\MedicalSpecial "Medical Conditions.docx")}


#
'Add Type accelerators'
#define type accelerator for type accelerators #https://blogs.technet.microsoft.com/heyscriptingguy/2013/07/08/use-powershell-to-find-powershell-type-accelerators/
$xlr = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
$xlr::Add('accelerators', $xlr)
"Try this '[accelerators]::get'"
set-location $env:homepath
"EOF"
#(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
#Don't use PSReadLine with Powershell ISE
#If(System.Management.Automation.Internal.Host.InternalHost.Name -eq 'ConsoleHost') {import-module -versbose PSReadline}
#If($Host.Name -eq 'ConsoleHost') {import-module -verbose PSReadline}
write-warning "Try Windows Admin Center localhost:6516"
write-warning "https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/overview#introduction"
#end-regionProfile


