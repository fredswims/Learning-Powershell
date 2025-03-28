function fjApplyVirusDefinition {
    # FAJ Sept 2024 
    # File -> 'Apply-VirusDefinition.ps1'
    # https://www.microsoft.com/en-us/wdsi/defenderupdates
    Write-Warning "In function $($MyInvocation.MyCommand.Name):"
    
    #diagnostic info
        "Process [{0}] Parent [{1}]" -f `
            (get-process -Id $pid).processname, (get-process -Id $pid).Parent.name
        get-host -verbose
        "*****PSCommandPath***************" 
        $PSCommandPath|format-list *
        "*********************"
    #end diagnostic info
    
    $file = join-path $env:HOME "Downloads\mpam-fe.exe"
    $sourceUrl = "https://go.microsoft.com/fwlink/?LinkID=121721&arch=arm64"
    if (test-path -Verbose -Path $file) { remove-item $file -Verbose }
    # download latest virus definition file.
    # Use Start-BitsTransfer to download the file. 
    $parameters = @{
        Source      = $sourceUrl
        Destination = $file
        DisplayName = 'Threat detections for Microsoft Defender Antivirus and other Microsoft antimalware.'
    }
    "Show Parameters"
    $parameters
    Start-BitsTransfer @parameters -verbose
    # Start-BitsTransfer -Source $sourceUrl -Destination $file -DisplayName $file -Verbose

    # apply the file
    if (test-path $file) { 
        # wait for file to be applied - like invoke-command but waits for it to complete.
        start-process -Verbose -Wait -filepath $file
        write-warning "$file applied"
        $parameters = @{
            FilePath     = "Chrome.exe"
            ArgumentList = 'https://www.microsoft.com/en-us/wdsi/definitions/antimalware-definition-release-notes'
        }
        $parameters
        start-process @parameters -Verbose
        # start-process chrome.exe -ArgumentList 'https://www.microsoft.com/en-us/wdsi/definitions/antimalware-definition-release-notes'
    }
    else { write-error ("File '$file' was not found.") }
    if (test-path $file) { remove-item $file -Verbose }
    
    Start-Sleep -Seconds 30 -Verbose
    Write-Warning "Leaving function $($MyInvocation.MyCommand.Name):"
    exit
}#fjApplyVirusDefinition

fjApplyVirusDefinition