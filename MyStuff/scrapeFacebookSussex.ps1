function Arow {
    push-location $env:OneDrive\PowershellScripts\MyStuff\Data\
    $path="./sussex1.html"

    #version 1.0.2 FAJ 2020-04-08
    #run like this $data=arow'
    Write-Warning "In function $($MyInvocation.MyCommand.Name): "

    #https://paullimblog.wordpress.com/2017/08/08/ps-tip-parsing-html-from-a-local-file-or-a-string/
    $html = New-Object -ComObject "HTMLFile"
    $html.IHTMLDocument2_write($(Get-Content -path $path -raw))

    $InnerText=$html.all.tags("a")|Select-Object innertext
    $last= $Innertext.count
   #for($i=0;$i -lt $last;$i=$I+1){if($InnerText[$i].innertext -like "Proximity(miles)"){$index=$i;$i=$last}}
    #find the last label

    #find 'Parcel ID'
    for($i=0;$i -lt $last;$i++){if($InnerText[$i].innertext -like "*Parcel ID*"){$index=$i;$i=$last}}
    $offset=15 #skip $offset innertext to get to next collection.
    for($i=$index+3;$i -lt $Innertext.count;$i+=$offset){
        $x=$i
        #"index {0} data {1}" -f $x,$InnerText[$x].innertext

        $thisobject=   [pscustomobject]@{
            Proximity=$innertext[$x].innertext.trim()
            Number=$innertext[$x+2].innertext.trim()
            Street=$innertext[$x+3].innertext.trim()
            Town=$innertext[$x+4].innertext.trim()
            Price=$innertext[$x+5].innertext.trim()
            Date=$innertext[$x+6].innertext.trim()
            Style=$innertext[$x+7].innertext.trim()
            Size=$innertext[$x+8].innertext.trim()
            Lot="{0:n0}" -f [int]$innertext[$x+9].innertext.trim()
            Year=$innertext[$x+10].innertext.trim()
            Zip=$innertext[$x+11].innertext.trim()
            Parcel=$innertext[$x+12].innertext.trim()

        }
        #push the thisobject to the pipeline.
        $thisobject
    }#End of for.
Write-Warning "End of function $($MyInvocation.MyCommand.Name): "
}#end of function
$data=arow