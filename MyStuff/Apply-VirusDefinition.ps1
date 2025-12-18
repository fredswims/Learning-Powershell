    [CmdletBinding()]
    param ([Int32]$Seconds = 15)
    # FAJ Sept 2024 
    # File -> 'Apply-VirusDefinition.ps1'
    # https://www.microsoft.com/en-us/wdsi/defenderupdates
    write-warning "In [$PSCommandPath]"
    Write-Host "=== Invocation ==="
Write-Host "Command Line: $($MyInvocation.Line)"
$MyInvocation.Line
Write-Host "Bound Parameters:"
$PSBoundParameters | ConvertTo-Json -Depth 3
Write-Host "Raw Args:"
$args | ForEach-Object { "`t$_" }
read-host "Press Enter to continue..."
[System.Environment]::commandline
read-host "Press Enter to continue..."
read-host "MyInvocation Details:"
$MyInvocation
Read-Host "Press Enter to continue..."

    try {
        $File = (Join-Path $HOME 'Downloads\mpam-fe.exe') # file path to download latest virus definition file.
        $SourceUrl = "https://go.microsoft.com/fwlink/?LinkID=121721&arch=arm64"
    
        if (test-path -Path $File) { remove-item $File -Verbose }
    
        # Use Start-BitsTransfer to download the latest virus definition file. 
        $parameterSplat = @{
            Source      = $SourceUrl
            Destination = $File
            DisplayName = 'Threat detections for Microsoft Defender Antivirus and other Microsoft antimalware.'
        }
        Start-BitsTransfer @parameterSplat -verbose
        write-host "Download complete -> [$File] "

        Write-host "Applying file [$File]"
        # Apply the file and wait for it to complete.
        start-process -Verbose -Wait -filepath $File
        write-host "$File applied"
        
        # open web page with release notes.
        $parameterSplat = @{
            FilePath     = "Chrome.exe"
            ArgumentList = 'https://www.microsoft.com/en-us/wdsi/definitions/antimalware-definition-release-notes'
        }
        $parameterSplat
        start-process @parameterSplat -Verbose
    }
    catch {
        write-host -ForegroundColor Red "Error in [$PSCommandPath]"
        write-error $_.Exception.Message
        Get-Error
        Read-Host ("Press Enter to continue...")
    }
    Finally {
        if (test-path $File) { remove-item $File -Verbose }
        Write-Warning "Leaving [$PSCommandPath] in $Seconds seconds..."
        Start-Sleep -Seconds $Seconds -Verbose
    }