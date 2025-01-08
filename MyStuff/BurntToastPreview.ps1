# https://toastit.dev/2023/05/07/burnttoast-v1-preview2/
get-PSResource -Name BurntToast 
$Builder=$null
$Builder = New-BTContentBuilder
$Builder | Add-BTText -Text 'Heading' -Bindable 
$Builder | Add-BTText -Text 'Body' -Bindable 
$Builder | Add-BTDataBinding -Key 'Heading' -Value 'This is the heading' 
$Builder | Add-BTDataBinding -Key 'Body' -Value 'This is the body'
$Builder | Show-BTNotification 