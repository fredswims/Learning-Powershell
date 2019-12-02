#https://gist.github.com/jdhitsolutions/d175558be5486af4cf69224e2184e50b#file-magicoracle-ps1
#Jeff Hicks

Try {
    #try to load the WPF assemblies
    Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
    Add-Type -AssemblyName PresentationCore -ErrorAction Stop
    Add-Type -AssemblyName WindowsBase -ErrorAction Stop
}
Catch {
    Write-Warning "Failed to load required WPF assemblies. This script requires Windows PowerShell, or PowerShell 7 Preview 4 or later on a Windows platform."
    #bail out
    return
}

#define an array of answers. One will be randomly selected.
#keep your answers short
$answers = @(
    "It is hard to say"
    "No"
    "Maybe"
    "Yes"
    "Absolutely"
    "Try again"
    "Don't give up"
    "Only you can know your soul"
    "What have you got to lose?"
    "Unknown"
    "The answer is murky"
    "Give up"
    "Only you can answer that"
    "Sleep on it"
    "When you are ready"
    "Why not?"
    "Prepare"
    "It is so"
    "You must be kidding"
    "There is no good answer"
    "There is no wrong answer"
    "Seek help from others"
    "This is nonsense"
    "Phone home"
    "Perhaps"
    "In your dreams"
    "Focus"
    "Dream On It"
    "You can only try"
    "Failure is always an option"
    "One can hope"
    "try another day"
    "It is written"
    "truly"
    "danger"
    "be wise"
    "be bold"
    "you make your own luck"
    "do you feel lucky?"
    "look for the answer within"
    "46"
    "karma is kind to you"
    "there is no answer"
    "there is no spoon"
    "I've got a bad feeling about this"
    "highly illogical"
    "I'm a magic 8 ball, not a miracle worker"
    "More information is required"
    "Figure it out for yourself"

)

Try {
    $form = New-Object System.Windows.Window -ErrorAction stop
}
Catch {
    #it is possible to load the WPF assemblies but still not be able to create a form
    Write-Warning "Failed to create the form. $($_.Exception.message)"
    return
}
#define what it looks like
$form.Title = "Ask the Magic 8 Oracle"
$form.Height = 175
$form.Width = 400
$form.FontFamily = "Chiller"
$form.FontSize = 24
$form.Background = "orange"
$form.add_Loaded( { $textbox.focus() })

#create the stackpanel
$stack = New-Object System.Windows.Controls.StackPanel

#create a label
$label = New-Object System.Windows.Controls.Label
$label.HorizontalAlignment = "Left"
$label.Content = "Ask a simple yes/no or True/False question"
#add to the stack
$stack.AddChild($label)

$TextBox = New-Object System.Windows.Controls.TextBox
$TextBox.Width = $form.Width - 50

$TextBox.HorizontalAlignment = "Center"
$TextBox.Add_TextChanged( { $btn.IsEnabled = $True })

$stack.AddChild($textbox)

$btn = New-Object System.Windows.Controls.Button
$btn.Content = "_Ask for guidance"
$btn.Width = 150
$btn.HorizontalAlignment = "Center"
$btn.IsEnabled = $False

$OK = {
    if ($btn.Content -match "guidance") {
        $answer.content = $answers | Get-Random -Count 1
        $btn.content = "_Ask another question"
        $textbox.IsEnabled = $False
    }
    else {
        $answer.Content = ""
        $TextBox.Text = ""
        $textbox.focus()
        $textbox.IsEnabled = $True
        $btn.content = "_Ask for guidance"
    }
}
#add an event handler
$btn.Add_click($OK)

$stack.AddChild($btn)

$answer = New-Object System.Windows.Controls.Label
$answer.HorizontalAlignment = "center"
$answer.Width = $form.width - 50
$answer.Height = 100

$stack.AddChild($answer)

$form.AddChild($stack)
#display the form
[void]$form.showdialog()