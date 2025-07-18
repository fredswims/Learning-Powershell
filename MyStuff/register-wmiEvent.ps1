<# 
PowerShell gives you dedicated cmdlets for event logs: 
    Get-WinEvent - modern, flexible, supports XML filtering and remote access. 
    Get-EventLog - older, limited to classic logs like Application, System, Security. 
    
If you're trying to monitor new events in real time, you can use something like:
 #>
 
# This grabs events from the last second. You could wrap it in a loop to simulate live monitoring.

# Get-WinEvent -LogName System -MaxEvents 1 -FilterXPath "*[System[TimeCreated[timediff(@SystemTime) <= 1000]]]"

# Or go full reactive with:
<# 
Register-WmiEvent -Query "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_NTLogEvent'" -Action {
    Write-Host "New event: $($Event.SourceEventArgs.NewEvent.Message)"
} -SourceIdentifier "LogMonitor" -SourceIdentifier "LogMonitor"
#>
 
 <# 
To stop that event listener created with Register-WmiEvent , 
you'll want to remove the subscription using its ID or source identifier. 
Here's how to do it step by step: Stopping the Listener

1. List active subscriptions:
Get-EventSubscriber

2. Identify the one you want to stop (look for the Sourceldentifier or note the Subscriptionld ) 3. Unregister it:
Unregister-Event -SubscriptionId <YourID>
PROB

3. Unregister it:
Unregister-Event -SubscriptionId <YourID>

Unregister-Event -SourceIdentifier "LogMonitor"
 #>
<#  
Register-WmiEvent -Query "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_NTLogEvent'" -Action {
    Write-Host "New event: $($Event.SourceEventArgs.NewEvent.Message)"
} -SourceIdentifier "LogMonitor"
 #>
<# 
Register-WmiEvent: Cannot bind parameter 'Action'. 
Cannot convert the " Write-Host "New event: $($Event. SourceEventArgs. NewEvent. Message)" 
value of type "System. String" to type "System. Management. Automation.ScriptBlock"
 
Ah, classic PowerShell gotcha! 
That error means the -Action parameter is expecting a script block, 
but it's receiving a string instead. 
This usually happens when the code is copy-pasted and 
the curly braces {} are misinterpreted or wrapped in quotes. Here's how to fix it:

Correct Syntax

Make sure the action block is not quoted and is enclosed in 0 directly:
 #>

<#  
Register-WmiEvent -Query "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_NTLogEvent'" `
    -Action {
        Write-Host "New event: $($Event.SourceEventArgs.NewEvent.Message)"
    } `
    -SourceIdentifier "LogMonitor"

 #>
<#     
PowerShell treats anything in quotes as a string, not executable code. 
The -Action parameter needs a ScriptBlock, which is defined using {} without surrounding quotes. 
If you're building this dynamically or passing it from a variable, you can use:
 #>
<# 
 $action = {Write-Host "New event: $($Event.SourceEventArgs.NewEvent.Message)"}
Register-WmiEvent -Query "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_NTLogEvent'" -Action $action -SourceIdentifier "LogMonitor"

 #>
Register-CimIndicationEvent -Query "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE TargetInstance ISA 'Win32_NTLogEvent'" `
    -Namespace root\cimv2 `
    -SourceIdentifier "LogMonitor" `
    -Action {
        Write-Host "New Event Detected!"
    }