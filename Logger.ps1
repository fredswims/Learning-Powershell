function loggerx {
    [CmdletBinding()]

    Param()

    <#
Simple logger.
https://blogs.technet.microsoft.com/heyscriptingguy/2013/02/23/weekend-scripter-creating-a-sample-log-file-by-using-powershell/
In another powershell run
Get-Content -Path C:\fso\mylogfile.log -Tail 1 –Wait
#>
    #read-host "Entered function and VerbosePreference is $VerbosePreference"
    $logpath = "$env:tmp\mylog.txt"
    $initpath = "$env:tmp\mylogfileInit.txt"
    [int]$numberLines = 2
    if (Test-path -pathtype Container $initpath)
    {$initLine = Get-Content $initpath} 
    Else {$initline = 0} 
    write-host "The value of initline is $initline"
    For ([int]$i = $initline; $i -le ($numberLines + $initLine); $i++) {
        $SampleString = "Added sample {0} at {1}" -f $i, (Get-Date).ToString("h:m:s")
        add-content -Path $logpath -Value $SampleString -Force
        write-verbose "ping"
        $tempfile1 = "$env:tmp\tempfile1.txt"
        $tempfile2 = "$env:tmp\tempfile2.txt"
        new-item $tempfile1
        set-content $tempfile1 "abcdefghi"
        get-content $tempfile1
        Write-Information "About to copy"
        copy-item $tempfile1 $tempfile2 
        get-content $tempfile2 
        remove-item $tempfile1
        remove-item $tempfile2
        Start-Sleep -Milliseconds 1000
    }
    $i | Out-File -FilePath $initpath -Force #if file doesn't exist it create it.
}
###############################
$transpath = "$env:temp\trans.txt"
if (test-path $transpath) {
    remove-item $transpath
}
    write-host "starting script"
$myVerbose = $VerbosePreference
$VerbosePreference = "SilentlyContinue"
#$VerbosePreference="continue"
#read-host $VerbosePreference
Start-Transcript $transpath
loggerx
Stop-Transcript
$VerbosePreference = $myVerbose
write-host "finis"

