#https://github.com/chaliy/psurl/
$env:PSModulePath

send-webcontent "http://example.com" -Data @{"Foo" = "Bar"}