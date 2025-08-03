function PopBurntToast {
    param()
    <# 
        Burnt Toast MAY not work with PWSH app INSTALLED from the STORE.
        It works with an '.msi' installation. Documented as such."
    #>
    Write-Warning "In function $($MyInvocation.MyCommand.Name):"
    # [string[]]$BTtext=@()
    $IsElevated=$([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $IsOnline=test-connection www.microsoft.com -count 1 -ping -quiet
    $Process=get-process -id $PID
    if ([System.String]::IsNullOrEmpty($(get-process -id $PID).parent.id)) {$HasParent=$false} else {$HasParent=$true}

    $psReadLineString = (Get-InstalledPSResource psreadline)[0].version.ToString()
    write-host "`$PSHOME is $psHome"
    write-host ("***The process path is '{0}{1}{2}'" -f $psStyle.Blink, $Process.Path, $psStyle.BlinkOff)
    if ($HasParent) {write-host ("***The parent path is '{0}{1}{2}'" -f $psStyle.Blink, $Process.Parent.Path, $psStyle.BlinkOff)}
    
    # Build BTtext
    $BTList=[System.Collections.ArrayList]::new() #limited to three lines
    # $BurntToast=@()
    $BTtext += "[PWSH $($psversiontable.PSEdition) $($psversiontable.PSVersion)]"
    $BTlist.add( "[PWSH $($psversiontable.PSEdition) $($psversiontable.PSVersion)]")
    if ($HasParent) {$BTtext += "`n[Parent: {0}]" -f $Process.parent.name}
    $BTtext += "`n[PSReadline: $psReadLineString]"
    $BTlist.add("`n[PSReadline: $psReadLineString]")
    if ($IsOnline) {$BTtext += "`n[Online]"} else {$BTtext += "`n[Not Online]"}
    if ($IsOnline) {$BTlist.add("[Online]")} else {$BTlist.$dd("[Not Online]")}
    if ($IsElevated) {$BTtext += "`n[Elevated]"} else {$BTtext += "`n[Not Elevated]"}
    # if ($IsElevated) {$BTlist.add("[Elevated]")} else {$BTlist.Add("[Not Elevated]")}
      
    $paramHeader =@{
        Id='001'
        Title="BurntToast Version $((get-installedpsresource -name burntToast)[0].version.tostring())"
    }
    $header = New-BTHeader @paramHeader
    # $header = New-BTHeader -Id '001' -Title "BurntToast Version $((get-installedpsresource -name burntToast)[0].version.tostring())"
    $btn = New-BTButton -Content 'Google' -Arguments 'https://github.com/Windos/BurntToast/blob/main/Help/New-BurntToastNotification.md'
    $parameters = @{       
        Attribution     = "Powered by $env:Computername"
        Button          = $btn
        Header          = $header
        Text        = $BTtext
        # Text            = $BtList
        Silent          = $true
        ActivatedAction = { write-host "Fred was here $(get-date)" }
    }
    new-BurntToastNotification @parameters 
    write-host $BTtext
    Write-Warning "Leaving function $($MyInvocation.MyCommand.Name):"

} #end PopBurntToast
PopBurntToast