# Path to your ZLocation module
$modulePath = "C:\Users\freds\OneDrive\Documents\PowerShell\Modules\ZLocation\1.4.3"

# Load the LiteDB engine DLL shipped with the module
Add-Type -Path (Join-Path $modulePath "LiteDB\LiteDB.dll")

# Path to your actual ZLocation DB file
$dbPath = "C:\Users\freds\z-location.db"

# Open the raw LiteDB engine (this is what ZLocation uses internally)
$engine = [LiteDB.Engine.LiteEngine]::new($dbPath)

# The collection name used by ZLocation
$collection = "locations"

# Dump all records from the collection
$results = $engine.Find($collection, [LiteDB.Engine.Query]::All())

# Convert raw BsonDocuments into readable PowerShell objects
$results |
    ForEach-Object {
        [PSCustomObject]@{
            Path      = $_["Path"].AsString
            Score     = $_["Score"].AsDouble
            Timestamp = $_["Timestamp"].AsDateTime
        }
    } |
    Sort-Object Score -Descending