Get-Process | Where-Object { try { (New-Timespan $_.StartTime).TotalMinutes -le 10} catch { $false } }
Get-Process | Where-Object { trap { continue }  (New-Timespan $_.StartTime).TotalMinutes -le 10 }
