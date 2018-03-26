function getItemLastWriteTime ($arg)
{
 get-item a$arg | sort lastwritetime
}



cd $env:HOMEPATH
cd desktop
getItemLastWriteTime "a*"
