# https://copilot.microsoft.com/shares/YnzhYBiweiBub8w48fx9W
# https://copilot.microsoft.com/shares/cj99LpyzeV4LjE8pZh9fK

[CmdletBinding()]
param (
    [Parameter()]
    [Int64]$Count=10
)
$source = @"
using System;
using System.Threading.Tasks;

public class ParallelExample
{
    public static void Run()
    {
        Parallel.For(0, 100, i =>
        {
            Console.WriteLine($"\tTask {i} is running on thread {System.Threading.Thread.CurrentThread.ManagedThreadId}");
        });

        Console.WriteLine("All tasks completed.");
    }
}
"@

Add-Type -TypeDefinition $source -Language CSharp
for ($i=0; $i -lt $Count; $i++) {write-host -ForegroundColor Red ("Repetition $i" );start-sleep -Milliseconds 250;[ParallelExample]::Run()}
# [ParallelExample]::Run()


# https://copilot.microsoft.com/shares/71MtihfHpcM7judE9wj9X
