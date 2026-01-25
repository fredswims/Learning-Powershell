<#
        .SYNOPSIS
Yes—Windows 11 uses a feature called Fast Startup, which performs a hybrid shutdown. 
To force a full restart on next boot, you can either disable Fast Startup or use a command-line shutdown that bypasses it.

Here’s how to do both:

What Fast Startup Does

Fast Startup saves the system state (kernel + drivers) to hiberfil.sys during shutdown.

On next boot, Windows resumes from this saved state—not a full cold boot.

This speeds up startup but can cause issues with drivers, firmware, or updates that expect a clean boot.

Option 1: Disable Fast Startup (Permanent Full Shutdowns)

Open Control Panel → System and Security → Power Options.

Click “Choose what the power buttons do”.

Click “Change settings that are currently unavailable”.

Uncheck “Turn on fast startup (recommended)”.

Save changes.

This ensures every shutdown is a full shutdown, but it affects all future shutdowns.

Option 2: Force Full Shutdown via Command Line (One-Time)

Use this command to bypass Fast Startup for a single shutdown:

shutdown /s /f /t 0

/s = shutdown

/f = force close apps

/t 0 = no delay

This performs a true shutdown, and the next boot will be a full restart.

Option 3: Use Restart Instead of Shutdown

If you want a clean reboot without disabling Fast Startup:

shutdown /r /f /t 0

This forces a full restart immediately, skipping Fast Startup entirely.

Bonus: Sleep Study & Modern Standby

Some devices use Modern Standby, which can mimic shutdown but keep power states active. You can run:

powercfg /sleepstudy

to audit whether your system is truly powering off.

Check Boot Type via PowerShell

To determine whether the last boot was a 
full shutdown, fast startup, or hibernation, run this PowerShell command:

Get-WinEvent -ProviderName Microsoft-Windows-Kernel-Boot -MaxEvents 10 | Where-Object { $_.Id -eq 27 } | Select-Object -ExpandProperty Message

Look for a line like:

The boot type was 0x1

Then match it to this table:

Boot Type Code

Meaning

0x0

Cold boot (full shutdown)

0x1

Fast startup (hybrid boot)

0x2

Resume from hibernation

Let me know if you want to integrate this check into a startup script or log it for diagnostics.

References (3)

Fix Restarting on Shutdown in Windows 11: Fast Startup, NIC Power .... https://windowsforum.com/threads/fix-restarting-on-shutdown-in-windows-11-fast-startup-nic-power-more.379596/

How to Fix Windows 11 Restarting Instead of Shutting Down. https://allthings.how/how-to-fix-windows-11-restarting-instead-of-shutting-down/

Is there a way to have Windows 11 actually shut down?. https://learn.microsoft.com/en-us/answers/questions/4043851/is-there-a-way-to-have-windows-11-actually-shut-do
        Frees up AI memory.
        AUTHOR:FAJ January 2026
        REVISION HISTORY:FAJ 2026.01.17 Version 1.2.0

        .DESCRIPTION
        PURPOSE: Free-Java-AI-Memory. Stops WSAIFabricSvc and related processes when physical memory is low.
        Optionally just stops the processes "WorkLoadsSessionManager", "WorkloadsSessionHost" and leaves the service running.

        .PARAMETER Id
        ?Unique string identifying this header instance. Used for replacement or updating by reuse.

        .PARAMETER Title
        ?The text displayed to the user as the header.

        .PARAMETER Arguments
        ?String data passed to Activation if the header itself is clicked.

        .PARAMETER ActivationType
        ?Enum specifying the activation type (defaults to Protocol).

        .INPUTS
        None. You cannot pipe input to this function.

        .OUTPUTS
        Custom Object: 
            Mode  - what actions were taken
            Return - ($True/$False)
        A BurntToast Notification

        .EXAMPLE
        ?New-BTHeader -Title 'First Category'
        Creates a header titled 'First Category' for categorizing toasts.

        .EXAMPLE
        ?New-BTHeader -Id '001' -Title 'Stack Overflow Questions' -Arguments 'http://stackoverflow.com/'
        Creates a header with ID '001' and links activation to a URL.

        .LINK
        ?https://github.com/Windos/BurntToast/blob/main/Help/New-BTHeader.md
    #>
    

[CmdletBinding()]
param (
    [ArgumentCompleter({
        'FullShutdown', 'Restart', 'Hibernate', 'ReportBootType'
    })]
    [ValidateSet("FullShutdown", "Restart", "Hibernate", "ReportBootType")]
    [string]$Action = "ReportBootType",
    [switch]$AllEvents = $false    
)
switch ($Action) {
    "FullShutdown" {
        Write-Host "Initiating full shutdown..."
        shutdown /s /f /t 0
    }
    "Restart" {
        Write-Host "Initiating restart..."
        shutdown /r /f /t 0
    }
    "Hibernate" {
        Write-Host "Initiating hibernation..."
        shutdown /h /f /t 0
    }
    "ReportBootType" {
        Write-Host "Reporting last boot type..."
        if ($AllEvents.IsPresent) { $all=100 } else { $all=1 }
        $bootEvents = Get-WinEvent -ProviderName Microsoft-Windows-Kernel-Boot -MaxEvents 100 | Where-Object { $_.Id -eq 27 } |select-Object -First $all
        # $bootevents | Format-List -Property name, timecreated, id, message
        foreach ($bootEvent in $bootEvents) {
            Write-Host -NoNewline "[Event Time: $($bootEvent.TimeCreated)] [Event ID: $($bootEvent.Id)] "
            if ($bootEvent) {
                # $bootType.message is a string that ends with a period.
                $bootType = ($bootEvent.Message -split "boot type was ")[1]
                Write-Host -NoNewline "[The last boot type was: $bootType] "
                switch ($bootType.Trim(".")) {
                    "0x0" { Write-Host "Meaning: Cold boot (full shutdown)" }
                    "0x1" { Write-Host "Meaning: Fast startup (hybrid boot)" }
                    "0x2" { Write-Host "Meaning: Resume from hibernation" }
                    default { Write-Host "Meaning: Unknown boot type" }
                }
            } else {
                Write-Host "No boot event found."
            }
        }
    } 
}

<# 
$logPath = "$env:ProgramData\BootTypeLog.txt"
$logPath = "$home\OneDrive\Powershell\Mystuff\BootTypeLog.txt"
$bootEvent = Get-WinEvent -ProviderName Microsoft-Windows-Kernel-Boot -MaxEvents 100 | Where-Object { $_.Id -eq 27 }
if ($bootEvent) {
    $bootType = ($bootEvent.Message -split "boot type was ")[1]
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logPath -Value "$timestamp - Boot type: $bootType"
}
 #>