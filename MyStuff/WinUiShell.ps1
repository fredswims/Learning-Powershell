# Import-Module WinUIShell
using namespace WinUIShell

$win = [Window]::new()
$win.Title = 'Hello from PowerShell!'
$win.AppWindow.ResizeClient(400, 200)

$button = [Button]::new()
$button.Content = 'Click Me'
$button.HorizontalAlignment = 'Center'
$button.VerticalAlignment = 'Center'
$button.AddClick({
    $button.Content = 'Clicked!'
})

$win.Content = $button
# Activate() shows the window but does not block the script.
$win.Activate()
If you dot-source the script and comment out $win.WaitForClosed(), you can inspect UI objects or even modify them on the terminal; e.g., $button
# $win.WaitForClosed() 