try {
$urls=get-content pingme.txt;$?
foreach($url in $urls) {write-host "$url";test-connection -count 1 $url;$?}
}

finally {
	"destroy {0}" -f $url	
	remove-variable urls
}
