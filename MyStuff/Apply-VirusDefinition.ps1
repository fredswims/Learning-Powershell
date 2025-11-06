Function fjApplyVirusDefinition {
    param ([Int32]$Seconds = 15)
    # FAJ Sept 2024 
    # File -> 'Apply-VirusDefinition.ps1'
    # https://www.microsoft.com/en-us/wdsi/defenderupdates
    write-warning "In [$PSCommandPath]"

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

    # apply the file
    if (test-path $File) { 
        # wait for file to be applied - like invoke-command but waits for it to complete.
        Write-Warning "Applying file '$File'..."
        start-process -Verbose -Wait -filepath $File
        write-warning "$File applied"

        # open web page with release notes.
        $parameterSplat = @{
            FilePath     = "Chrome.exe"
            ArgumentList = 'https://www.microsoft.com/en-us/wdsi/definitions/antimalware-definition-release-notes'
        }
        $parameterSplat
        start-process @parameterSplat -Verbose
    }
    else {
        write-error ("File '$File' was not found.") 
    }
    if (test-path $File) { remove-item $File -Verbose }
    
    Write-Warning "Leaving [$PSCommandPath] in $Seconds seconds..."
    Start-Sleep -Seconds $Seconds -Verbose
    return $true
} # fjApplyVirusDefinition

fjApplyVirusDefinition -Seconds 15