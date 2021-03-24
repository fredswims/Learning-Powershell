<#
.SYNOPSIS
    Simple piano player

.Parameter Duration
    Say somthing about the duration parameter.    
    
#>

# play scale
# each octave is 1 semitones and doubles in pitch
# (1+x)^12=2 solve for x=2^(1/12)-1
$ScaleFactor=[math]::Pow(2,1/12)
$duration=250
function Play-Piano{
    [CmdletBinding()]
    param (
        [Parameter()]
        [double]
        $Root,
        [double]
        $ScaleFactor,
        [Int32]
        $Duration
    )
        
    $NoteArray = New-Object System.Collections.ArrayList
    $ScaleArray = New-Object System.Collections.ArrayList
    # $Notee.Add('India') > $null
    $ScaleArray = @(0, 2, 4, 5, 7, 9, 11, 12, 11, 9, 7, 5, 4, 2, 0)
    # $ScaleArray = @(0,  4,  7, 4, 0)
    
    foreach ($step in 0..12) {
        $note = $Root * [math]::Pow($ScaleFactor, $step)
        $NoteArray.add($note)
        "Note {0}-{1}" -f $step, $note
        # [console]::Beep($note,$duration)
    }
    # foreach ($halfstep in (0 .. (($ScaleArray).count - 1)) ) { "halfstep {0} : frequency {1}" -f $halfstep, $NoteArray[$ScaleArray[$halfstep]] }
    foreach ($halfstep in (0 .. (($ScaleArray).count - 1)) ) { [console]::beep($NoteArray[$ScaleArray[$halfstep]], $duration) }
}

#A below middle C
$referencekey=440/2
#middle C 262
$Root=$referencekey*[math]::pow($scaleFactor,3) 
Play-Piano $root $ScaleFactor $duration

# F
$Root=$referencekey*[math]::pow($scaleFactor,8) 
Play-Piano $root $ScaleFactor $duration

# C
$Root=$referencekey*[math]::pow($scaleFactor,3) 
Play-Piano $root $ScaleFactor $duration

# G
$Root=$referencekey*[math]::pow($scaleFactor,10)
Play-Piano $root $ScaleFactor $duration

# F
$Root=$referencekey*[math]::pow($scaleFactor,8)
Play-Piano $root $ScaleFactor $duration

# C
$Root=$referencekey*[math]::pow($scaleFactor,3)
Play-Piano $root $ScaleFactor $duration
# Eb
$Root=$referencekey*[math]::pow($scaleFactor,6)
Play-Piano $root $ScaleFactor $duration
