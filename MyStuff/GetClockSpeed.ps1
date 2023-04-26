Write-Warning "In module $($MyInvocation.MyCommand.Name): "
$MaxClockSpeed = (Get-CimInstance CIM_Processor).MaxClockSpeed
$MaxClockSpeedGHz=($MaxClockSpeed / 1000)

$ProcessorPerformance = (Get-Counter -Counter "\Processor Information(_Total)\% Processor Performance").CounterSamples.CookedValue
$ProcessorPerformancePercent = [math]::round(($ProcessorPerformance / 100),3)

$CurrentClockSpeedGHz = [math]::round(($MaxClockSpeed/1000) * ($ProcessorPerformance / 100),3)
# Put on one line
if ($ProcessorPerformancePercent -ge 1.0) {$color="Green"} else {$color="Red"}
Write-Host "Current Processor Speed: " -ForegroundColor Yellow -NoNewLine
Write-Host "$($CurrentClockSpeedGHz) GHz" -ForegroundColor $color -NoNewline
Write-Host "  Performance: " -ForegroundColor Yellow -NoNewLine
Write-Host  " $($ProcessorPerformancePercent)%" -ForegroundColor $color -NoNewline
Write-Host "  Max Clock Speed: " -ForegroundColor Yellow -NoNewLine
Write-Host "$($MaxClockSpeedGHz) GHz"