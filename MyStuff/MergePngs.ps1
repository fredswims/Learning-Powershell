set-location "G:\My Drive\MitoAction\2022.InternationalMetabolicConference\Dr.MarkKorson"
$files = "1.png","2.png","3.png","4.png","5.png","6.png","7.png"
$files=get-item *.png
$images = $files | ForEach-Object { [System.Drawing.Image]::FromFile($_) }
$images | ForEach-Object {
    "{0} → {1}x{2}" -f $_.Filename, $_.Width, $_.Height
}

"TotalWidth = $totalWidth"
"MaxHeight = $maxHeight"
$totalWidth = ($images | Measure-Object -Property Width -Sum).Sum
$maxHeight = ($images | Measure-Object -Property Height -Maximum).Maximum

$final = New-Object System.Drawing.Bitmap $totalWidth, $maxHeight
$g = [System.Drawing.Graphics]::FromImage($final)

$x = 0
foreach ($img in $images) {
    $g.DrawImage($img, $x, 0)
    $x += $img.Width
}

$final.Save("combined.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$images | ForEach-Object { $_.Dispose() }