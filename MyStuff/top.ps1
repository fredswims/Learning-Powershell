function Get-MetricBar {
 
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, Position=0, ValueFromPipelineByPropertyName)]
        [Alias('Key')]
        $Metric,
       
        [Parameter(Mandatory=$True, Position=1, ValueFromPipelineByPropertyName)]
        [Alias('Value')]
        $MetricValue
    )

    Process {
        # Generate string respresenting metric bar for the metric in the pipeline.
        -join @(
            $Metric.toUpper()
            ': '
            ' ' * (20 - $Metric.Length)
            '▓' * $MetricValue
            '░' * (100 - $MetricValue)
        )
    }
}

Function Get-Graph {
    [cmdletbinding()]
    Param(
            [Parameter(Mandatory=$true)]
            [int[]] $Datapoints
    )

    # Create a 2D Array to save datapoints in a 2D format
    $Array = New-Object 'object[,]' ($Datapoints.Count + 1), 10
    $Counter = 0

    $Datapoints | ForEach-Object {
        $DatapointRounded = [Math]::Floor($_/10)
        
        1..$DatapointRounded | ForEach-Object {
            $Array[$Counter,$_] = 1
        }
        $Counter++
    }
 
    # Draw graph by drawing each row line-by-line, top-to-bottom.
    ForEach ($RowHeigth in (10..0)) {
        
        #Assembly of each row.
        $Row = ''

        Foreach ($DatapointLocation in (0..($BufferSizeWidth -1))) {
            if ($null -eq $Array[$DatapointLocation,$RowHeigth]) {
                $Row = [string]::Concat($Row, '░')
            }
            else {
                $Row = [string]::Concat($Row, '▓')
            }   
        }

        # To color the graph depending upon the datapoint value.
        switch ($RowHeigth) {
            {$RowHeigth -gt 7} { Write-Host $Row -ForegroundColor DarkRed }
            {$RowHeigth -le 7 -and $RowHeigth -gt 4} { Write-Host $Row -ForegroundColor DarkGray }
            {$RowHeigth -le 4 -and $RowHeigth -ge 1} { Write-Host $Row -ForegroundColor DarkCyan }
        }
    }
}

function Show-PerformanceMetrics {
    Clear-Host

    $BufferSizeWidth = $host.UI.RawUI.BufferSize.Width
    $LoadHistory = @()

    while (1) {
        # Calculate different metrics. Can be updated by editing the value-key pairs in $Currentload.
        $OS = Get-Ciminstance Win32_OperatingSystem
        $CurrentLoad = [ordered]@{
            "CPU Load" = (Get-CimInstance win32_processor).LoadPercentage
            "RAM Usage" = (100 - ($OS.FreePhysicalMemory/$OS.TotalVisibleMemorySize)*100)
            "Pagefile Usage" = (100 - ($OS.FreeVirtualMemory/$OS.TotalVirtualMemorySize)*100)
        }

        $LoadHistory += $CurrentLoad
 

        # Reset cursor and overwrite prior output
        $host.UI.RawUI.CursorPosition = @{x=0; y=1}

        # Output on screen
        Get-Graph -Datapoints ($LoadHistory."CPU Load" | Select-Object -Last $BufferSizeWidth)
        
        Write-host ""
        
        $CurrentLoad.GetEnumerator() | Get-MetricBar | Write-Host -ForegroundColor "DarkCyan"
        
        Write-host ""
        
        Get-Process | Sort-Object CPU -desc | Select-Object -first 5 | Format-Table -RepeatHeader
    }
}


Show-PerformanceMetrics