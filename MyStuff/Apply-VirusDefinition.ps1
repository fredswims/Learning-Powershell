Function fjApplyVirusDefinition {
    param ([Int32]$Seconds = 15)
    # FAJ Sept 2024 
    # File -> 'Apply-VirusDefinition.ps1'
    # https://www.microsoft.com/en-us/wdsi/defenderupdates
    write-warning "In [$PSCommandPath]"

    $file = (Join-Path $HOME 'Downloads\mpam-fe.exe') # file path to download latest virus definition file.
    $sourceUrl = "https://go.microsoft.com/fwlink/?LinkID=121721&arch=arm64"
    if (test-path -Path $file) { remove-item $file -Verbose }
    
    # Use Start-BitsTransfer to download the latest virus definition file. 
    $parameters = @{
        Source      = $sourceUrl
        Destination = $file
        DisplayName = 'Threat detections for Microsoft Defender Antivirus and other Microsoft antimalware.'
    }
    Start-BitsTransfer @parameters -verbose

    # apply the file
    if (test-path $file) { 
        # wait for file to be applied - like invoke-command but waits for it to complete.
        Write-Warning "Applying file '$file'..."
        start-process -Verbose -Wait -filepath $file
        write-warning "$file applied"

        # open web page with release notes.
        $parameters = @{
            FilePath     = "Chrome.exe"
            ArgumentList = 'https://www.microsoft.com/en-us/wdsi/definitions/antimalware-definition-release-notes'
        }
        $parameters
        start-process @parameters -Verbose
    }
    else {
        write-error ("File '$file' was not found.") 
    }
    if (test-path $file) { remove-item $file -Verbose }
    
    Start-Sleep -Seconds $Seconds -Verbose
    Write-Warning "Leaving $PSCommandPath"
    return $true
} # fjApplyVirusDefinition

fjApplyVirusDefinition -Seconds 15