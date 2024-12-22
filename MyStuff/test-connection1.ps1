$ipRange = 1..254
$network = "192.168.86" # Replace with your network prefix

$ipRange | ForEach-Object {
    $ip = "$network.$_"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        Write-Output "$ip is reachable"
    }
}

$ipRange = 249..250
$network = "192.168.86" # Replace with your network prefix

$ipRange | ForEach-Object {
    ($ip = "$network.$_")
    Test-Connection -ComputerName $ip -ResolveDestination -Traceroute -IPv4 -TimeoutSeconds .02
    }
    
    
    
    $ip="192.168.86.1"
    Test-Connection -ComputerName $ip -ResolveDestination -Traceroute -IPv4 -TimeoutSeconds 1



$ipRange = 1..250
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            Write-Output "$ip is reachable"
        }
    } -ArgumentList $ip
}

$jobs | ForEach-Object {
    wait-job -Job $_
    Receive-Job -Job $_
    Remove-Job -Job $_
}



$ipRange = 1..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            Write-Output "$ip is reachable"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete and process results
$jobs | ForEach-Object {
    Wait-Job -Job $_
    Receive-Job -Job $_
    Remove-Job -Job $_
}

$ipRange = 149..250
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            Write-Output "$ip"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete and process results
$jobs | ForEach-Object {
    Wait-Job -Job $_
    Receive-Job -Job $_ | ForEach-Object {
        Write-Output "$_ is reachable"
    }
    Remove-Job -Job $_
}


$ipRange = 1..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            "$ip is reachable"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete
Wait-Job -Job $jobs

# Retrieve and clean up job results, filtering out empty outputs
$results = $jobs | ForEach-Object {
    $output = Receive-Job -Job $_
    Remove-Job -Job $_
    if ($output) { $output }
}

# Display the results
$results | ForEach-Object { Write-Output $_ }




$ipRange = 100..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            "$ip"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete
Wait-Job -Job $jobs

# Retrieve and clean up job results, only capturing non-empty outputs
$results = $jobs | ForEach-Object {
    # Wait-Job -Job $jobs
    $output = Receive-Job -Job $_
    Remove-Job -Job $_
    if ($output) { $output }
}

# Display the reachable IP addresses
$results | Where-Object { $_ } | ForEach-Object { Write-Output "$_ is reachable" }




$ipRange = 249..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            "$ip is reachable"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete
Wait-Job -Job $jobs

# Retrieve and clean up job results, only capturing those with HasMoreData set to True
$results = $jobs | ForEach-Object {
    if ($_.HasMoreData) {
        $output = Receive-Job -Job $_
        Remove-Job -Job $_
        $output
    }
}

# Display the results
$results | ForEach-Object { Write-Output $_ }




$ipRange = 240..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip is reachable"
        } else {
            return $null
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete
Wait-Job -Job $jobs

# Retrieve and clean up job results, only capturing successful outputs
$results = $jobs | ForEach-Object {
    $output = Receive-Job -Job $_ -ErrorAction SilentlyContinue
    Remove-Job -Job $_
    if ($output) { $output }
}

# Display the results
$results | ForEach-Object { Write-Output $_ }



Get-job *
get-job *| remove-job -Force
$ipRange = 248..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip is reachable"
        } else {
            return $null
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete
Wait-Job -Job $jobs

# Retrieve and clean up job results, only capturing successful outputs
$results = $jobs | ForEach-Object {
    $output = Receive-Job -Job $_ -ErrorAction SilentlyContinue
    Remove-Job -Job $_
    if ($output -ne $null) { $output }
}

# Display the reachable IP addresses
$results | ForEach-Object { Write-Output $_ }




Get-job *
Get-job * | remove-job -force
$ipRange = 240..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip is reachable"
        } else {
            return $null
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete
read-host "about to see if all jobs done"
Wait-Job -Job $jobs
read-host "all jobs done"

# Retrieve and clean up job results, only capturing successful outputs
$results = $jobs | ForEach-Object {
    $output = Receive-Job -Job $_
    Remove-Job -Job $_
    if ($output -ne $null) {
        $output
    }
}

# Display the results
$results -ne $null | ForEach-Object { Write-Output $_ }



get-job * |remove-job -force
$ipRange = 1..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip is reachable"
        } else {
            return $null
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete
Wait-Job -Job $jobs

# Retrieve and clean up job results
$results = $jobs | ForEach-Object {
    $output = Receive-Job -Job $_
    Remove-Job -Job $_
    if ($output -ne $null) {
        $output
    }
}

# Display the reachable IP addresses
$results | ForEach-Object { Write-Output $_ }




$ipRange = 1..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip is reachable"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete
Wait-Job -Job $jobs

# Retrieve and clean up job results
$results = $jobs | ForEach-Object {
    $job = Receive-Job -Job $_ -ErrorAction SilentlyContinue
    Remove-Job -Job $_
    if ($job) { $job }
}

# Display the results
$results | ForEach-Object { Write-Output $_ }
$results





$ipRange = 1..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip is reachable"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete
read-host 'before call to wait-job'
Wait-Job -Job $jobs
read-host 'after call to wait-job'
# Retrieve and clean up job results
$results = $jobs | ForEach-Object {
    $job = Receive-Job -Job $_ -ErrorAction SilentlyContinue
    Remove-Job -Job $_
    if ($job) { $job }
}

# Display the results
$results | ForEach-Object { Write-Output $_ }




# this one

$ipRange = 1..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip is reachable"
        }
    } -ArgumentList $ip
}

read-host 'before call to wait-job'
# Wait for all jobs to complete
Wait-Job -Job $jobs
read-host 'continue'
# Retrieve and clean up job results
$results = $jobs | ForEach-Object {
    $job = Receive-Job -Job $_ -ErrorAction SilentlyContinue
    Remove-Job -Job $_
    if ($job) { $job }
}

# Display the results
$results | ForEach-Object { Write-Output $_ }



this one
$ipRange = 1..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete without outputting job details
$null = Wait-Job -Job $jobs

# Retrieve and clean up job results
$results = $jobs | ForEach-Object {
    $output = Receive-Job -Job $_
    Remove-Job -Job $_
    if ($output -ne $null) {
        $output
    }
}

# Display the reachable IP addresses
$results | ForEach-Object { Write-Output $_ }
foreach($result in $results){
    test-connection  -ComputerName  $Result  -ResolveDestination -Traceroute -IPv4 -ErrorAction SilentlyContinue|select-object -first 1
}





$ipRange = 149..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete without outputting job details
$null = Wait-Job -Job $jobs

# Retrieve and clean up job results
$results = $jobs | ForEach-Object {
    $output = Receive-Job -Job $_
    Remove-Job -Job $_
    if ($output -ne $null) {
        $output
    }
}

# Display the reachable IP addresses with additional connection details
foreach ($result in $results) {
    test-connection -ComputerName $result -ResolveDestination -Traceroute -IPv4 -ErrorAction SilentlyContinue | select-object -first 1
}





$ipRange = 249..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete without outputting job details
$null = Wait-Job -Job $jobs

# Retrieve and clean up job results
$results = $jobs | ForEach-Object {
    $output = Receive-Job -Job $_
    Remove-Job -Job $_
    if ($output -ne $null) {
        $output
    }
}

# Display the reachable IP addresses with additional connection details
foreach ($result in $results) {
    $testResult = test-connection -ComputerName $result -ResolveDestination -Traceroute -IPv4 -ErrorAction SilentlyContinue
    $filteredResult = $testResult | Where-Object { $_.Status -eq "Success" } | Select-Object -First 1
    Write-Output $filteredResult
}




$ipRange = 249..254
$network = "192.168.86" # Replace with your network prefix

$jobs = @()
$ipRange | ForEach-Object {
    $ip = "$network.$_"
    $jobs += Start-Job -ScriptBlock {
        param($ip)
        if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 1 -Quiet) {
            return "$ip"
        }
    } -ArgumentList $ip
}

# Wait for all jobs to complete without outputting job details
$null = Wait-Job -Job $jobs

# Retrieve and clean up job results
$results = $jobs | ForEach-Object {
    $output = Receive-Job -Job $_
    Remove-Job -Job $_
    if ($output -ne $null) {
        $output
    }
}

# Display the reachable IP addresses with additional connection details
foreach ($result in $results) {
    $testResult = test-connection -ComputerName $result -ResolveDestination -Traceroute -IPv4 -ErrorAction SilentlyContinue
    $filteredResults = $testResult | Where-Object { $_.Status -eq "Success" } | Select-Object -First 1
    $filteredResults | ForEach-Object { Write-Output $_ }
}
