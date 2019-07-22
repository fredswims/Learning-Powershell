<#
https://tfl09.blogspot.com/2019/07/windows-forms-working-in-powershell-7.html
Thomas Lee's collection of random interesting items, views on things, mainly IT related, as well as the occasional rant

Monday, July 22, 2019
Windows Forms - working in PowerShell 7 Preview2
One long-anticipated feature of what is soon to be PowerShell 7 is the use of Windows Forms. Technically, it is the .NET Framework that provides for form handling, but with the latest Preview.2 of PowerShell 7, this is now possible!

Here is a Windows Forms-based script that now works just fine in Powershell 7 Preview 2.

First, here is the code:
#>
# Get-Shares Windows Forms Script
#

# Load System.Windows.Forms
Add-Type -Assembly System.Windows.Forms

# Get PowerShell version details
$Maj = $PSVersionTable.PSVersion.Major
$Min = $PSVersionTable.PSVersion.Minor
$Ver = "$Maj.$Min"

# Create form
$Form = New-Object Windows.Forms.Form
$Form.Width = 750
$Form.Height = 650
$Form.Text = "My First Windows Forms Application - PowerShell Version $ver"

# Create a "computer name" label control and add it to the form
# Set label location, text, size, etc
$Label1 = New-Object Windows.Forms.Label
$Label1.Location = New-Object Drawing.Point 50, 50
$Label1.Text     = "Computer Name:"
$Label1.Visible  = $true
$Form.Controls.Add($Label1)

# Create a text box to get computer name and add to form
$Text1 = new-object windows.forms.textbox
$Text1.Location = New-Object system.drawing.point 150, 50
$Text1.Text     = "Localhost"
$Text1.Visible  = $true
$Form.Controls.add($text1)

# Create a label to output stuff
$Label2 = New-Object Windows.Forms.Label
$Label2.Location = New-Object Drawing.Point 50, 100
$Label2.Width    = 750
$Label2.Height   = 360
$Label2.Text     = ""
$Label2.Visible  = $true
$Form.Controls.Add($Label2)

# Create a button to get the shares
$Button1          = New-Object Windows.Forms.Button
$Button1.text     = "Push To Get Shares"
$Button1.width    = 150
$Button1.location = new-object drawing.point 350, 50

# Define Getting Shares Button Click handler
$Button1_OnClick = {
  $Label1.Text = "Getting Shares"
  $Shares = Get-CimInstance WIn32_Share -ComputerName $Text1.Text
  $Label2.Font = [System.Drawing.Font]::new('Courier New', 10)

  $Label2.Text = "Shares on $($Text1.Text):`n"
  Foreach ($Share in $Shares) {
    $Name = $Share.Name
    If ($Name.Length -gt 17) {
      $name = $($Name.substring(0,17)+'...').padright(16)
      }

    $Path = $share.Path
    $Label2.Text += "{0,-20}  {1}`n" -f $Name, $Path
  }
  $Label1.Text = "Computer Name:"
}

# Add the script block handler
$Button1.Add_Click($Button1_Onclick)
$Form.Controls.Add($button1)

# Now create a button to close window
$Button2          = New-Object Windows.Forms.Button
$Button2.Text     = "Push To Close Form"
$Button2.Width    = 150
$Button2.Location = New-Object drawing.point 160, 550

# Define Button Click handler
$Button2_OnClick = {
  $Form.Close()
}

# Add the script block handler
$Button2.Add_Click($Button2_Onclick)
$Form.Controls.add($Button2)

$form.showdialog()
