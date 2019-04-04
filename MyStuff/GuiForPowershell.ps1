<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
http://poshland.pro/elements-user-interface-powershell/?fbclid=IwAR34m6R83A-vVqYbQsdHnBHYhq0ap8jRtrWT-9Ywz7TO3EvrxIulQ_Oq03E
.NAME
    Untitled
#>
 
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
 
$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '575,541'
$Form.text                       = "Form"
$Form.TopMost                    = $false
 
$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 100
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(11,47)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'
 
$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "button"
$Button1.width                   = 60
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(145,40)
$Button1.Font                    = 'Microsoft Sans Serif,10'
 
$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "label"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(19,20)
$Label1.Font                     = 'Microsoft Sans Serif,10'
 
$CheckBox1                       = New-Object system.Windows.Forms.CheckBox
$CheckBox1.text                  = "checkBox"
$CheckBox1.AutoSize              = $false
$CheckBox1.width                 = 95
$CheckBox1.height                = 20
$CheckBox1.location              = New-Object System.Drawing.Point(8,90)
$CheckBox1.Font                  = 'Microsoft Sans Serif,10'
 
$CheckBox2                       = New-Object system.Windows.Forms.CheckBox
$CheckBox2.text                  = "checkBox"
$CheckBox2.AutoSize              = $false
$CheckBox2.width                 = 95
$CheckBox2.height                = 20
$CheckBox2.location              = New-Object System.Drawing.Point(6,124)
$CheckBox2.Font                  = 'Microsoft Sans Serif,10'
 
$ListBox1                        = New-Object system.Windows.Forms.ListBox
$ListBox1.text                   = "listBox"
$ListBox1.width                  = 176
$ListBox1.height                 = 83
@('Item1','Item2','Item3') | ForEach-Object {[void] $ListBox1.Items.Add($_)}
$ListBox1.location               = New-Object System.Drawing.Point(12,157)
 
$RadioButton1                    = New-Object system.Windows.Forms.RadioButton
$RadioButton1.text               = "radioButton"
$RadioButton1.AutoSize           = $true
$RadioButton1.width              = 104
$RadioButton1.height             = 20
$RadioButton1.location           = New-Object System.Drawing.Point(223,150)
$RadioButton1.Font               = 'Microsoft Sans Serif,10'
 
$RadioButton2                    = New-Object system.Windows.Forms.RadioButton
$RadioButton2.text               = "radioButton"
$RadioButton2.AutoSize           = $true
$RadioButton2.width              = 104
$RadioButton2.height             = 20
$RadioButton2.location           = New-Object System.Drawing.Point(225,190)
$RadioButton2.Font               = 'Microsoft Sans Serif,10'
 
$DataGridView1                   = New-Object system.Windows.Forms.DataGridView
$DataGridView1.width             = 300
$DataGridView1.height            = 250
$DataGridView1.location          = New-Object System.Drawing.Point(26,264)
 
$Form.controls.AddRange(@($TextBox1,$Button1,$Label1,$CheckBox1,$CheckBox2,$ListBox1,$RadioButton1,$RadioButton2,$DataGridView1))

$form.ShowDialog()