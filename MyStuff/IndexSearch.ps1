# Search Windows Index
# Can do SQL queries on File Properties and/or Text [ (FREETEXT) or (Contains)]
# articles
# https://www.petri.com/manage-documents-with-windows-explorer-using-tags-and-file-properties
# https://www.petri.com/how-to-query-the-windows-search-index-using-sql-and-powershell
# https://msdn.microsoft.com/en-us/library/windows/desktop/ff684395(v=vs.85).aspx  GOOD PLACE TO START
# https://blogs.technet.microsoft.com/heyscriptingguy/2012/06/27/customizing-powershell-output-from-windows-search/ (three articles)
# https://msdn.microsoft.com/en-us/library/windows/desktop/ff521735(v=vs.85).aspx
# WHERE FREETEXT('computer software hardware') https://msdn.microsoft.com/en-us/library/bb231268(v=vs.85).aspx
#  where clause and search predicates https://msdn.microsoft.com/en-us/library/bb231258(v=vs.85).aspx 
# rank by https://msdn.microsoft.com/en-us/library/bb231278(v=vs.85).aspx

# a bunch of Select statements to try

#$sql = "SELECT System.ItemName, System.DateCreated FROM SYSTEMINDEX WHERE System.ContentStatus = 'Completed' AND SCOPE = 'C:\Users\freds_000\Documents\'"

$sql = "SELECT System.ItemName, System.Author, System.DateCreated, System.Comment FROM SYSTEMINDEX WHERE System.ContentStatus = 'Complete' AND System.DateCreated >= '2014-09-1' AND System.DateCreated < '2014-10-31' AND SCOPE = 'c:\users\russell\skydrive\documents\petri\'"

$sql = "SELECT System.ItemName,`
 System.DateCreated,`
 System.ItemFolderPathDisplay, `
 System.Author, System.Comment
 FROM SYSTEMINDEX WHERE System.ContentStatus = 'Completed' AND SCOPE = 'C:\Users\freds_000\Documents\'"
#$sql="SELECT System.ItemName, System.DateCreated FROM SYSTEMINDEX WHERE System.ContentStatus = 'Completed'  AND SCOPE = 'C:\Users\freds_000\Documents\'"

$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE System.ContentStatus = 'Completed' AND System.ItemName like 'D%.docx' AND SCOPE = 'C:\Users\freds_000\Documents\'"
$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE System.ContentStatus = 'Completed'" # AND Contains(*,’stingray’) AND SCOPE = 'C:\Users\freds_000\Documents\'"
$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE System.ContentStatus = 'Completed'" # AND Contains(*,’stingray’) AND SCOPE = 'C:\Users\freds_000\Documents\'"
$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE System.ContentStatus = 'Completed' and FREETEXT('''xAnax in my tank'' automobile') AND SCOPE = 'C:\Users\freds_000\Documents\'"
$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE System.ContentStatus = 'Completed' and FREETEXT('xAnax') AND NOT FREETEXT ('Automobile') AND SCOPE = 'C:\Users\freds_000\Documents\'"
$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE  CONTAINS ( System.Author,'Fred' ) AND  Contains(*,'xAnax') AND NOT FREETEXT ('Automobile') AND SCOPE = 'C:\Users\freds_000\Documents\'"
$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE System.ContentStatus = 'Complete' AND  Contains(*,'fred') AND SCOPE = 'C:\Users\freds_000\Documents\'"
$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE System.ContentStatus = 'Complete' AND  Contains('xanax') AND SCOPE = 'C:\Users\freds_000\Documents\'"
$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE System.ContentStatus = 'Complete' AND  FreeText('xAnax') AND SCOPE = 'C:\Users\freds_000\Documents\'"
$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE System.ContentStatus = 'Complete' AND System.Keywords = '#atag'  AND SCOPE = 'C:\Users\freds_000\Documents\'"
# Simplified The query I really want
$sql="SELECT System.ItemName, System.DateCreated,System.Comment,System.Author FROM SYSTEMINDEX WHERE FreeText('xAnax') AND SCOPE = 'C:\Users\freds_000\Documents\'"



# 
$provider = "provider=search.collatordso;extended properties=’application=windows’;"
$connector = new-object system.data.oledb.oledbdataadapter -argument $sql, $provider 
$dataset = new-object system.data.dataset 
# BASIC execute query and display results
# if ($connector.fill($dataset)) { $dataset.tables[0] }
# More Complex Format for results
if ($connector.fill($dataset)) { $dataset.tables[0] | select-object system.itemname, system.author, system.datecreated, system.comment | format-table -autosize * }


<#
 What I want to do know is put the output into a [word] file and then I can work from word to make a comprehensive report. My Document Managment System.
 Some Interesting Properties
 System.ItemPathDisplay - path includes folder
 System.Keywords - Tags - can prefix tag with '#' 

 Select statement is not modified - not strick SQL
 Select statement can't use "Select *" clause
 FreeText
 Contains
 #>