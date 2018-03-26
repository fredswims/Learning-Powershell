###############################################
#Send-Mail.ps1                                #
#Created by Paul Flaherty (blogs.flaphead.com)#
###############################################

$AppName = "Send-Mail.ps1"
$AppVer  = "v2.1 [5 Dec 2006]"

#Load Required Assemblies
$null=[reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
$null=[reflection.assembly]::LoadWithPartialName("System.Drawing")


#Functions Up the Top
function openCSVto{
$exFileName = new-object System.Windows.Forms.openFileDialog
$exFileName.ShowDialog()
$tocsvfile = $exFileName.FileName
$lblCSVtoFile.Text      = $tocsvfile
}

function openCSVcc{
$exFileName = new-object System.Windows.Forms.openFileDialog
$exFileName.ShowDialog()
$cccsvFile = $exFileName.FileName
$lblCSVccFile.Text      = $cccsvfile
}

function openCSVbcc{
$exFileName = new-object System.Windows.Forms.openFileDialog
$exFileName.ShowDialog()
$bcccsvFile = $exFileName.FileName
$lblCSVbccFile.Text      = $bcccsvfile
}

function openAttach{
$exFileName         = new-object System.Windows.Forms.openFileDialog
$exFileName.ShowDialog()
$script:attachFile         = $exFileName.FileName
$lblattachFile.Text = $script:attachFile
}

function openAttach2{
$exFileName = new-object System.Windows.Forms.openFileDialog
$exFileName.ShowDialog()
$script:attachFile2 = $exFileName.FileName
$lblattachFile2.Text      = $script:attachFile2
}

function openAttach3{
$exFileName = new-object System.Windows.Forms.openFileDialog
$exFileName.ShowDialog()
$script:attachFile3 = $exFileName.FileName
$lblattachFile3.Text      = $script:attachFile3
}


function closeMyDialog
{
	$olButton.Text     = "Sending.."
	$script:verbose    = $chkVerbose
	$script:msgcount   = $inMsgCount.Value
	$script:subject    = $tboxSubject.Text
	$script:body       = $tboxbody.text
	$script:server     = $tboxServer.Text

	IF ($tboxto.text.length -gt 0)
	{
		$script:message.TO.add($tboxto.text)
		$script:sendmail = $True
		$script:to = $tboxto.text
	}

	IF ($tboxcc.text.length -gt 0)
	{
		$script:message.cc.add($tboxcc.text)
		$script:sendmail = $True
		$script:cc = $tboxcc.text
	}

	IF ($tboxbcc.text.length -gt 0)
	{
		$script:message.bcc.add($tboxbcc.text)
		$script:sendmail = $True
		$script:bcc = $tboxbcc.text
	}

	IF ($lblCSVtoFile.Text.length -gt 0)
	{
		$script:tocsvfile = $lblCSVtoFile.Text
		$tocsv = import-csv $lblCSVtoFile.Text
		foreach ($csvuser in $toCSV)
		{
			$script:message.TO.add($csvuser.email)
			$script:sendmail = $True
		}
	}

	IF ($lblCSVccFile.Text.length -gt 0)
	{
		$script:cccsvfile = $lblCSVccFile.Text
		$cccsv = import-csv $lblCSVccFile.Text
		foreach ($csvuser in $ccCSV)
		{
			$script:message.cc.add($csvuser.email)
			$script:sendmail = $True
		}
	}

	IF ($lblCSVbccFile.Text.length -gt 0)
	{
		$script:cbccsvfile = $lblCSVbccFile.Text
		$bcccsv = import-csv $lblCSVbccFile.Text
		foreach ($csvuser in $bccCSV)
		{
			$script:message.bcc.add($csvuser.email)
			$script:sendmail = $True
		}
	}

	IF ($lblattachFile.Text.length -gt 0) 
	{
		$script:attachment = $script:attachment + $lblattachFile.Text + "; "
		$script:message.Attachments.Add($lblattachfile.Text)
	}

	IF ($lblattachFile2.Text.length -gt 0) 
	{
		$script:attachment = $script:attachment + $lblattachFile2.Text + "; "
		$script:message.Attachments.Add($lblattachfile2.Text)
	}

	IF ($lblattachFile3.Text.length -gt 0) 
	{
		$script:attachment = $script:attachment + $lblattachFile3.Text + "; "
		$script:message.Attachments.Add($lblattachfile3.Text)
	}


$form.close()
}


function cancelMyDialog{
$btnCanx.Text = "Closing.."
$script:SendMail = $False
$script:message = $null
$form.close()
}


Function DisplayGUI{
$form = new-object System.Windows.Forms.form
$form.Text = $appname + " " + $appver

#Setup Tabs
$tab = new-object System.Windows.Forms.tabcontrol
$tab.Location = New-object System.Drawing.Point(1, 1)
$tab.Size = New-object System.Drawing.Size(290, 330)
$tab.SelectedIndex = 0
$tab.TabIndex = 0


$tabGeneral = new-object System.Windows.Forms.tabpage
$tabTo = new-object System.Windows.Forms.tabpage
$tabcc = new-object System.Windows.Forms.tabpage
$tabbcc = new-object System.Windows.Forms.tabpage
$tabattach = new-object System.Windows.Forms.tabpage
$tabAbout = new-object System.Windows.Forms.tabpage

$tabGeneral.Text = "General"
$tabGeneral.Size = New-object System.Drawing.Size(300, 250)
$tabGeneral.TabIndex = 0
$tab.controls.add($tabGeneral)

$tabTo.Text = "To"
$tabTo.Size = New-object System.Drawing.Size(300, 450)
$tabTo.TabIndex = 1
$tab.controls.add($tabTo)

$tabcc.Text = "Cc"
$tabcc.Size = New-object System.Drawing.Size(300, 450)
$tabcc.TabIndex = 2
$tab.controls.add($tabcc)

$tabBcc.Text = "Bcc"
$tabBcc.Size = New-object System.Drawing.Size(300, 450)
$tabBcc.TabIndex = 3
$tab.controls.add($tabBcc)

$tabAttach.Text = "Attachment"
$tabAttach.Size = New-object System.Drawing.Size(300, 250)
$tabAttach.TabIndex = 4
$tab.controls.add($tabAttach)

$tabAbout.Text = "About"
$tabAbout.Size = New-object System.Drawing.Size(300, 250)
$tabAbout.TabIndex = 4
$tab.controls.add($tabAbout)

$lblAbout           = New-Object System.Windows.Forms.Label
$lblAbout.Location  = New-Object System.Drawing.Size(15,15)
$lblAbout.Size      = New-Object System.Drawing.Size(260,100)
$lblAbout.Text      = $appName + " " + $AppVer + "`n`nCreated by Paul Flaherty`n`n Http://blogs.flaphead.com`n`n`nCommand Line:"
$tabAbout.Controls.Add($lblAbout) 


#To Dialog Bits
$tboxto           = New-Object System.Windows.Forms.TextBox
$tboxto.Location  = New-Object System.Drawing.Size(15,15)
$tboxto.Size      = New-Object System.Drawing.Size(260,23)
$tboxto.Text      = $to
$tabTo.Controls.Add($tboxto) 

$btnCSVto          = new-object System.Windows.Forms.Button
$btnCSVto.Location = New-Object System.Drawing.Size(15,40)
$btnCSVto.Size     = New-Object System.Drawing.Size(95,23)
$btnCSVto.Text     = "Select CSV File"
$btnCSVto.Add_Click({openCSVto})
$tabTo.Controls.Add($btnCSVto)

$lblCSVtoFile           = New-Object System.Windows.Forms.Label
$lblCSVtoFile.Location  = New-Object System.Drawing.Size(115,40)
$lblCSVtoFile.Size      = New-Object System.Drawing.Size(160,20)
$lblCSVtoFile.Text      = $tocsvfile
$tabTo.Controls.Add($lblCSVtoFile) 

$gboxTo = New-Object System.Windows.Forms.GroupBox
$gboxTo.Location = New-Object System.Drawing.Size(12,0)
$gboxTo.Size = New-Object System.Drawing.Size(270,70)
$gboxTo.Text = "To:"
$tabTo.controls.add($gboxTo)

#cc Dialog bits
$tboxcc          = New-Object System.Windows.Forms.TextBox
$tboxcc.Location  = New-Object System.Drawing.Size(15,15)
$tboxcc.Size      = New-Object System.Drawing.Size(260,23)
$tboxcc.Text      = $cc
$tabCc.Controls.Add($tboxcc) 

$btnCSVcc          = new-object System.Windows.Forms.Button
$btnCSVcc.Location = New-Object System.Drawing.Size(15,40)
$btnCSVcc.Size     = New-Object System.Drawing.Size(95,23)
$btnCSVcc.Text     = "Select CSV File"
$btnCSVcc.Add_Click({openCSVcc})
$tabCc.Controls.Add($btnCSVcc)

$lblCSVccFile           = New-Object System.Windows.Forms.Label
$lblCSVccFile.Location  = New-Object System.Drawing.Size(115,40)
$lblCSVccFile.Size      = New-Object System.Drawing.Size(160,20)
$lblCSVccFile.Text      = $cccsvfile
$tabCc.Controls.Add($lblCSVccFile) 

$gboxcc = New-Object System.Windows.Forms.GroupBox
$gboxcc.Location = New-Object System.Drawing.Size(12,0)
$gboxcc.Size = New-Object System.Drawing.Size(270,70)
$gboxcc.Text = "Cc:"
$tabCc.controls.add($gboxcc)

#bcc Dialog bits
$tboxbcc          = New-Object System.Windows.Forms.TextBox
$tboxbcc.Location  = New-Object System.Drawing.Size(15,15)
$tboxbcc.Size      = New-Object System.Drawing.Size(260,23)
$tboxbcc.Text      = $bcc
$tabBcc.Controls.Add($tboxbcc) 

$btnCSVbcc          = new-object System.Windows.Forms.Button
$btnCSVbcc.Location = New-Object System.Drawing.Size(15,40)
$btnCSVbcc.Size     = New-Object System.Drawing.Size(95,23)
$btnCSVbcc.Text     = "Select CSV File"
$btnCSVbcc.Add_Click({openCSVbcc})
$tabBcc.Controls.Add($btnCSVbcc)

$lblCSVbccFile           = New-Object System.Windows.Forms.Label
$lblCSVbccFile.Location  = New-Object System.Drawing.Size(115,40)
$lblCSVbccFile.Size      = New-Object System.Drawing.Size(160,20)
$lblCSVbccFile.Text      = $ccccsvfile
$tabBcc.Controls.Add($lblCSVbccFile) 

$gboxbcc = New-Object System.Windows.Forms.GroupBox
$gboxbcc.Location = New-Object System.Drawing.Size(12,0)
$gboxbcc.Size = New-Object System.Drawing.Size(270,70)
$gboxbcc.Text = "Bcc:"
$tabBcc.controls.add($gboxbcc)

#Attachment Tab
$btnAttach1          = new-object System.Windows.Forms.Button
$btnAttach1.Location = New-Object System.Drawing.Size(15,15)
$btnAttach1.Size     = New-Object System.Drawing.Size(125,23)
$btnAttach1.Text     = "Select Attachment #1"
$btnAttach1.Add_Click({openAttach})
$tabAttach.Controls.Add($btnAttach1)

$lblAttachFile           = New-Object System.Windows.Forms.Label
$lblAttachFile.Location  = New-Object System.Drawing.Size(15,40)
$lblAttachFile.Size      = New-Object System.Drawing.Size(265,33)
$lblAttachFile.Text      = $attachfile
$tabAttach.Controls.Add($lblAttachFile) 

$gboxAttach1 = New-Object System.Windows.Forms.GroupBox
$gboxAttach1.Location = New-Object System.Drawing.Size(12,0)
$gboxAttach1.Size = New-Object System.Drawing.Size(270,80)
$gboxAttach1.Text = "Attachment #1:"
$tabAttach.controls.add($gboxAttach1)

$btnAttach2          = new-object System.Windows.Forms.Button
$btnAttach2.Location = New-Object System.Drawing.Size(15,105)
$btnAttach2.Size     = New-Object System.Drawing.Size(125,23)
$btnAttach2.Text     = "Select Attachment #2"
$btnAttach2.Add_Click({openAttach2})
$tabAttach.Controls.Add($btnAttach2)

$lblAttachFile2           = New-Object System.Windows.Forms.Label
$lblAttachFile2.Location  = New-Object System.Drawing.Size(15,130)
$lblAttachFile2.Size      = New-Object System.Drawing.Size(265,33)
$lblAttachFile2.Text      = $attachfile2
$tabAttach.Controls.Add($lblAttachFile2) 

$gboxAttach2 = New-Object System.Windows.Forms.GroupBox
$gboxAttach2.Location = New-Object System.Drawing.Size(12,90)
$gboxAttach2.Size = New-Object System.Drawing.Size(270,80)
$gboxAttach2.Text = "Attachment #2:"
$tabAttach.controls.add($gboxAttach2)

$btnAttach3          = new-object System.Windows.Forms.Button
$btnAttach3.Location = New-Object System.Drawing.Size(15,195)
$btnAttach3.Size     = New-Object System.Drawing.Size(125,23)
$btnAttach3.Text     = "Select Attachment #3"
$btnAttach3.Add_Click({openAttach3})
$tabAttach.Controls.Add($btnAttach3)

$lblAttachFile3           = New-Object System.Windows.Forms.Label
$lblAttachFile3.Location  = New-Object System.Drawing.Size(15,220)
$lblAttachFile3.Size      = New-Object System.Drawing.Size(265,33)
$lblAttachFile3.Text      = $attachfile3
$tabAttach.Controls.Add($lblAttachFile3) 

$gboxAttach3 = New-Object System.Windows.Forms.GroupBox
$gboxAttach3.Location = New-Object System.Drawing.Size(12,180)
$gboxAttach3.Size = New-Object System.Drawing.Size(270,80)
$gboxAttach3.Text = "Attachment #3:"
$tabAttach.controls.add($gboxAttach3)

$gboxbcc = New-Object System.Windows.Forms.GroupBox
$gboxbcc.Location = New-Object System.Drawing.Size(12,0)
$gboxbcc.Size = New-Object System.Drawing.Size(270,70)
$gboxbcc.Text = "Bcc:"
$tabBcc.controls.add($gboxbcc)


#Subject & Message Box

$tboxServer           = New-Object System.Windows.Forms.TextBox
$tboxServer.Location  = New-Object System.Drawing.Size(15,15)
$tboxServer.Size      = New-Object System.Drawing.Size(260,33)
$tboxServer.Text      = $Server
$tabGeneral.Controls.Add($tboxServer) 

$gboxServer = New-Object System.Windows.Forms.GroupBox
$gboxServer.Location = New-Object System.Drawing.Size(12,0)
$gboxServer.Size = New-Object System.Drawing.Size(270,45)
$gboxServer.Text = "Server:"
$tabGeneral.controls.add($gboxServer)


$tboxSubject            = New-Object System.Windows.Forms.TextBox
$tboxSubject.Location  = New-Object System.Drawing.Size(15,65)
$tboxSubject.Size      = New-Object System.Drawing.Size(260,33)
$tboxSubject.Text      = $Subject
$tboxSubject.WordWrap = $True
$tabGeneral.Controls.Add($tboxSubject) 


$gboxsubject = New-Object System.Windows.Forms.GroupBox
$gboxsubject.Location = New-Object System.Drawing.Size(12,50)
$gboxsubject.Size = New-Object System.Drawing.Size(270,45)
$gboxsubject.Text = "Subject:"
$tabGeneral.controls.add($gboxsubject)

$tboxBody           = New-Object System.Windows.Forms.TextBox
$tboxBody.Location  = New-Object System.Drawing.Size(15,115)
$tboxBody.Size      = New-Object System.Drawing.Size(260,180)
$tboxBody.Text      = $body
$tboxBody.Multiline = $True
$tboxBody.AcceptsReturn = $True
$tboxBody.WordWrap = $True
$tabGeneral.Controls.Add($tboxBody) 


$gboxbody = New-Object System.Windows.Forms.GroupBox
$gboxbody.Location = New-Object System.Drawing.Size(12,100)
$gboxbody.Size = New-Object System.Drawing.Size(270,200)
$gboxbody.Text = "Body"
$tabGeneral.controls.add($gboxbody)


$olButton          = new-object System.Windows.Forms.Button
$olButton.Location = New-Object System.Drawing.Size(200,370)
$olButton.Size     = New-Object System.Drawing.Size(75,23)
$olButton.Text     = "Send Mail"
$olButton.Add_Click({closeMyDialog})
$Form.Controls.Add($olButton)
$form.AcceptButton = $olButton

$btnCanx          = new-object System.Windows.Forms.Button
$btnCanx.Location = New-Object System.Drawing.Size(200,395)
$btnCanx.Size     = New-Object System.Drawing.Size(75,23)
$btnCanx.Text     = "Cancel"
$btnCanx.add_Click({cancelMyDialog}) 
$Form.Controls.Add($btnCanx)
$form.CancelButton = $btnCanx


$chkVerbose = New-Object System.Windows.Forms.CheckBox
$chkVerbose.Location = New-Object System.Drawing.Size(130,340)
$chkVerbose.Size = New-Object System.Drawing.Size(270,85)
$chkVerbose.Text = "Verbose"
$chkVerbose.checked = $Verbose
$form.controls.add($chkVerbose)

$inMsgCount          = New-Object System.Windows.Forms.numericUpDown
$inMsgCount.Location = New-Object System.Drawing.Size(65,370)
$inMsgCount.Size     = New-Object System.Drawing.Size(59,20)
$inMsgCount.Maximum  = 999
$inMsgCount.Value    = $msgcount
$Form.Controls.Add($inMsgCount)

$lblMsgCount= New-Object System.Windows.Forms.Label
$lblMsgCount.Location  = New-Object System.Drawing.Size(10,373)
$lblMsgCount.Size      = New-Object System.Drawing.Size(300,20)
$lblMsgCount.Text      = "No Msgs:"
$Form.Controls.Add($lblMsgCount) 

$Form.Controls.Add($tab)
$Form.Size = New-Object System.Drawing.Size(300, 450)
$Form.TopMost = $True
$form.Add_Shown({$form.Activate()})
$form.ShowDialog()
}

############
#Start Here#
############

#Variables
$message    = New-Object System.Net.Mail.MailMessage
$today      = [system.datetime]::now
$server     = HostName
$cmdline    = Get-location
$to         = ""
$cc         = ""
$bcc        = ""
$from       = ""
$body       = "This message was sent using Windows PowerShell and send-mail.ps1"
$subject    = "Sent using send-mail.ps1 at " + $today
$sendmail   = $False
$verbose    = $false
$useGUI     = $false
$attachment = ""
$msgcount   = 1
$AppName + " " + $Appver


#PrePopulate the Message.  They will be overwritten if on the cmdline
$message.body = $body 
$message.subject = $subject



#Make the assumption that the arguments are in pairs
for($i = 0; $i -le $args.Length; $i++)
{
	switch ($args[$i]) 
	{
		"-GUI" 
			{
				$useGUI = $true
			}


		"-server" 
			{
				$server = $args[$i+1]
				$i++
			}
		"-to"
			{
				$to = $args[$i+1]
				$message.TO.add($to)
				$sendmail = $True
				$i++
			}

		"-tocsv"
			{
				$tocsvfile = $tocsvfile + $args[$i+1]  + ";"
				$tocsv = import-csv $args[$i+1]
				foreach ($csvuser in $toCSV)
				{
					$message.TO.add($csvuser.email)
					$sendmail = $True
				}
				$i++
			}

		"-cc"
			{
				$cc = $args[$i+1]
				$message.cc.add($cc)
				$sendmail = $True
				$i++
			}


		"-cccsv"
			{
				$cccsvfile = $cccsvfile + $args[$i+1]  + ";"
				$cccsv = import-csv $args[$i+1]
				foreach ($cccsvuser in $ccCSV)
				{
					$message.cc.add($cccsvuser.email)
					$sendmail = $True
				}
				$i++
			}


		"-bcc"
			{
				$bcc = $args[$i+1]
				$message.bcc.add($bcc)
				$i++
			}


		"-bcccsv"
			{
				$bcccsvfile = $bcccsvfile + $args[$i+1] + ";"
				$bcccsv = import-csv $args[$i+1]
				foreach ($bcccsvuser in $bccCSV)
				{
					$message.bcc.add($bcccsvuser.email)
				}
				$i++
			}

		"-from"
			{
				$from = $args[$i+1]
				$message.from = $from
				$i++
			}

		"-subject"
			{
				$subject = $args[$i+1]
				$message.subject = $subject
				$i++
			}

		"-body"
			{
				$body = $args[$i+1]
				$message.Body = $body
				$i++
			}

		"-attachment" 
			{
				$attachment = $attachment + $args[$i+1] + "; "
				IF ($attachment.length -ne 0)
				{
					$message.Attachments.Add($args[$i+1])
				}
				$i++
			}

		"-msgcount" 
			{
				$msgcount = $args[$i+1]
				$i++
			}

		"-verbose"
			{
				$verbose = $true
			}

	} #Switch


} #For loop

#IF ($to.length -eq 0)  {$sendmail = $false}
IF ($from.length -eq 0) 
{
	$from = "nobody@send-mail.ps1"
	$message.from = $from
}

if ($useGUI) 
{

$GUIReturn = displayGUI
$DialogCmdLine

}

IF ($msgcount -lt 1){$msgcount = 1}

IF ($verbose)
{

	"Servername.....: " + $server
	"To.............: " + $to
	"Cc.............: " + $cc
	"Bcc............: " + $bcc
	"From...........: " + $from
	"ToCSV..........: " + $toCSVfile
	"ccCSV..........: " + $ccCSVfile
	"bccCSV.........: " + $bccCSVfile
	"subject........: " + $subject
	"body...........: " + $body
	"Attachments....: (" + $message.attachments.count + ") " + $attachment
	"Message Count..: " + $msgCount
	"to Count.......: " + $message.to.count
	"cc Count.......: " + $message.cc.count
	"bcc Count......: " + $message.bcc.count
	"SendMail.......: " + $sendmail
	"CmdLine........: " + $cmdline.path + "\send-mail.ps1 " + $args

	IF ($UseGUI)
	{	
		IF ($server.length -gt 0){$GUICmdLine = "-server " + $server}
		IF ($to.length -gt 0){$GUICmdLine = $GUICmdLIne + " -to " + $to}
		IF ($cc.length -gt 0){$GUICmdLine = $GUICmdLIne + " -cc " + $cc}
		IF ($bcc.length -gt 0){$GUICmdLine = $GUICmdLIne + " -bcc " + $bcc}
		IF ($toCSVfile.length -gt 0){$GUICmdLine = $GUICmdLIne + " -tocsv " + $toCSVfile}
		IF ($ccCSVfile.length -gt 0){$GUICmdLine = $GUICmdLIne + " -cccsv " + $ccCSVfile}
		IF ($bccCSVfile.length -gt 0){$GUICmdLine = $GUICmdLIne + " -bcccsv " + $bccCSVfile}
		IF ($subject.length -gt 0){$GUICmdLine = $GUICmdLIne + " -subject " + $subject}
		If ( $attachfile.length -gt 0){	$GUICmdLine = $GUICmdLine + " -attachment " + $attachfile}
		If ( $attachfile2.length -gt 0){	$GUICmdLine = $GUICmdLine + " -attachment " + $attachfile2}
		If ( $attachfile3.length -gt 0){	$GUICmdLine = $GUICmdLine + " -attachment " + $attachfile3}
		
		$GUICmdLine = $GUICmdLIne + " -msgcount " + $msgcount

		IF ($verbose) {$GUICmdLine = $GUICmdLIne + " -verbose"}
		"GUI Generated Command Line:`n" + $cmdline.path + "\send-mail.ps1 " + $GUIcmdline
	}
}



$RecipientCount = $message.to.count + $message.cc.count + $message.bcc.count

if ($RecipientCount -gt 10)
{
	$Warningtxt = "You are sending " + $msgCount + " mails to " + $RecipientCount + " recipients`nIt may take some time to send them.  Please be patient."
	write-warning $WarningTxt
}


IF ($sendmail)
{

	$smtpclient = [System.Net.Mail.SmtpClient]("")
	$smtpclient.Host = $server
	for ($i=1;$i -lt $msgCount+1;$i++)
	{
		IF ($msgCount -gt 1)
		{
			$message.subject = $subject + " (" + $i.ToString() +  ")"

		}
		$smtpclient.Send($message) 
	} #end FOR



	IF ($msgCount -eq 1) 
	{
		$msgCount.ToString() + " message sent"
	}
	ELSE
	{
		$msgCount.ToString() + " messages sent"
	}
	


}
ELSE
{

IF (-not $UseGUI)
{
@'
Syntax:
send-mail.ps1 -server exchange2007 -from administrator@flaphead.local -TO user-11@flaphead.local -cccsv c:\ps\users.csv -subject "Exchange 2007 and Windows PowerShell" -body "Welcome to your new mailbox on Exchange 2007" -verbose

-server     <Server name.  Default is localhost>
-from       <User mail is from. Default is nobody@send-mail.ps1>
-to         <to mail recipients>
-cc         <cc mail recipients>
-bcc        <bcc mail recipients>
-toCSV      <CSV file with Mail recipents in.  One column called email>
-ccCSV      <CSV file with Mail recipents in.  One column called email>
-bccCSV     <CSV file with Mail recipents in.  One column called email>
-subject    <Message Subject. Default value will be set if not specified>
-body       <Message Body. Default value will be set if not specified>
-attachment <Filename & FULL path of attachment>
-msgcount   <Number of messages to be sent.  Default is 1>
-verbose    <Turns on verbose mode>
-GUI        <Displays the GUI>

NB: either -to, -cc, -tOCSV or -ccCSV are REQUIRED
NB: Make sure your Exchange 2007 default recieve connectors set to allow anonymoususer access

Get-ReceiveConnector | where {$_.Identity -like "*Default*"} | Set-ReceiveConnector -identity {$_.Identity} -PermissionGroups anonymoususers
'@
}
}


########################
# End of send-mail.ps1 #
########################
