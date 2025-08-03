function PopBurntToast {
    param()
    <# 
        Burnt Toast MAY not work with PWSH app INSTALLED from the STORE.
        It works with an '.msi' installation. Documented as such."
    #>
    Write-Warning "In function $($MyInvocation.MyCommand.Name):"
    # [string[]]$BTtext=@()
    $IsElevated = $([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $IsOnline = test-connection www.microsoft.com -count 1 -ping -quiet
    $Process = get-process -id $PID
    if ([System.String]::IsNullOrEmpty($(get-process -id $PID).parent.id)) { $HasParent = $false } else { $HasParent = $true }

    $psReadLineString = (Get-InstalledPSResource psreadline)[0].version.ToString()
    write-host "`$PSHOME is $psHome"
    write-host ("***The process path is '{0}{1}{2}'" -f $psStyle.Blink, $Process.Path, $psStyle.BlinkOff)
    if ($HasParent) { write-host ("***The parent path is '{0}{1}{2}'" -f $psStyle.Blink, $Process.Parent.Path, $psStyle.BlinkOff) }
    
    # Build BTtext

    # Initialize an ArrayList.
    # However, you can only have three lines.
    $BTarrayList = [System.Collections.ArrayList]::new() 

    # $BTtext=@() #initialize array - becomes a string as lines concatenated.
    #1
    $BTtext = "[PWSH $($psversiontable.PSEdition) $($psversiontable.PSVersion)]"
    $BTarrayList.add( "[PWSH $($psversiontable.PSEdition) $($psversiontable.PSVersion)]")
    #2
    if ($HasParent) { $BTtext += "`n[Parent: {0}]" -f $Process.parent.name }
    if ($HasParent) { $BTarrayList.add("[Parent: {0}]" -f $Process.parent.name) } 
    #3
    $BTtext += "`n[PSReadline: $psReadLineString]"
    $BTarrayList.add("[PSReadline: $psReadLineString]")
    #4
    if ($IsOnline) { $BTtext += "`n[Online]" } else { $BTtext += "`n[Not Online]" }
    # if ($IsOnline) { $BTarrayList.add("[Online]") } else { $BTarrayList.$dd("[Not Online]") }
    #5
    if ($IsElevated) { $BTtext += "`n[Elevated]" } else { $BTtext += "`n[Not Elevated]" }
    # if ($IsElevated) {$BTarrayList.add("[Elevated]")} else {$BTarrayList.Add("[Not Elevated]")}
      
    $paramHeader = @{
        Id    = '001'
        Title = "BurntToast Version $((get-installedpsresource -name burntToast)[0].version.tostring())"
    }
    $header = New-BTHeader @paramHeader
    # $header = New-BTHeader -Id '001' -Title "BurntToast Version $((get-installedpsresource -name burntToast)[0].version.tostring())"
    
    $btn = New-BTButton -Content 'Google' -Arguments 'https://github.com/Windos/BurntToast/blob/main/Help/New-BurntToastNotification.md'
    
    # Can't get New-BTText to work
    $text1 = New-BTText -Content "Fred said This is a line with text!" -MaxLines 2 
    
    $parameters = @{       
        Attribution = "Powered by $env:Computername"
        Button      = $btn
        Header      = $header
        # Text        = $BTtext #limited to approx 120 characters
        Text        = $BTarrayList # can have 1 to 3
        # Text        = $text1 #can't ge this to work.
        Silent      = $true
        ActivatedAction = { write-host "Fred was here $(get-random) $(get-date)" }
    }
    new-BurntToastNotification @parameters 
    # write-host $BTtext
    Write-Warning "Leaving function $($MyInvocation.MyCommand.Name):"

} #end PopBurntToast
PopBurntToast