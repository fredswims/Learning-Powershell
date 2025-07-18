using namespace WinUIShell
if (-not (Get-Module WinUIShell)) {
    Import-Module WinUIShell
}


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

<# 
$button1 = [Button]::new()
$button1.Content = 'Click Me'
$button1.HorizontalAlignment = 'Right'
$button1.VerticalAlignment = 'Top'
$button1.AddClick({
    $button1.Content = 'Clicked bottom 1!'
})
$win.Content = $button2
#>

$win.Content = $button
# Activate() shows the window but does not block the script.
$win.Activate()
# If you dot-source the script and comment out $win.WaitForClosed(), you can inspect UI objects or even modify them on the terminal; e.g., $button
$win.WaitForClosed() 


Adding a Panel:
Import-Module WinUIShell
using namespace WinUIShell

$win = [Window]::new()
$win.Title = 'Two Buttons Demo'
$win.AppWindow.ResizeClient(400, 200)

# Create a vertical StackPanel
$panel = [StackPanel]::new()
$panel.Orientation = 'Vertical'
$panel.VerticalAlignment = 'Center'
$panel.HorizontalAlignment = 'Center'
$panel.Spacing = 10

# First button
$button1 = [Button]::new()
$button1.Content = 'Click Me 1'
$button1.AddClick({ $button1.Content = 'Clicked 1!' })
$panel.Children.Add($button1)

# Second button
$button2 = [Button]::new()
$button2.Content = 'Click Me 2'
$button2.AddClick({ $button2.Content = 'Clicked 2!' })
$panel.Children.Add($button2)

# Set the window content
$win.Content = $panel
$win.Activate()
$win.WaitForClosed()


# Here’s a quick snippet that adds a TextBox, CheckBox, and ProgressBar to a StackPanel:
using namespace WinUIShell
if (-not (Get-Module WinUIShell)) {
    Import-Module WinUIShell
}
$win = [Window]::new()
$win.Title = 'Two Buttons Demo'
$win.AppWindow.ResizeClient(400, 200)

$panel = [StackPanel]::new()
$panel.Orientation = 'Vertical'
$panel.Spacing = 10

$input = [TextBox]::new()
$input.PlaceholderText = 'Enter something...'
$panel.Children.Add($input)

$check = [CheckBox]::new()
$check.Content = 'I agree'
$panel.Children.Add($check)

$progress = [ProgressBar]::new()
$progress.Minimum = 0
$progress.Maximum = 100
$progress.Value = 42
$panel.Children.Add($progress)
<# 
Ah, that error means CheckBox isn’t currently exposed as a top-level type in WinUIShell — at least not in the version you’re using. 
The module is still evolving, and not all WinUI 3 controls are implemented yet, even if they exist in the native WinUI API.


If that still fails, it likely means CheckBox hasn’t been added to the module yet.
How to Check What’s Available
You can inspect the available types like this:
 #>
[AppDomain]::CurrentDomain.GetAssemblies() |
    Where-Object { $_.FullName -like '*WinUIShell*' } |
    ForEach-Object { $_.GetTypes() } |
    Where-Object { $_.Name -like '*' } |
    Select-Object FullName