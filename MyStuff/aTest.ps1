function Test {
    param (
        $file,
        $path,
        [switch]$SwOne,
        [switch]$SwTwo
    )
    
   $ArgumentList = @(
            "pwsh",         # Executable
            $noExitsw,      # pwsh switch
            "-noProfile",   # pwsh switch
            "-File", $ThisScript,           #pwsh -File mode (subsequent script)
            "-Filename", $Filename,         # remaining items passed to the subsequent script.
            "-SourceDir", $SourceDir,
            "-DestinationDir", $DestinationDir,
            "-Priority", $speakSw, $PauseSw
        )
        "pwsh version [{0}]" -f $PSVersionTable.PSVersion.ToString()
        write-host "fred was here"
        $PSBoundParameters.Keys
        $argumentList += $PSBoundParameters.Keys | Where-Object { $_ -in @('SwOne','Pause','SwTwo') } | 
        ForEach-Object { "-$_" }
        $logParams = $argumentList.Clone()
        $logParams.ArgumentList = $logParams.ArgumentList | ForEach-Object {
            if ($_ -is [System.IO.FileSystemInfo]) { $_.FullName }
            else { $_ }
        }
        $logParams | ConvertTo-Json -Depth 2

}
# test -swone -swtwo


function fjStartQuicken {
    [Alias('fjQuicken')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Edit')]
        [Switch]
        $Edit,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Quicken')]
        [System.IO.FileInfo]$FileName = 'Home.qdf',
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Quicken')]
        [System.IO.DirectoryInfo]$SourceDir = (Join-Path -Path $env:Dropbox -ChildPath 'Private\Q'),
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Quicken')]
        [System.IO.DirectoryInfo]$DestinationDir = (Join-Path -path $home -ChildPath 'Documents\Quicken'),
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Quicken')]
        [Switch]
        $Speak,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Quicken')]
        [Switch]
        [switch]$noexit,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Quicken')]
        [Switch]
        $Priority, #$true

        [Parameter(Mandatory = $false, ParameterSetName = 'Quicken')]
        [Switch]
        $Pause = $false
    )

    Start-Transcript -Path (join-path $SourceDir MyLogs fjStartQuicken-$(get-date -Format 'yyyy-MM-ddTHH-mm-ss').log)
    Write-Warning "In function $($MyInvocation.MyCommand.Name): $(get-date -Format "dddd yyyy-MM-dd hh:mm:ss K")"
    $ThisScript = join-path -Resolve -path $env:dropbox -ChildPath 'Private\Q\LoadQuickenDb.ps1'
    if ($PSCmdlet.ParameterSetName -eq 'Edit') {
        Write-Host "Using parameters from ParameterSet: $($PSCmdlet.ParameterSetName)"
        code $ThisScript
        return #exit this script.
    } 
    elseif ($PSCmdlet.ParameterSetName -eq 'Quicken') {
        Write-Host "Using parameters from ParameterSet: $($PSCmdlet.ParameterSetName)"
    }
    # Setup switch parameters for calling subsequent script.
    if ($noexit) { $noExitSw = "-noexit" } else { $noExitSw = $null }
    if ($speak) { $speakSw = "-speak" } else { $speakSw = $null }
    if ($Pause) { $PauseSw = "-Pause" } else { $PauseSw = $null } 
    # https://lazyadmin.nl/powershell/start-process/?form=MG0AV3
    # if ($arg -eq 's') { $arg = "Harriet" }
    
    <# 
    if ($arg.tolower() -eq "edit") {
        Read-Host "About to edit '$ThisScript'; Let's be careful out there!"
        code $ThisScript
    }
    #>
    if ($false) {} 
    else {
        $arg += ".qdf" #add extension
        "String is {0}" -f $ThisScript
    
        ($null = 'Alternative 2') 
        # Tricky because all the variables following '-command & are dynamically built leaving room for error.
        $ArgumentList = @(
            "pwsh $noExitSw -noprofile",
            " -command & $ThisScript -Filename $Filename -SourceDir $SourceDir -DestinationDir",
            "$DestinationDir -Priority $speakSw $PauseSw"
        ) -join ' '
        
        "`n[{0}]" -f $ArgumentList #take a look at it. All the expressions should be evaluated.
        $parametersSplat = @{
            FilePath     = "conhost.exe"
            ArgumentList = $ArgumentList
        }

        ($null = 'Alternative 1') 
        # This the best. No ambiguity. All variables already evauated.
        $ArgumentList = @(
            "pwsh",         # Executable
            $noExitsw,      # pwsh switch
            "-noProfile",   # pwsh switch
            "-File", $ThisScript,           #pwsh -File mode (subsequent script)
            "-Filename", $($filename),         # remaining items passed to the subsequent script.
            "-SourceDir", $SourceDir.FullName,
            "-DestinationDir", $DestinationDir.FullName,
            "-Priority", $speakSw, $PauseSw
        )
        $parametersSplat = @{
            FilePath     = "conhost.exe"
            ArgumentList = $ArgumentList
        }

    function Get-DefaultPropertyName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object]$InputObject
    )

    $psObj = [System.Management.Automation.PSObject]::AsPSObject($InputObject)
    $defaultMember = $psObj.Members | Where-Object { $_.IsDefault }

    if ($defaultMember) {
        return $defaultMember.Name
    } else {
        Write-Warning "No default property found for type [$($InputObject.GetType().FullName)]"
        return $null
    }

}
$defaultProp = Get-DefaultPropertyName -InputObject $FileName
Write-Host "Default property: $defaultProp"
        
        "`nUsing these parameters"
        $logParams = $parametersSplat.Clone()
        $logParams.ArgumentList = $logParams.ArgumentList | ForEach-Object {
            if ($_ -is [System.IO.FileSystemInfo]) {write-host $_; $_.FullName }
            else { write-host $_;$_ }
        }
        $logParams | ConvertTo-Json -Depth 2

        # start-process @parametersSplat
          
    } # end if
    write-host "Stop-Transaction"
    Stop-Transcript
} # 
fjStartQuicken
