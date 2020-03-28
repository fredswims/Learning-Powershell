function ShowWhereIs ($arg) {
    Write-Warning "In function $($MyInvocation.MyCommand.Name): "
    $dir=$env:Path
    $dir=$dir.split(";") | Sort-Object
    foreach ($path in $dir){write-host $path}
    Write-host "******"
    #$fullpath=$dir | ForEach-Object {Get-ChildItem $_/$arg}
    $dir  | `
    ForEach-Object {Get-ChildItem -path $_/$arg -File -Force -ErrorAction SilentlyContinue} | `
    ForEach-Object `
        -process {[pscustomobject]@{
        Name=$_.name
        Path=split-path $_.fullname -Parent
        LastWriteTime=$_.lastwritetime
        }
    }
    #where.exe $arg | ForEach-Object  {[pscustomobject]@{Name=$arg;Path=$_}}
}
ShowWhereis pwsh.exe