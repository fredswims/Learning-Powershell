# get a new queue
[System.Collections.Queue]$queue = [System.Collections.Queue]::new()
# place the initial search path(s) into the queue
$queue.Enqueue('c:\')
# add as many more search paths as you need
# they will eventually all be traversed
#$queue.Enqueue('D:\')

# while there are still elements in the queue...
    while ($queue.Count -gt 0)
    {
        # get one item off the queue
        $currentDirectory = $queue.Dequeue()
        try
        {
            # find all subfolders and add them to the queue
            # a classic recurse approach would have called itself right here
            # this approach instead pushes the future tasks just onto
            # the queue for later use
            [IO.Directory]::GetDirectories($currentDirectory) | ForEach-Object {$queue.Enqueue($_)}
        }
        catch {}
    
        try
        {
            # find all files in this folder with the given extensions
            [IO.Directory]::GetFiles($currentDirectory, '*.psm1')
            [IO.Directory]::GetFiles($currentDirectory, '*.ps1')
        }
        catch{}
    }  
    # get a new queue



# region another example 
[System.Collections.Queue]$queue = [System.Collections.Queue]::new()
# place the initial search path(s) into the queue
foreach ($item in 1 .. 10) {$queue.Enqueue($item)}
read-host "queue count $($queue.count)"


while ($queue.Count -gt 0) {
    write-host $queue.Dequeue() 
}
# endregion another example 
get-item
##

