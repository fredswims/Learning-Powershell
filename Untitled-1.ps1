



function my-function
{
    
    [cmdletbinding()]
    
    Param()
    write-host "fred was here"
    Read-Host   "this is a read prompt" 
    Write-Verbose "verbose stream" -Verbose
    Write-Debug "this is a debug string" 
}


$oldverbose=$VerbosePreference
write-host "the current value of VerbosePreference is $oldverbose"
read-host "did you get that?"
$VerbosePreference="continue"
write-host "you have reached the operator"
read-host 'please tell me your name'
my-function
Write-Verbose -Message "i am really tring to understand what this verbose stream is"
$VerbosePreference=$oldverbose
