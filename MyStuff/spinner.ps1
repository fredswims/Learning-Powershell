# 1. Define the characters
$spinner = @('|', '/', '-', '\')
$i = 0

# 2. Simulate a background task (e.g., waiting for updates)
Write-Host "Checking for updates... " -NoNewline

# Replace this with your actual update logic loop
for ($x = 1; $x -le 20; $x++) {
    # Print the current character and return the cursor to the start of the line
    Write-Host ("`rChecking for updates... " + $spinner[$i % 4]) -NoNewline
    
    $i++
    Start-Sleep -Milliseconds 150 # Speed of rotation
}

Write-Host "`rUpdates Complete!          "
