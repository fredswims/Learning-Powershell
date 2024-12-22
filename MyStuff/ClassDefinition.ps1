class Person {
    [string]$FirstName
    [string]$LastName

    Person([string]$firstName, [string]$lastName) {
        $this.FirstName = $firstName
        $this.LastName = $lastName
    }

    [string] GetFullName() {
        return "$($this.FirstName) $($this.LastName)"
    }
}
<# 
# Create an instance of the class
$person = [Person]::new("Jane", "Doe")

# Access properties and methods
$person.FirstName  # Output: Jane
$person.GetFullName()  # Output: Jane Doe
 #>