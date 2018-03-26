[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$computer = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a computer name", "Computer", "$env:computername") 

#############################

BEST ANSWER
https://blogs.msdn.microsoft.com/sonam_rastogi_blogs/2015/09/01/keeping-powershell-visualbasic-messagebox-in-focus/

1.For Error
[Microsoft.VisualBasic.Interaction]::MsgBox("Some error occurred.", 
"OKOnly,SystemModal,Critical", "Error")

2. For Warning

[Microsoft.VisualBasic.Interaction]::MsgBox("Please correct fields.", 
"OKOnly,SystemModal,Exclamation", "Warning")

3. Success Messae

[Microsoft.VisualBasic.Interaction]::MsgBox("Processing Completed.", 
"OKOnly,SystemModal,Information", "Success")


[void] [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic") 
[Microsoft.VisualBasic.Interaction]::MsgBox("Some error occurred.", "OKOnly,SystemModal,Critical", "Error")
[Microsoft.VisualBasic.Interaction]::MsgBox("Please correct fields.", "OKOnly,SystemModal,Exclamation", "Warning")
[Microsoft.VisualBasic.Interaction]::MsgBox("Processing Completed.", "OKOnly,SystemModal,Information", "Success")

There are various other combinations that are part of Message Box Style Enumerator

ApplicationModal, DefaultButton1, OkOnly, OkCancel, AbortRetryIgnore, YesNoCancel, YesNo, RetryCancel, Critical, Question, Exclamation,

Information, DefaultButton2, DefaultButton3, SystemModal, MsgBoxHelp, MsgBoxSetForeground, MsgBoxRight, MsgBoxRtlReading

Use the one which suits your need.

 

Happy Coding!!!

$Answer=[Microsoft.VisualBasic.Interaction]::MsgBox("Do you want to ...", "YesNo, DefaultButton2,SystemModal,Question", "Title Goes Here")



# Example to show the InputBox on button click 
# and display entered text 
 
 
[void][System.Reflection.Assembly]::LoadWithPartialName( 
    "System.Windows.Forms") 
[void][System.Reflection.Assembly]::LoadWithPartialName( 
    "Microsoft.VisualBasic") 
     
$Form = New-Object System.Windows.Forms.Form 
$Button = New-Object System.Windows.Forms.Button 
$TextBox = New-Object System.Windows.Forms.TextBox 
 
$Form.Text = "Visual Basic InputBox Example" 
$Form.StartPosition =  
    [System.Windows.Forms.FormStartPosition]::CenterScreen 
 
$Button.Text = "Show Input Box" 
$Button.Top = 20 
$Button.Left = 90 
$Button.Width = 100 
 
$TextBox.Text = "Old value" 
$TextBox.Top = 60 
$TextBox.Left = 90 
 
$Form.Controls.Add($Button) 
$Form.Controls.Add($TextBox) 
 
$Button_Click =  
{ 
    $EnteredText =  
        [Microsoft.VisualBasic.Interaction]::InputBox( 
        "Prompt", "Title", "Default value",  
        $Form.Left + 50, $Form.Top + 50) 
     
    # If the InputBox Cancel button is clicked 
    # InputBox returns an empty string 
    # so don't change the TextBox value 
     
    if($EnteredText.Length -gt 0) 
    { 
        $TextBox.Text = $EnteredText 
    } 
} 
 
$Button.Add_Click($Button_Click) 
 
$Form.ShowDialog()

##################################################


