# Define the path to the Chrome Bookmarks file
$BookmarkFile = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks"

# Check if the file exists
if (Test-Path $BookmarkFile) {
    # Load and parse the JSON content
    $BookmarksJson = Get-Content $BookmarkFile -Raw | ConvertFrom-Json

    # Function to recursively extract bookmarks from folders
    function Get-ChromeBookmarks($Node) {
        write-warning "In function Get-ChromeBookmarks with Node [$($Node.name)] Type [$($Node.type)]"
        foreach ($child in $Node.children) {
            if ($child.type -eq "url") {
                write-host -ForegroundColor green ("`tBookmark Name [{0}] " -f $child.name)
                [PSCustomObject]@{
                    Name = $child.name
                    URL  = $child.url
                }
            } elseif ($child.type -eq "folder") {
                write-host -ForegroundColor cyan ("Node [{2}] Type [{0}] Name [{1}]" -f $child.type, $child.name, $Node.name)
                Get-ChromeBookmarks $child
            }
        }
        write-host -ForegroundColor Red ("Exiting function Get-ChromeBookmarks with Node [$($Node.name)] Type [$($Node.type)]")
    }

    # Extract bookmarks from the main root folders
    $AllBookmarks = @()
    Write-Host -ForegroundColor Blue "bookmark_bar"
    $AllBookmarks += Get-ChromeBookmarks $BookmarksJson.roots.bookmark_bar
    Write-Host -ForegroundColor Blue "other"
    $AllBookmarks += Get-ChromeBookmarks $BookmarksJson.roots.other
    Write-Host -ForegroundColor Blue "synced"
    $AllBookmarks += Get-ChromeBookmarks $BookmarksJson.roots.synced
    write-host -ForegroundColor Blue "Completed extracting bookmarks"
    
    # Output the list
    $AllBookmarks | Out-GridView -Title "Chrome Bookmarks" -passthru
    # $AllBookmarks | Out-ConsoleGridView -Title "Chrome Bookmarks"
} else {
    Write-Error "Bookmarks file not found at $BookmarkFile"
}
