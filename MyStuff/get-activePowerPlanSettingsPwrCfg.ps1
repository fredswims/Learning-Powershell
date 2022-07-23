# https://devblogs.microsoft.com/scripting/get-windows-power-plan-settings-on-your-computer-by-using-powershell/
$plan = Get-WmiObject -Class win32_powerplan -Namespace root\cimv2\power -Filter "isActive=$tru
https://devblogs.microsoft.com/scripting/get-windows-power-plan-settings-on-your-computer-by-using-powershell/e" 
https://devblogs.microsoft.com/scripting/get-windows-power-plan-settings-on-your-computer-by-using-powershell/
$regex = [regex]"{(.*?)}$"
$planGuid = $regex.Match($plan.instanceID.Tostring()).groups[1].value
powercfg -query $planGuid