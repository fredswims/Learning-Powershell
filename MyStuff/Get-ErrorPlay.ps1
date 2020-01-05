function myerror {
    try {
        set-location $env:HOMEPATH
        if (test-path fred.out) { }else { New-Item fred.out }
        get-item fred.out
    }
    catch {
        "here is the error"
        get-error
    
    }
}
try {
    
}
catch {
    
}