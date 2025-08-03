function PopBurntToast {
    param()
    <# 
        Burnt Toast MAY not work with PWSH app INSTALLED from the STORE.
        It works with an '.msi' installation. Documented as such."
    #>
    Write-Warning "In function $($MyInvocation.MyCommand.Name):"
    # [string[]]$myText=@()
    $IsElevated = $([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $IsOnline = test-connection www.microsoft.com -count 1 -ping -quiet
    $Process = get-process -id $PID
    if ([System.String]::IsNullOrEmpty($(get-process -id $PID).parent.id)) { $HasParent = $false } else { $HasParent = $true }

    $psReadLineString = (Get-InstalledPSResource psreadline)[0].version.ToString()
    write-host "`$PSHOME is $psHome"
    write-host ("***The process path is '{0}{1}{2}'" -f $psStyle.Blink, $Process.Path, $psStyle.BlinkOff)
    if ($HasParent) { write-host ("***The parent path is '{0}{1}{2}'" -f $psStyle.Blink, $Process.Parent.Path, $psStyle.BlinkOff) }
    
    # Build text lines

    # Initialize an ArrayList.
    # However, you can only have three lines.
    # Bug - each time $BTarrayList.add("string") an integer is displayed on the host.
    $BTarrayList = [System.Collections.ArrayList]::new() 

    # $myText=@() #initialize array - becomes a string as lines concatenated.
    #1
    $myText = "[PWSH $($psversiontable.PSEdition) $($psversiontable.PSVersion)]"
    $BTarrayList.add( "[PWSH $($psversiontable.PSEdition) $($psversiontable.PSVersion)]")
    #2
    if ($HasParent) { $myText += "`n[Parent: {0}]" -f $Process.parent.name }
    if ($HasParent) { $BTarrayList.add("[Parent: {0}]" -f $Process.parent.name) } 
    #3
    $myText += "`n[PSReadline: $psReadLineString]"
    $BTarrayList.add("[PSReadline: $psReadLineString]")
    #4
    if ($IsOnline) { $myText += "`n[Online]" } else { $myText += "`n[Not Online]" }
    # if ($IsOnline) { $BTarrayList.add("[Online]") } else { $BTarrayList.$dd("[Not Online]") }
    #5
    if ($IsElevated) { $myText += "`n[Elevated]" } else { $myText += "`n[Not Elevated]" }
    # if ($IsElevated) {$BTarrayList.add("[Elevated]")} else {$BTarrayList.Add("[Not Elevated]")}
      
    $paramHeader = @{
        Id    = '001'
        Title = "BurntToast Version $((get-installedpsresource -name burntToast)[0].version.tostring())"
    }
    $BTHeader = New-BTHeader @paramHeader
    # $header = New-BTHeader -Id '001' -Title "BurntToast Version $((get-installedpsresource -name burntToast)[0].version.tostring())"
    
    $btn = New-BTButton -Content 'Google' -Arguments 'https://github.com/Windos/BurntToast/blob/main/Help/New-BurntToastNotification.md'
    
    # Can't get New-BTText to work
    $BTText = New-BTText -Content "This is a line with text!" -MaxLines 2 -MinLines 1
    
    $parameters = @{       
        Attribution = "Powered by $env:Computername"
        Button      = $btn
        Header      = $BTHeader
        Text        = $myText #limited to approx 120 characters
        # Text        = $BTarrayList # can have 1 to 3
        # Text        = $BTText #can't ge this to work.
        # Text="fred","ellen","bea"
        # Silent      = $true
        Sound="default"
        ActivatedAction = { write-host "Fred was here $(get-random) $(get-date)" }
    }
    new-BurntToastNotification @parameters 
    # write-host $myText
    Write-Warning "Leaving function $($MyInvocation.MyCommand.Name):"

} #end PopBurntToast
Clear-Host
PopBurntToast