﻿Function Get-Emotion()
{
[CmdletBinding()]
Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string] $ImagePath
      )

    $Splat = @{
        
        Uri= "https://api.projectoxford.ai/emotion/v1.0/recognize?language=en&detect=true&subscription-key=60a44ded0c024b77b61c6d7e9efe2afa"
        Method = 'Post'
        InFile = $ImagePath
        ContentType = 'application/octet-stream'
    }

    Try{

        Draw-Image (Invoke-RestMethod @Splat)
    }
    Catch
    {
    Write-Host "Something went wrong, please try running the script again" -fore Cyan
    }
}

Function Draw-Image($Result)
{
    #Calling the Assemblies
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $Image = [System.Drawing.Image]::fromfile($ImagePath)
    $Graphics = [System.Drawing.Graphics]::FromImage($Image)

    Foreach($R in $Result)
    {
    #Individual Emotion score and rectangel dimensions of all Faces identified
    $Scores = $R.scores
    $FaceRect = $R.faceRectangle
    
    #Emotion Objects
    $Anger = New-Object PSObject -Property @{Name='Anger';Value=[decimal]($Scores.anger);BGColor='Black';FGColor='White'}
    $Contempt = New-Object PSObject -Property @{Name='Contempt';Value=[decimal]($Scores.contempt);BGColor='Cyan';FGColor='Black'}
    $Disgust = New-Object PSObject -Property @{Name='Disgust';Value=[decimal]($Scores.disgust);BGColor='hotpink';FGColor='Black'}
    $Fear = New-Object PSObject -Property @{Name='Fear';Value=[decimal]($Scores.fear);BGColor='teal';FGColor='White'}
    $Happiness = New-Object PSObject -Property @{Name='Happiness';Value=[decimal]($Scores.happiness);BGColor='Green';FGColor='White'}
    $Neutral = New-Object PSObject -Property @{Name='Neutral';Value=[decimal]($Scores.neutral);BGColor='navy';FGColor='White'}
    $Sadness = New-Object PSObject -Property @{Name='Sadness';Value=[decimal]($Scores.sadness);BGColor='maroon';FGColor='white'}
    $Surprise = New-Object PSObject -Property @{Name='Surprise';Value=[decimal]($Scores.surprise);BGColor='Crimson';FGColor='White'}   

    #Most Significant Emotion = Highest Decimal Value in all Emotion objects
    $StrongestEmotion = ($Anger,$Contempt,$Disgust,$Fear,$Happiness,$Neutral,$Sadness,$Surprise|sort -Property Value -Descending)[0]
    
    #Create a Rectangle object to box each Face
    $FaceRectangle = New-Object System.Drawing.Rectangle ($FaceRect.left,$FaceRect.top,$FaceRect.width,$FaceRect.height)

    #Create a Rectangle object to Sit above the Face Rectangle and express the emotion
    $EmotionRectangle = New-Object System.Drawing.Rectangle ($FaceRect.left,($FaceRect.top-22),$FaceRect.width,22)
    $Pen = New-Object System.Drawing.Pen ([System.Drawing.Brushes]::$($StrongestEmotion.BGColor),3)

    #Creating the Rectangles
    $Graphics.DrawRectangle($Pen,$FaceRectangle)    
    $Graphics.DrawRectangle($Pen,$EmotionRectangle)
    $Region = New-Object System.Drawing.Region($EmotionRectangle)
    $Graphics.FillRegion([System.Drawing.Brushes]::$($StrongestEmotion.BGColor),$Region)

    #Defining the Fonts for Emotion Name
    $FontSize = 14
    $Font = New-Object System.Drawing.Font("lucida sans",$FontSize,[System.Drawing.FontStyle]::bold) 

    $TextWidth = ($Graphics.MeasureString($StrongestEmotion.name,$Font)).width
    $TextHeight = ($Graphics.MeasureString($StrongestEmotion.name,$Font)).Height

        #A While Loop to reduce the size of font until it fits in the Emotion Rectangle
        While(($Graphics.MeasureString($StrongestEmotion.name,$Font)).width -gt $EmotionRectangle.width -or ($Graphics.MeasureString($StrongestEmotion.name,$Font)).Height -gt $EmotionRectangle.height )
        {
        $FontSize = $FontSize-1
        $Font = New-Object System.Drawing.Font("lucida sans",$FontSize,[System.Drawing.FontStyle]::bold)  
        }

    #Inserting the Emotion Name in the EmotionRectabgle
    $Graphics.DrawString($StrongestEmotion.Name,$Font,[System.Drawing.Brushes]::$($StrongestEmotion.FGcolor),$EmotionRectangle.x,$EmotionRectangle.y)
}

    #Define a Windows Form to insert the Image
    $Form = New-Object system.Windows.Forms.Form
    $Form.BackColor = 'white'
    $Form.AutoSize = $true
    $Form.MinimizeBox = $False
    $Form.MaximizeBox = $False
    $Form.WindowState = "Normal"
    $Form.StartPosition = "CenterScreen"
    $Form.Name = "Get-Emotion | Microsoft Project Oxford"

    #Create a PictureBox to place the Image
    $PictureBox = New-Object System.Windows.Forms.PictureBox
    $PictureBox.Image = $Image
    $PictureBox.Height =  700
    $PictureBox.Width = 600
    $PictureBox.Sizemode = 'autosize'
    $PictureBox.BackgroundImageLayout = 'stretch'
    
    #Adding PictureBox to the Form
    $Form.Controls.Add($PictureBox)
    
    #Making Form Visible
    [void]$Form.ShowDialog()

    #Disposing Objects and Garbage Collection
    $Image.Dispose()
    $Pen.Dispose()
    $PictureBox.Dispose()
    $Graphics.Dispose()
    $Form.Dispose()
    [GC]::Collect()
}

Get-Emotion -imagepath "C:\Users\XXFred\Pictures\CampSussexMaraFredLes_files\testFamily.jpg"
Get-Emotion -ImagePath "C:\Users\XXFred\Pictures\PjDicc.jpg"