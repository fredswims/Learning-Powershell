$MaxClockSpeed = (Get-CimInstance CIM_Processor).MaxClockSpeed
$ProcessorPerformance = (Get-Counter -Counter "\Processor Information(_Total)\% Processor Performance").CounterSamples.CookedValue
$CurrentClockSpeed = [math]::round(($MaxClockSpeed/1000) * ($ProcessorPerformance / 100),3)

Write-Host "Current Processor Speed in GHz: " -ForegroundColor Yellow -NoNewLine
Write-Host $CurrentClockSpeed -NoNewline
Write-Host "  Performance " -ForegroundColor Yellow -NoNewLine
Write-Host " $([math]::round(($ProcessorPerformance / 100),3))" -NoNewline
Write-Host "  Max Clock Speed in GHz: " -ForegroundColor Yellow -NoNewLine
Write-Host ($MaxClockSpeed / 1000)