# Import the SQLite module
# Install-Module -Name PSSQLite as administrator
Import-Module PS-SQLite

# Create a new database connection
$connection = New-Object SQLiteConnection("MyDatabase.db")

# Open the database connection
$connection.Open()

# Create a new table in the database
$command = New-Object SQLiteCommand("CREATE TABLE MyTable (Id INTEGER PRIMARY KEY, Name TEXT)")
$command.Connection = $connection
$command.ExecuteNonQuery()

# Insert some data into the table
$command = New-Object SQLiteCommand("INSERT INTO MyTable (Name) VALUES ('John Doe')")
$command.Connection = $connection
$command.ExecuteNonQuery()

# Close the database connection
$connection.Close()

# Display the data in the table
$command = New-Object SQLiteCommand("SELECT * FROM MyTable")
$command.Connection = $connection
$reader = $command.ExecuteReader()

while ($reader.Read()) {
    Write-Host $reader["Id"]
    Write-Host $reader["Name"]
}

# Close the data reader
$reader.Close()