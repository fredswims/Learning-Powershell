$MaxClockSpeed = (Get-CimInstance CIM_Processor).MaxClockSpeed
$MaxClockSpeedGHz=($MaxClockSpeed / 1000)

$ProcessorPerformance = (Get-Counter -Counter "\Processor Information(_Total)\% Processor Performance").CounterSamples.CookedValue
$ProcessorPerformancePercent = [math]::round(($ProcessorPerformance / 100),3)

$CurrentClockSpeedGHz = [math]::round(($MaxClockSpeed/1000) * ($ProcessorPerformance / 100),3)

Write-Host "Current Processor Speed in GHz: " -ForegroundColor Yellow -NoNewLine
Write-Host $CurrentClockSpeedGHz -NoNewline
Write-Host "  Performance " -ForegroundColor Yellow -NoNewLine
if ($ProcessorPerformancePercent -ge 1.0) { Write-Host  " $ProcessorPerformancePercent" -ForegroundColor Green -NoNewline }
else {
    Write-Host " $ProcessorPerformancePercent" -ForegroundColor Red -NoNewline
}
Write-Host "  Max Clock Speed in GHz: " -ForegroundColor Yellow -NoNewLine
Write-Host "$MaxClockSpeedGHz"