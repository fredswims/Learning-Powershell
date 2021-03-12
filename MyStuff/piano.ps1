# play scale
# each octave is 1 semitones and doubles in pitch
# (1+x)^12=2 solve for x=2^(1/12)-1
$x=[math]::Pow(2,1/12)
$duration=250
#A below middle C
$a=220 
$a=262 #middle C
$C=$a*[math]::pow($x,0)
$NoteArray = New-Object System.Collections.ArrayList
$ScaleArray = New-Object System.Collections.ArrayList
# $Notee.Add('India') > $null
$ScaleArray=@(0,2,4,5,7,9,11,12,11,9,7,5,4,2,0)
foreach ($step in 0..12){
    $note=$C*[math]::Pow($x,$step)
    $NoteArray.add($note)
    "Note {0}-{1}" -f $step,$note
    [console]::Beep($note,$duration)
}
foreach ($halfstep in (0 .. (($ScaleArray).count-1)) ) {"halfstep {0} : frequency {1}" -f $halfstep, $NoteArray[$ScaleArray[$halfstep]]}
foreach ($halfstep in (0 .. (($ScaleArray).count-1)) ) {[console]::beep($NoteArray[$ScaleArray[$halfstep]],$duration)}
