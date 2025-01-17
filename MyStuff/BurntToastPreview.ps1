# https://toastit.dev/2022/02/12/finally-introducing-the-first-preview-of-burnttoast-v1/
# find-module burnttoast -RequiredVersion 1.0.0-preview1|install-module -SkipPublisherCheck -AllowClobber -verbose

Get-InstalledPSResource -name BurntToast -Version 1.0.0-preview1
Get-InstalledModule -Name BurntToast -AllVersions
Read-Host "Example 0"
$Builder=$null
$Builder = New-BTContentBuilder
$Builder | Add-BTAppLogo
$Builder | Add-BTText "BurntToast v1 is in the works!", "It took a while, but progress is being made"
$Builder | Add-BTImage "https://raw.githubusercontent.com/Windos/BurntToast/main/Media/BurntToast-Wide.png"
$Builder | Show-BTNotification

New-BTContentBuilder |
    Add-BTAppLogo -PassThru |
    Add-BTText "BurntToast v1 is in the works!", "It took a while, but progress is being made" -PassThru |
    Add-BTImage "https://raw.githubusercontent.com/Windos/BurntToast/main/Media/BurntToast-Wide.png" -PassThru |
    Show-BTNotification

    $PSDefaultParameterValues = @{
        "Add-BT*:PassThru" = $true
    }
    New-BTContentBuilder |
    Add-BTAppLogo |
    Add-BTText "BurntToast v1 is in the works!", "It took a while, but progress is being made" |
    Add-BTImage "https://raw.githubusercontent.com/Windos/BurntToast/main/Media/BurntToast-Wide.png" |
    Show-BTNotification

# Not working with preview 1
Read-Host "Example 1"
$Builder=$null
$Builder = New-BTContentBuilder
$Builder | Add-BTImage -AppLogo
$Builder | Add-BTInputTextBox -Id 'Example 01' #not working with preview 1
$Builder | Show-BTNotification 

Read-Host "Example 2 works with Preview 1"
$Builder = $null
$Builder = New-BTContentBuilder
$Builder | Add-BTText -Text 'Example Toast Source' -Attribution #preview2?
$Builder | Add-BTText -Text 'Example Toast Source'
$Builder | Add-BTText -Text 'Additional line'
$Builder | Add-BTText -Text 'A third line'
$Builder | Show-BTNotification 

Read-Host "Example 3"
$Builder=$null
$Builder = New-BTContentBuilder
$Builder | Add-BTText -Text 'Heading' -Bindable 
$Builder | Add-BTText -Text 'Body' -Bindable 
$Builder | Add-BTDataBinding -Key 'Heading' -Value 'This is the heading' 
$Builder | Add-BTDataBinding -Key 'Body' -Value 'This is the body'
$Builder | Show-BTNotification 


# Version 2
install-psresource -name BurntToast -Prerelease -verbose
# https://toastit.dev/2023/05/07/burnttoast-v1-preview2/
$Builder=$null
$Builder = New-BTContentBuilder
$Builder | Add-BTImage -Source 'C:\Users\freds\OneDrive\PowershellScripts\MyStuff\BurntToast.png'  # -AppLogo does not work 
$Builder | Add-BTText -Text 'Example Toast Source' # -Attribution
$Builder | Show-BTNotification

$PSDefaultParameterValues["Disabled"]=$false
