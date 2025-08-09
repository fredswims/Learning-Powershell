Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

$desktop = [System.Windows.Automation.AutomationElement]::RootElement

# Corrected PropertyCondition using NameProperty directly
$condition = New-Object System.Windows.Automation.PropertyCondition(
    [System.Windows.Automation.AutomationElement]::NameProperty,
    "Quicken"
)

$quickenWindow = $desktop.FindFirst(
    [System.Windows.Automation.TreeScope]::Children,
    $condition
)

if ($quickenWindow) {
    Write-Host "Quicken window found: $($quickenWindow.Current.Name)"

    $toolsMenu = $quickenWindow.FindFirst(
        [System.Windows.Automation.TreeScope]::Descendants,
        New-Object System.Windows.Automation.PropertyCondition(
            [System.Windows.Automation.AutomationElement]::NameProperty,
            "Tools"
        )
    )

    if ($toolsMenu) {
        $invokePattern = $toolsMenu.GetCurrentPattern(
            [System.Windows.Automation.InvokePattern]::Pattern
        )
        $invokePattern.Invoke()
    } else {
        Write-Warning "Tools menu not found."
    }
} else {
    Write-Warning "Quicken window not found."
}