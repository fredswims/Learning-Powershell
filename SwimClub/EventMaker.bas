Attribute VB_Name = "EventMaker"
Option Explicit
'Public sEvent As String
Const cDP = vbFalse 'flag for enabling debug.print statements - Global
Const cEventFilePath = "\Events.csv"
Const gbAppend = vbFalse
Dim iEventFile As Integer
'FAJ

Sub MakeEvents()
Attribute MakeEvents.VB_ProcData.VB_Invoke_Func = " \n14"
'Copyright 2017 FAJ
'Author FAJ 12/06/2018
'Main
'This Routine takes the Meet/Time-Trial results as input and produces
'rows of events which are used to create a Report (Pivot Table).
'Makes events from each MeetResults worksheet (tab) from which it was launched.
'Produces CSV lines like this;
'Boys Time Trials,A  Age Group (8 and Under),#06-25 Free,Aleksy Fradlis,2799
'Boys Time Trials,A  Age Group (8 and Under),#30-25 Fly,Aiden Trakhtenberg,4534
'Rev 2.0
    'added 999999 for swimmers with no times in an event.
    'different formats for heat sheets.
'Rev 3.0
    'Took out 'Debug.Print Now twice
    'If sTime = "" Then sTime = "999999" *** ONLY FOR TIME TRIALS ****
'Rev 4.0
    'First meet NO MORE BLANK TIMES.
'Rev 5.0
    'Display number of records created via iRecordCount.
'Rev 6.0
    'Special processing for Relays 2017-03-06
'Rev 7.0 FJ 2017-03-20
    'Ignore relay HEATS that end in "-0". They are the relay's cummulative time.
    'Broke processing into three groups; Medley Relay, Free Relay and all others.
'Rev 7.1
    'Add output for relay totals. Heat column looks like 3[e]-1, 3[e]-2, 3[e]-3, 3[e]-4 where "e" designates exhibition
    'Basically constructing a Swimmer name from the Heat prefix concatenated with the Event.
'Rev 7.11 FJ 2017-11-17
    'NextAgeGroup automatically finds the first and last event columns for each age-group
    ' and stuff them in iColEventFirst and iColEventLast.
    'In NextAgeGroup added two new variables (iRowOfEvents and iRowNamesStart)
    ' to accomodate adding age-group names into spreedsheet;e.g., "A  Age Group (8 and Under)"
    'Function WriteEvent - Outputs events to (Application.DefaultFilePath & "\Events.csv").
'Rev 8.00 FJ 2017-12-19
    'Major changes to the function NextAgeGroup.
    'iColEventFirst is based on locating first cell that begins with "#", the prefix of an event.
    'The age-group string is taken from the table. Thus age-groups become unlimited.
'Rev 8.01 FJ 2017-12-25
    'Made parameters for the file that the events are written to.
    'https://www.thespreadsheetguru.com/blog/vba-guide-text-files
'Rev 8.02 FJ 2018-02-13
    'Changes to "NextAgeGroup:
    'Special processing for Backstroke leg of Medley relay.
    'New way to find first and last event descriptors.

    'Open List
    'Special processing for medley relay - add entry for 50
    'Special processing for freestyle relay - if lead-off ad entry for 50 free.
    'special processing for calculating times of relays and listing them (Lane 1 or 2 or 3) confusing.
'Rev 8.5 FJ 2018-02-22
    'Relays - first leg gets an ADDITIONAL individual event
    'Relays - change free style from MEDLEY into free style from RELAY
    'Capture Heat and original event in RELAY EVENTS.
    'gbSingleRun to open as write or append...Needs manual insertion of single cell if pasting in appended records.
'Rev 8.6 FJ 2018-03-16 Events file uses ThisWorkSheet.Path
'Rev 8.7 FJ 2018-11-14
    'Replaced code with function FindLastRowForThisAgeGroup
    'Replaced code with function FindLastRowInTable
Dim iRecordCount As Integer ' the number of events generated.
Dim iRow As Integer
Dim iCol As Integer
Dim iRowAll As Integer
Dim iRowsInTable As Integer 'end of section for event table
Dim iColEvent As Integer
Dim iAgeGroup As Integer

Dim sMeetName As String 'Example 11/22/2016 Intramural
Dim sEvent As String
Dim sTemp As String
Dim sAnswer As String

Dim sEventFilePath As String
Dim iEventFileHandle As Integer

Dim bStop As Boolean

Const cLastLine = "Net"
Const cRowOrig = 1 'This is where the table begins.
Const cColOrig = 1


sEventFilePath = ThisWorkbook.Path & cEventFilePath
    'iEventFile = FreeFile
'    If (gbSingleRun) Then
'        Open sEventFilePath For Output As iEventFile
'    Else
'        Open sEventFilePath For Append As iEventFile
'    End If
    Const cForReading = 1, cForWriting = 2, cForAppending = 8
    Const cTristateFalse = 0 'Opens the file as ASCII.
    Const cCreateFile = vbTrue 'creates files if it does not exist.
    Dim fs
    Dim f
    Dim iAccessType
    Set fs = CreateObject("Scripting.FileSystemObject")
    If (Not gbAppend) Then
        iAccessType = cForWriting
    Else
        iAccessType = cForAppending
    End If
    Set f = fs.OpenTextFile(sEventFilePath, iAccessType, cCreateFile, cTristateFalse)

    iRowsInTable = 0

    'Application.SendKeys "^g ^a {DEL}"    'Clear intermediate screen.  'Big problem with this - don't use. 'It highlites code at end of run.
    'MsgBox "MakeEvents: Make sure the correct number of event columns are set in NextAgeGroup."

    'sAnswer = MsgBox("Do you set the correct number of columns in module NextAgeGroup?", vbYesNoCancel, "MakeEvents")
    'If (sAnswer = vbCancel) Or (sAnswer = vbNo) Then End

    Debug.Print Now
    sMeetName = Trim(Cells(cRowOrig, cColOrig).Value)
    '

    'Figure out the last row of the input table.
    iRowsInTable = FindLastRowInTable(cRowOrig, cColOrig, cLastLine)

    'find next (or first) age-group and create events.
    iRow = cRowOrig
    iCol = cColOrig
    iAgeGroup = 1
    iRecordCount = 0 'ultimately contains net record count of all groups.
    While (iRow < iRowsInTable)
        'Debug.Print "Get Age Group"
        iRow = NextAgeGroup(iRow, iCol, iAgeGroup, sMeetName, iRecordCount, f)
            iRow = iRow + 1 'next age-group starts here or this was the last age-group
            'iAgeGroup = iAgeGroup + 1 'Decap here and in call to function.
        'Debug.Print iRow
    Wend
    'Debug.Print Now
    Debug.Print "MakeEvents: Record Count " & iRecordCount
    'Close iEventFile  'close the event file.
    f.Close
    MsgBox ("MakeEvents: Created " & iRecordCount & " events. Finis")

    End Sub
    Function NextAgeGroup(ByRef iRowOrig As Integer, ByRef iColOrig As Integer, ByRef iAgeGroup As Integer, ByRef sMeetName As String, ByRef iRecordCount As Integer, f) As Integer
    '2017-12-19 Major modifications to this function.
    'This function is called repeatedly and creates event-strings for an Age-Group.
    'The function returns a row as integer. It is a pointer to the last row in the processed age group.
    'The calling function stops calling this functions when the row returned is equal to the maximum rows in the table.
    'iRowOrig and iColOrig as input give "hints" as to the head of this Age-Group.'The exact row is found programmatically to accomodate earlier implementations of the MeetSheet.
    'iAgeGroup, Decaprecated
    'sMeetName as input, for building events-strings.
    'iRecordCount as input and output; the net of all the event-strings created
    'iEventFileHandle - reference to file that Events are written to.
    '2018-02-12 Special processing for Backstroke leg of Medley relay.
    '2018-02-13 New way to find first and last event descriptors.
    Const cThisSub = "NextAgeGroup: "
    Const cCSV = ","
    Dim bStop As Boolean
    Dim bRelay As Boolean
    Dim bSwitchToIndividualEvent As Boolean 'Indicates this leg of the relay is switched to an individual event.
    Dim sTemp As String
    Dim iRowThisAgeGroup 'Row that contains this Age-Group string.
    Dim iRowOfEvents As Integer 'Row containing event-names.
    Dim iRowNamesStart As Integer 'First row with swimmer-name.
    Dim iRowAgeEnd As Integer 'end of section for age-group.
    Dim iRow As Integer
    Dim iCol As Integer
    Dim iColEvent As Integer ' Row Header - The specific event; eg '#18-50 Back'
    Dim iColEventFirst As Integer
    Dim iColEventLast As Integer

    'Columns from worksheet
    Dim sGroupName As String
    Dim sEventNo
    Dim sHeat As String
    Dim sName
    Dim sTime As String

    Dim sThisEvent
    Dim sThisGroupName As String
    Dim sThisSwitchedEventNo As String
    Dim rTempRng As Range

    'sGroupNames = Array("A  Age Group (8 and Under)", "B  Age Group (9 and 10)", "C  Age Group (11 and 12)", "D  Age Group (13 +)")
    'The Group Names should be added to the spreedsheet

    'iRowOrigin is the row where this Age-Group begins
    'iRowOfEvents = iRowOrig + 1
    'iRowNamesStart = iRowOfEvents + 1

    'What row contains the events and what row contains the names?
    iRow = iRowOrig
    iCol = iColOrig
    bStop = False
    While (bStop = False)
        sTemp = Cells(iRow, iCol).Value
        If Mid(sTemp, 1) = "First Name" Then
            iRowOfEvents = iRow
            iRowNamesStart = iRow + 1
            iRowThisAgeGroup = iRow - 1
            'Get this Group Name
            sThisGroupName = Trim(Cells(iRowThisAgeGroup, iCol)) '********
            bStop = True
        Else
            iRow = iRow + 1
        End If
    Wend

    'Find the last row for this age-group.
    iRowAgeEnd = FindLastRowForThisAgeGroup(iRowOrig, iColOrig)

    'Find the first and last event-columns
    'https://msdn.microsoft.com/en-us/vba/excel-vba/articles/range-find-method-excel
    bStop = False
    iRow = iRowOfEvents
    iColEventFirst = 0
    With Range(iRow & ":" & iRow)
    Set rTempRng = .Find("#", , xlValues, xlPart, xlByColumns, xlNext)
    If Not rTempRng Is Nothing Then
        iColEventFirst = rTempRng.Column
        Do
            iColEventLast = rTempRng.Column
            Set rTempRng = .FindNext(rTempRng)
        Loop While Not rTempRng Is Nothing And rTempRng.Column <> iColEventFirst
    End If
    End With
    If iColEventFirst = 0 Then
        MsgBox cThisSub & "Can not find any events descriptors like #21-25 Breast"
        Stop
    End If

    'Build Event-strings for each swimmer in this age-group
    'Produces CSV lines like this;
    'Boys Time Trials,A  Age Group (8 and Under),#06-25 Free,Aleksy Fradlis,2799
    'Boys Time Trials,A  Age Group (8 and Under),#30-25 Fly,Aiden Trakhtenberg,4534
    'With special formatting for relays.

    For iColEvent = iColEventFirst To iColEventLast Step 1   'scan across columns in groups of 3
     If (Mid(Cells(iRowOfEvents, iColEvent).Value, 1, 1)) <> "#" Then
     Else
        'create strings for each swimmer
        iRow = 0
        iCol = iColOrig
        For iRow = iRowNamesStart To iRowAgeEnd - 1 Step 1 'the swimmers in this age-group - scan down list
            'Get and Reset these variables.
            bRelay = False
            bSwitchToIndividualEvent = False
            sGroupName = sThisGroupName 'The group name could be modified in this loop
            sEventNo = Trim(Cells(iRowOfEvents, iColEvent).Value) 'event
            sHeat = Trim(UCase(Cells(iRow, iColEvent - 1).Value))
            sName = Trim(Cells(iRow, iCol).Value) & " " & Trim(Cells(iRow, iCol + 1).Value) 'swimmers's name
            sTime = Trim(Cells(iRow, iColEvent).Value) 'time
            'Begin Processing Events
            If sTime = "" Then 'don't create strings for sTime blank
            'If sTime = "" Then sTime = "999999" 'option for Time Trials so we know we don't have a time.
            Else 'Start processing times.
                If (InStr(1, sEventNo, "#01") > 0) Or (InStr(1, sEventNo, "#02") > 0) Or (InStr(1, sEventNo, "#03") > 0) Or (InStr(1, sEventNo, "#04") > 0) Then
                    '***ENCODE MEDLEY RELAY.
                    'Are we swimming backstroke?
                    If (InStr(1, sHeat, "-1", vbTextCompare) > 0) Then
                        sEventNo = sEventNo & "-50 Back"
                        bRelay = True
                        '***ADD INDIVIDUAL EVENT
                        'Backstroke counts as an official individual time.
                        'Add individual event if the group [B or C] has one.
                        If (InStr(1, sEventNo, "#01") > 0) And (Mid(sGroupName, 1, 1) = "B") Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sThisSwitchedEventNo = "#15-50 Back"
                            bSwitchToIndividualEvent = True
                        ElseIf (InStr(1, sEventNo, "#01") > 0) And (Mid(sGroupName, 1, 1) = "C") Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sThisSwitchedEventNo = "#17-50 Back"
                            bSwitchToIndividualEvent = True
                        ElseIf (InStr(1, sEventNo, "#02") > 0) And (Mid(sGroupName, 1, 1) = "B") Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sThisSwitchedEventNo = "#16-50 Back"
                            bSwitchToIndividualEvent = True
                        ElseIf (InStr(1, sEventNo, "#02") > 0) And (Mid(sGroupName, 1, 1) = "C") Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sThisSwitchedEventNo = "#18-50 Back"
                            bSwitchToIndividualEvent = True
                        End If
                    ElseIf (InStr(1, sHeat, "-2", vbTextCompare) > 0) Then
                        sEventNo = sEventNo & "-50 Breast"
                        bRelay = True
                    ElseIf (InStr(1, sHeat, "-3", vbTextCompare) > 0) Then
                        sEventNo = sEventNo & "-50 Fly"
                        bRelay = True
                    ElseIf (InStr(1, sHeat, "-4", vbTextCompare) > 0) Then
                        '***MAP Medley Free Leg into Free Relay Event.
                        'can safely be removed.
                        If (InStr(1, sEventNo, "#01") > 0) Then
                           sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                           sEventNo = "#37-Jr. Girls 200 FR"
                        ElseIf (InStr(1, sEventNo, "#02") > 0) Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sEventNo = "#38-Jr. Boys 200 FR"
                        ElseIf (InStr(1, sEventNo, "#03") > 0) Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sEventNo = "#39-Sr. Girls 200 FR"
                        ElseIf (InStr(1, sEventNo, "#04") > 0) Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sEventNo = "#40-Sr. Boys 200 FR"
                        End If
                        sEventNo = sEventNo & "-50 Free"
                        bRelay = True
                    ElseIf (InStr(1, sHeat, "-0", vbTextCompare) > 0) Then 'this is the relay elasped time
                        sName = "Lane " & Mid(sHeat, 1, InStr(1, sHeat, "-", vbTextCompare) - 1)
                        'Force this time to the higher group.
                        If (InStr(1, sEventNo, "#01") > 0) Or (InStr(1, sEventNo, "#02") > 0) Then
                            Debug.Print cThisSub & " Switching group for Jr Medley Relay"
                            sGroupName = "C  Age Group (11 and 12)"
                        End If
                        bRelay = True
                    Else ' error
                        Debug.Print cThisSub & "Relay position undefined -> " & sHeat
                        Stop
                    End If
                    'Finish processing this relay.
                ElseIf (InStr(1, sEventNo, "#37") > 0) Or (InStr(1, sEventNo, "#38") > 0) Or (InStr(1, sEventNo, "#39") > 0) Or (InStr(1, sEventNo, "#40") > 0) Then
                        '***encode FREESTYLE RELAY
'                        bRelay = False
'                        sHeat = Trim(Cells(iRow, iColEvent - 1).Value)
                        If (InStr(1, sHeat, "-1", vbTextCompare) > 0) Then
                            sEventNo = sEventNo & "-50 Free"
                            bRelay = True
                            'Backstroke counts as an official individual time. If the age-group has a 50 Backstroke change the sEventNo to it.
                            'This is where the event should change to a 50 breast stroke in their age group or insert a second event.
                            'will work for groups b and c
                            If (InStr(1, sEventNo, "#37") > 0) And (Mid(sGroupName, 1, 1) = "B") Then
                                sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                                sThisSwitchedEventNo = "#07-50 Free"
                                bSwitchToIndividualEvent = True
                            ElseIf (InStr(1, sEventNo, "#38") > 0) And (Mid(sGroupName, 1, 1) = "B") Then
                                sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                                sThisSwitchedEventNo = "#08-50 Free"
                                bSwitchToIndividualEvent = True
                            End If
                        ElseIf (InStr(1, sHeat, "-2", vbTextCompare) > 0) Then
                            sEventNo = sEventNo & "-50 Free"
                            bRelay = True
                        ElseIf (InStr(1, sHeat, "-3", vbTextCompare) > 0) Then
                            sEventNo = sEventNo & "-50 Free"
                            bRelay = True
                        ElseIf (InStr(1, sHeat, "-4", vbTextCompare) > 0) Then
                            sEventNo = sEventNo & "-50 Free"
                            bRelay = True
                        ElseIf (InStr(1, sHeat, "-0", vbTextCompare) > 0) Then
                            'this is the relay total time
                            sName = "Lane " & Mid(sHeat, 1, InStr(1, sHeat, "-", vbTextCompare) - 1)
                            'Put the total times for #37 or #38 in the C group.
                            If (InStr(1, sEventNo, "#37") > 0) Or (InStr(1, sEventNo, "#38") > 0) Then
                                Debug.Print cThisSub & " Switching group for Jr Freestyle Relay"
                                sGroupName = "C  Age Group (11 and 12)"
                            End If
                            bRelay = True
                        Else ' error
                            MsgBox cThisSub & "Relay position undefined -> " & sHeat
                            Stop
                        End If
                Else
                     'encode individual events
                     'special coding for DQ - Append DQ to sEventNo
                     If (Mid(sHeat, 1, 1) = "D") Then
                        sEventNo = sEventNo & "**" & "DQ" & "**"
                     End If
                End If 'process Medley Relay, Free Relay, other events.

                '***CONSTRUCT THE EVENT STRING.
                If bRelay Then sEventNo = Mid(sEventNo, 1, 1) & "r" & Mid(sEventNo, 2)
                'write the individual or relay event string
                sThisEvent = sMeetName & cCSV & sGroupName & cCSV & sEventNo & cCSV & sName & cCSV & sTime & cCSV & "'" & sHeat
                Debug.Print sThisEvent 'This is the output line we need
                Call WriteEvent(f, sThisEvent)
                iRecordCount = iRecordCount + 1 'output another event.
                If bSwitchToIndividualEvent Then 'write a second record for the individual event of the first leg of the relay.
                    sEventNo = sThisSwitchedEventNo
                    sThisEvent = sMeetName & cCSV & sGroupName & cCSV & sEventNo & cCSV & sName & cCSV & sTime & cCSV & "'" & sHeat
                    Debug.Print "**Additional Individual " & sThisEvent 'This is the output line we need
                    Call WriteEvent(f, sThisEvent)
                    iRecordCount = iRecordCount + 1 'output another event.
                End If
            End If 'wether or not we had a time
        Next 'next person - walking down rows
     End If 'finished processing all names for this Event
    Next 'next event - walking across columns
    NextAgeGroup = iRowAgeEnd 'pointer to starting row of next group.
    End Function
Function FindColumnWithName(sColName As String) As Integer

'ActiveCell.Rows("1:1").EntireRow.Select
 '   Selection.Find(What:="Time", After:=ActiveCell, LookIn:=xlValues, LookAt _
  '      :=xlWhole, SearchOrder:=xlByColumns, SearchDirection:=xlNext, MatchCase _
  '      :=True, SearchFormat:=False).Activate
  '   Range("Time").Select

'FindColumnWithName = ActiveCell.Column


Dim rngDateHeader As Range
Dim rngHeaders As Range
Set rngHeaders = Range("2:2") 'Looks in entire first row; adjust as needed.
Set rngDateHeader = rngHeaders.Find(sColName)
FindColumnWithName = rngDateHeader.Column
'Set rngDateHeader = Empty
'Set rngHeaders = Null
Debug.Print "hello"

'Application.Cursor = xlWait
'Application.ScreenUpdating = False
'...
'Application.ScreenUpdating = False
'Application.Cursor = xlDefault

End Function
Function WriteEvent(f, ByVal sThisEvent As String)
    'Debug.Print "..."
    'Write #iEventFile, sThisEvent
    f.writeline sThisEvent
'    Sub OpenTextFileTest()
'    Const ForReading = 1, ForWriting = 2, ForAppending = 3
'    Dim fs, f
'    Set fs = CreateObject("Scripting.FileSystemObject")
'    Set f   = fs.OpenTextFile("c:\testfile.txt", ForAppending, TristateFalse)
'    f.Write "Hello world!"
'    f.Close
'End Sub


End Function
Sub HeaderFromA1()
    'ActiveSheet.PageSetup.LeftHeader = Range("A1").Value
End Sub

Function FindLastRowForThisAgeGroup(ByVal iRow As Integer, ByVal iCol As Integer) As Integer
    'Find the last row for this age-group.
    '2018-11-04 replaces inline code FAJ
    Dim bStop As Boolean
    Dim sTemp As String
    Dim iRowAgeEnd As Integer

    bStop = False
    While (bStop = False)
        sTemp = Cells(iRow, iCol).Value
        If IsNumeric(sTemp) Then 'this is where we stop processing the age-group.
            iRowAgeEnd = iRow
            bStop = True
        Else
            iRow = iRow + 1
            'Cells(iRow, iCol).Select
        End If
    Wend
FindLastRowForThisAgeGroup = iRowAgeEnd
End Function
Function FindLastRowInTable(ByVal iRow As Integer, ByVal iCol As Integer, ByVal sLastLine As String) As Integer
    'walk down the column and look for cLastLine.
    '2018-11-04 replaces inline code FAJ

    Dim sTemp As String
    Dim bStop As Boolean
    Dim iRowsInTable As Integer
    sTemp = ""
    bStop = False

    While (bStop = False)
        sTemp = Cells(iRow, iCol).Value
        If sTemp = sLastLine Then
            iRowsInTable = iRow
            Debug.Print "MakeEvents: Rows in table " & iRowsInTable
            Debug.Print "Found last line at row " & iRowsInTable
            bStop = True 'Stop walking down table
        Else
            iRow = iRow + 1
        End If
    Wend
    FindLastRowInTable = iRowsInTable
End Function

Function SplitTimes()
'This function scans for the four 'splits' and the event-time of a specific heat, and
'calculates the event-time, or a split-time.
'
'Either the event-time or the missing split will be placed in the correct cell.
'The split-times for the Relay heats are entered as N-1 (split/leg 1), N-2 (split/leg 2), N-3 (split/leg 3), and N-4 (split/leg 4).
'The event-time is entered as N-0 and in this program it is refered to as leg zero; N-0
'where 'N' is an integer.

'The user must select (highlight) a range of cells in the HEAT column and then press control-t.
'To accomodate the Junior Relay, a range can span multiple age-groups but consist of ONE area (a contiguous selection).
'The user will be prompted for a HEAT number; enter an integer using a one digit. (*****The integer should accomodate two digits because
'the sometimes we use the HEAT as the lane number.

Dim cell As Range
Dim sTemp As String
Dim iRow As Integer
Dim iCol As Integer
Dim iIndex As Integer
Dim iThisRow As Integer
Dim iCount As Integer
Dim vResponse As Variant
'Dim iHeatNumber As Integer
Dim vHeatNumber As Variant
Dim sLegtime(4) As String
Dim iLegRow(4) As Integer
Dim iTargetIndex As Integer
Dim bCalculatedEventTime As Boolean
Dim bCalculatedSplit As Boolean
Dim sTime As String
Const cThisSub = "SplitTimes: "


'initiatlize variables
bCalculatedEventTime = False
bCalculatedSplit = False
For iIndex = 0 To 4
    iLegRow(iIndex) = 0
    sLegtime(iIndex) = ""
Next iIndex

'locate selection (selection of rows) and make sure it is only one area.
If (Selection.Areas.count <> 1) Then
    MsgBox "Select a continguous range.", vbCritical, cThisSub
    End
End If

vResponse = InputBox("Enter the heat/lane number.")
'If Not (IsNumeric(vResponse)) Then
'    MsgBox "Heat number must be an integer - you entered (" & vResponse & ").", vbCritical, cThisSub
'    End
'Else
'    iHeatNumber = vResponse
'End If
vHeatNumber = Trim(vResponse)

'Look for cells that begin with "heatnumber-"

iRow = ActiveCell.Row
iCol = ActiveCell.Column

'Locate all the legs (0-4) for the given HEAT.
iCount = 0
For Each cell In Selection
        iThisRow = cell.Row
        Debug.Print "row " & iThisRow
        Debug.Print cell.Text
        sTemp = Mid(cell.Text, 1, Len(vHeatNumber) + 1)
        Debug.Print sTemp
        If (sTemp = vHeatNumber & "-") Then
            'found this HEAT.
            Debug.Print "got a leg"
            sTemp = Mid(cell.Text, Len(vHeatNumber) + 2, 1)
            'is the leg designator good?
            If IsNumeric(sTemp) Then
                iIndex = sTemp
                Debug.Print iIndex
            Else
                MsgBox "Bad leg designator (" & cell.Text & ") in row " & iThisRow, vbCritical, cThisSub
                End
            End If
            'load the leg designator and leg time (may be blank)into an array.
            If (iLegRow(iIndex) <> 0) Then
                MsgBox "For HEAT " & vHeatNumber & " leg " & iIndex & " is duplicated in row " & iThisRow, vbCritical, cThisSub
                End
            End If
            iLegRow(iIndex) = cell.Row 'leg designator
            sLegtime(iIndex) = Cells(cell.Row, iCol + 1) 'leg time
            Debug.Print "row-> " & iLegRow(iIndex) & " is leg " & iIndex & " with time " & sLegtime(iIndex)
            iCount = iCount + 1
            If (iCount > 5) Then
                MsgBox "Too many legs (" & iCount & ") in this heat", vbCritical, cThisSub
                End
            End If
        End If
Next cell
Debug.Print "Located " & iCount & " legs in HEAT " & vHeatNumber
For iIndex = 0 To 4
Debug.Print "row-> " & iLegRow(iIndex) & " is leg " & iIndex & " with time " & sLegtime(iIndex)
Next iIndex
If (iCount <> 5) Then
    MsgBox "A leg is missing for HEAT " & vHeatNumber & ". Check the selected range.", vbCritical, cThisSub
    End
End If

'What do we have to calculate?
'Should we calculate the event-time (N-0)?
If sLegtime(0) = "" Then
    'calculate sum of the four legs
    sTime = 0
    For iIndex = 1 To 4
        sTime = SwimTime(sTime, sLegtime(iIndex), 1)
    Next iIndex
    Debug.Print sTime
    Cells(iLegRow(0), iCol + 1).Select
    Selection.NumberFormat = "00"":""00"".""00"
    Cells(iLegRow(0), iCol + 1) = sTime 'write time of leg 0 to cell.
    bCalculatedEventTime = True
    MsgBox "For HEAT " & vHeatNumber & " the calculated event-time is " & sTime, vbInformation, cThisSub
End If

'Event-time (N-0)is present and ONE of the splits are missing?
'How many splits are missing?
iCount = 0
For iIndex = 1 To 4
    If sLegtime(iIndex) = "" Then iCount = iCount + 1
Next iIndex

If iCount > 1 Then
    MsgBox iCount & " swim times are missing in HEAT " & vHeatNumber & ".", vbCritical, cThisSub
    End
End If

If (sLegtime(0) <> "") And (iCount = 1) Then
    'lets calculate the missing split-time.
    iTargetIndex = 0
    For iIndex = 1 To 4
        If (sLegtime(iIndex) = "") Then
            iTargetIndex = iIndex
        End If
    Next iIndex
    If iTargetIndex = 0 Then
        MsgBox "A split time is missing.", vbCritical, cThisSub 'check if more than one missing leg.
        End
    End If
    sLegtime(iTargetIndex) = "0"
    sTime = sLegtime(0)
    For iIndex = 1 To 4
        sTime = SwimTime(sLegtime(iIndex), sTime, 2)
    Next iIndex
    Debug.Print "The missing leg (" & vHeatNumber & "-" & iTargetIndex & ") is " & sTime
    Cells(iLegRow(iTargetIndex), iCol + 1).Select
    Selection.NumberFormat = "00"":""00"".""00"
    Cells(iLegRow(iTargetIndex), iCol + 1) = sTime
    bCalculatedSplit = True
    MsgBox "Calculated the missing split (" & vHeatNumber & "-" & iTargetIndex & ") as " & sTime, vbInformation, cThisSub
End If
'If the event-time and all the splits are present then validate the event-time.
If (bCalculatedEventTime = False And bCalculatedSplit = False) Then
    'Validate that the event-time is the sum of the 4 splits.
    sTime = 0
    For iIndex = 1 To 4
        sTime = SwimTime(sTime, sLegtime(iIndex), 1)
    Next iIndex

    'Compare the calculated event-time to the stated event-time (N-0)
    'but first trim leading zeros.
    If (CLng(sTime) = CLng(sLegtime(0))) Then
        sTemp = "The splits for HEAT " & vHeatNumber & " are correct."
        MsgBox sTemp, vbInformation, cThisSub
    Else
        sTemp = "For Heat " & vHeatNumber & " the sum of the split times (" & CLng(sTime) & ") do not equal the event time (" & CLng(sLegtime(0)) & ")."
        sTemp = sTemp & " They differ by " & (CLng(sTime) - CLng(sLegtime(0))) / 100 & "."
        MsgBox sTemp, vbCritical, cThisSub
    End If
End If


End Function


Public Sub SelectionTest()
Dim r As Range
Dim count As Integer

Dim cell As Range
Dim s As String

  Select Case Selection.Areas.count
  Case 0:
    MsgBox "Nothing selected."
  Case 1:
    MsgBox "Selected range: " & Selection.Areas(1).Address(False, False)
  Case Else
    s = ""
    For Each r In Selection.Areas
      s = s + vbNewLine + r.Address(False, False)
    Next r
    MsgBox "Selected several areas:" & s
  End Select
  For Each cell In Selection
        Debug.Print cell.Text
        count = count + 1
    Next cell

End Sub






Attribute VB_Name = "EventMaker"
Option Explicit
'Public sEvent As String
Const cDP = vbFalse 'flag for enabling debug.print statements - Global
Const cEventFilePath = "\Events.csv"
Const gbAppend = vbFalse
Dim iEventFile As Integer

Sub MakeEvents()
Attribute MakeEvents.VB_ProcData.VB_Invoke_Func = " \n14"
'Copyright 2017 FAJ
'Author FAJ 12/06/2018
'Main
'This Routine takes the Meet/Time-Trial results as input and produces
'rows of events which are used to create a Report (Pivot Table).
'Makes events from each MeetResults worksheet (tab) from which it was launched.
'Produces CSV lines like this;
'Boys Time Trials,A  Age Group (8 and Under),#06-25 Free,Aleksy Fradlis,2799
'Boys Time Trials,A  Age Group (8 and Under),#30-25 Fly,Aiden Trakhtenberg,4534
'Rev 2.0
    'added 999999 for swimmers with no times in an event.
    'different formats for heat sheets.
'Rev 3.0
    'Took out 'Debug.Print Now twice
    'If sTime = "" Then sTime = "999999" *** ONLY FOR TIME TRIALS ****
'Rev 4.0
    'First meet NO MORE BLANK TIMES.
'Rev 5.0
    'Display number of records created via iRecordCount.
'Rev 6.0
    'Special processing for Relays 2017-03-06
'Rev 7.0 FJ 2017-03-20
    'Ignore relay HEATS that end in "-0". They are the relay's cummulative time.
    'Broke processing into three groups; Medley Relay, Free Relay and all others.
'Rev 7.1
    'Add output for relay totals. Heat column looks like 3[e]-1, 3[e]-2, 3[e]-3, 3[e]-4 where "e" designates exhibition
    'Basically constructing a Swimmer name from the Heat prefix concatenated with the Event.
'Rev 7.11 FJ 2017-11-17
    'NextAgeGroup automatically finds the first and last event columns for each age-group
    ' and stuff them in iColEventFirst and iColEventLast.
    'In NextAgeGroup added two new variables (iRowOfEvents and iRowNamesStart)
    ' to accomodate adding age-group names into spreedsheet;e.g., "A  Age Group (8 and Under)"
    'Function WriteEvent - Outputs events to (Application.DefaultFilePath & "\Events.csv").
'Rev 8.00 FJ 2017-12-19
    'Major changes to the function NextAgeGroup.
    'iColEventFirst is based on locating first cell that begins with "#", the prefix of an event.
    'The age-group string is taken from the table. Thus age-groups become unlimited.
'Rev 8.01 FJ 2017-12-25
    'Made parameters for the file that the events are written to.
    'https://www.thespreadsheetguru.com/blog/vba-guide-text-files
'Rev 8.02 FJ 2018-02-13
    'Changes to "NextAgeGroup:
    'Special processing for Backstroke leg of Medley relay.
    'New way to find first and last event descriptors.

    'Open List
    'Special processing for medley relay - add entry for 50
    'Special processing for freestyle relay - if lead-off ad entry for 50 free.
    'special processing for calculating times of relays and listing them (Lane 1 or 2 or 3) confusing.
'Rev 8.5 FJ 2018-02-22
    'Relays - first leg gets an ADDITIONAL individual event
    'Relays - change free style from MEDLEY into free style from RELAY
    'Capture Heat and original event in RELAY EVENTS.
    'gbSingleRun to open as write or append...Needs manual insertion of single cell if pasting in appended records.
'Rev 8.6 FJ 2018-03-16 Events file uses ThisWorkSheet.Path
'Rev 8.7 FJ 2018-11-14
    'Replaced code with function FindLastRowForThisAgeGroup
    'Replaced code with function FindLastRowInTable
Dim iRecordCount As Integer ' the number of events generated.
Dim iRow As Integer
Dim iCol As Integer
Dim iRowAll As Integer
Dim iRowsInTable As Integer 'end of section for event table
Dim iColEvent As Integer
Dim iAgeGroup As Integer

Dim sMeetName As String 'Example 11/22/2016 Intramural
Dim sEvent As String
Dim sTemp As String
Dim sAnswer As String

Dim sEventFilePath As String
Dim iEventFileHandle As Integer

Dim bStop As Boolean

Const cLastLine = "Net"
Const cRowOrig = 1 'This is where the table begins.
Const cColOrig = 1


sEventFilePath = ThisWorkbook.Path & cEventFilePath
    'iEventFile = FreeFile
'    If (gbSingleRun) Then
'        Open sEventFilePath For Output As iEventFile
'    Else
'        Open sEventFilePath For Append As iEventFile
'    End If
    Const cForReading = 1, cForWriting = 2, cForAppending = 8
    Const cTristateFalse = 0 'Opens the file as ASCII.
    Const cCreateFile = vbTrue 'creates files if it does not exist.
    Dim fs
    Dim f
    Dim iAccessType
    Set fs = CreateObject("Scripting.FileSystemObject")
    If (Not gbAppend) Then
        iAccessType = cForWriting
    Else
        iAccessType = cForAppending
    End If
    Set f = fs.OpenTextFile(sEventFilePath, iAccessType, cCreateFile, cTristateFalse)

    iRowsInTable = 0

    'Application.SendKeys "^g ^a {DEL}"    'Clear intermediate screen.  'Big problem with this - don't use. 'It highlites code at end of run.
    'MsgBox "MakeEvents: Make sure the correct number of event columns are set in NextAgeGroup."

    'sAnswer = MsgBox("Do you set the correct number of columns in module NextAgeGroup?", vbYesNoCancel, "MakeEvents")
    'If (sAnswer = vbCancel) Or (sAnswer = vbNo) Then End

    Debug.Print Now
    sMeetName = Trim(Cells(cRowOrig, cColOrig).Value)
    '

    'Figure out the last row of the input table.
    iRowsInTable = FindLastRowInTable(cRowOrig, cColOrig, cLastLine)

    'find next (or first) age-group and create events.
    iRow = cRowOrig
    iCol = cColOrig
    iAgeGroup = 1
    iRecordCount = 0 'ultimately contains net record count of all groups.
    While (iRow < iRowsInTable)
        'Debug.Print "Get Age Group"
        iRow = NextAgeGroup(iRow, iCol, iAgeGroup, sMeetName, iRecordCount, f)
            iRow = iRow + 1 'next age-group starts here or this was the last age-group
            'iAgeGroup = iAgeGroup + 1 'Decap here and in call to function.
        'Debug.Print iRow
    Wend
    'Debug.Print Now
    Debug.Print "MakeEvents: Record Count " & iRecordCount
    'Close iEventFile  'close the event file.
    f.Close
    MsgBox ("MakeEvents: Created " & iRecordCount & " events. Finis")

    End Sub
    Function NextAgeGroup(ByRef iRowOrig As Integer, ByRef iColOrig As Integer, ByRef iAgeGroup As Integer, ByRef sMeetName As String, ByRef iRecordCount As Integer, f) As Integer
    '2017-12-19 Major modifications to this function.
    'This function is called repeatedly and creates event-strings for an Age-Group.
    'The function returns a row as integer. It is a pointer to the last row in the processed age group.
    'The calling function stops calling this functions when the row returned is equal to the maximum rows in the table.
    'iRowOrig and iColOrig as input give "hints" as to the head of this Age-Group.'The exact row is found programmatically to accomodate earlier implementations of the MeetSheet.
    'iAgeGroup, Decaprecated
    'sMeetName as input, for building events-strings.
    'iRecordCount as input and output; the net of all the event-strings created
    'iEventFileHandle - reference to file that Events are written to.
    '2018-02-12 Special processing for Backstroke leg of Medley relay.
    '2018-02-13 New way to find first and last event descriptors.
    Const cThisSub = "NextAgeGroup: "
    Const cCSV = ","
    Dim bStop As Boolean
    Dim bRelay As Boolean
    Dim bSwitchToIndividualEvent As Boolean 'Indicates this leg of the relay is switched to an individual event.
    Dim sTemp As String
    Dim iRowThisAgeGroup 'Row that contains this Age-Group string.
    Dim iRowOfEvents As Integer 'Row containing event-names.
    Dim iRowNamesStart As Integer 'First row with swimmer-name.
    Dim iRowAgeEnd As Integer 'end of section for age-group.
    Dim iRow As Integer
    Dim iCol As Integer
    Dim iColEvent As Integer ' Row Header - The specific event; eg '#18-50 Back'
    Dim iColEventFirst As Integer
    Dim iColEventLast As Integer

    'Columns from worksheet
    Dim sGroupName As String
    Dim sEventNo
    Dim sHeat As String
    Dim sName
    Dim sTime As String

    Dim sThisEvent
    Dim sThisGroupName As String
    Dim sThisSwitchedEventNo As String
    Dim rTempRng As Range

    'sGroupNames = Array("A  Age Group (8 and Under)", "B  Age Group (9 and 10)", "C  Age Group (11 and 12)", "D  Age Group (13 +)")
    'The Group Names should be added to the spreedsheet

    'iRowOrigin is the row where this Age-Group begins
    'iRowOfEvents = iRowOrig + 1
    'iRowNamesStart = iRowOfEvents + 1

    'What row contains the events and what row contains the names?
    iRow = iRowOrig
    iCol = iColOrig
    bStop = False
    While (bStop = False)
        sTemp = Cells(iRow, iCol).Value
        If Mid(sTemp, 1) = "First Name" Then
            iRowOfEvents = iRow
            iRowNamesStart = iRow + 1
            iRowThisAgeGroup = iRow - 1
            'Get this Group Name
            sThisGroupName = Trim(Cells(iRowThisAgeGroup, iCol)) '********
            bStop = True
        Else
            iRow = iRow + 1
        End If
    Wend

    'Find the last row for this age-group.
    iRowAgeEnd = FindLastRowForThisAgeGroup(iRowOrig, iColOrig)

    'Find the first and last event-columns
    'https://msdn.microsoft.com/en-us/vba/excel-vba/articles/range-find-method-excel
    bStop = False
    iRow = iRowOfEvents
    iColEventFirst = 0
    With Range(iRow & ":" & iRow)
    Set rTempRng = .Find("#", , xlValues, xlPart, xlByColumns, xlNext)
    If Not rTempRng Is Nothing Then
        iColEventFirst = rTempRng.Column
        Do
            iColEventLast = rTempRng.Column
            Set rTempRng = .FindNext(rTempRng)
        Loop While Not rTempRng Is Nothing And rTempRng.Column <> iColEventFirst
    End If
    End With
    If iColEventFirst = 0 Then
        MsgBox cThisSub & "Can not find any events descriptors like #21-25 Breast"
        Stop
    End If

    'Build Event-strings for each swimmer in this age-group
    'Produces CSV lines like this;
    'Boys Time Trials,A  Age Group (8 and Under),#06-25 Free,Aleksy Fradlis,2799
    'Boys Time Trials,A  Age Group (8 and Under),#30-25 Fly,Aiden Trakhtenberg,4534
    'With special formatting for relays.

    For iColEvent = iColEventFirst To iColEventLast Step 1   'scan across columns in groups of 3
     If (Mid(Cells(iRowOfEvents, iColEvent).Value, 1, 1)) <> "#" Then
     Else
        'create strings for each swimmer
        iRow = 0
        iCol = iColOrig
        For iRow = iRowNamesStart To iRowAgeEnd - 1 Step 1 'the swimmers in this age-group - scan down list
            'Get and Reset these variables.
            bRelay = False
            bSwitchToIndividualEvent = False
            sGroupName = sThisGroupName 'The group name could be modified in this loop
            sEventNo = Trim(Cells(iRowOfEvents, iColEvent).Value) 'event
            sHeat = Trim(UCase(Cells(iRow, iColEvent - 1).Value))
            sName = Trim(Cells(iRow, iCol).Value) & " " & Trim(Cells(iRow, iCol + 1).Value) 'swimmers's name
            sTime = Trim(Cells(iRow, iColEvent).Value) 'time
            'Begin Processing Events
            If sTime = "" Then 'don't create strings for sTime blank
            'If sTime = "" Then sTime = "999999" 'option for Time Trials so we know we don't have a time.
            Else 'Start processing times.
                If (InStr(1, sEventNo, "#01") > 0) Or (InStr(1, sEventNo, "#02") > 0) Or (InStr(1, sEventNo, "#03") > 0) Or (InStr(1, sEventNo, "#04") > 0) Then
                    '***ENCODE MEDLEY RELAY.
                    'Are we swimming backstroke?
                    If (InStr(1, sHeat, "-1", vbTextCompare) > 0) Then
                        sEventNo = sEventNo & "-50 Back"
                        bRelay = True
                        '***ADD INDIVIDUAL EVENT
                        'Backstroke counts as an official individual time.
                        'Add individual event if the group [B or C] has one.
                        If (InStr(1, sEventNo, "#01") > 0) And (Mid(sGroupName, 1, 1) = "B") Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sThisSwitchedEventNo = "#15-50 Back"
                            bSwitchToIndividualEvent = True
                        ElseIf (InStr(1, sEventNo, "#01") > 0) And (Mid(sGroupName, 1, 1) = "C") Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sThisSwitchedEventNo = "#17-50 Back"
                            bSwitchToIndividualEvent = True
                        ElseIf (InStr(1, sEventNo, "#02") > 0) And (Mid(sGroupName, 1, 1) = "B") Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sThisSwitchedEventNo = "#16-50 Back"
                            bSwitchToIndividualEvent = True
                        ElseIf (InStr(1, sEventNo, "#02") > 0) And (Mid(sGroupName, 1, 1) = "C") Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sThisSwitchedEventNo = "#18-50 Back"
                            bSwitchToIndividualEvent = True
                        End If
                    ElseIf (InStr(1, sHeat, "-2", vbTextCompare) > 0) Then
                        sEventNo = sEventNo & "-50 Breast"
                        bRelay = True
                    ElseIf (InStr(1, sHeat, "-3", vbTextCompare) > 0) Then
                        sEventNo = sEventNo & "-50 Fly"
                        bRelay = True
                    ElseIf (InStr(1, sHeat, "-4", vbTextCompare) > 0) Then
                        '***MAP Medley Free Leg into Free Relay Event.
                        'can safely be removed.
                        If (InStr(1, sEventNo, "#01") > 0) Then
                           sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                           sEventNo = "#37-Jr. Girls 200 FR"
                        ElseIf (InStr(1, sEventNo, "#02") > 0) Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sEventNo = "#38-Jr. Boys 200 FR"
                        ElseIf (InStr(1, sEventNo, "#03") > 0) Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sEventNo = "#39-Sr. Girls 200 FR"
                        ElseIf (InStr(1, sEventNo, "#04") > 0) Then
                            sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                            sEventNo = "#40-Sr. Boys 200 FR"
                        End If
                        sEventNo = sEventNo & "-50 Free"
                        bRelay = True
                    ElseIf (InStr(1, sHeat, "-0", vbTextCompare) > 0) Then 'this is the relay elasped time
                        sName = "Lane " & Mid(sHeat, 1, InStr(1, sHeat, "-", vbTextCompare) - 1)
                        'Force this time to the higher group.
                        If (InStr(1, sEventNo, "#01") > 0) Or (InStr(1, sEventNo, "#02") > 0) Then
                            Debug.Print cThisSub & " Switching group for Jr Medley Relay"
                            sGroupName = "C  Age Group (11 and 12)"
                        End If
                        bRelay = True
                    Else ' error
                        Debug.Print cThisSub & "Relay position undefined -> " & sHeat
                        Stop
                    End If
                    'Finish processing this relay.
                ElseIf (InStr(1, sEventNo, "#37") > 0) Or (InStr(1, sEventNo, "#38") > 0) Or (InStr(1, sEventNo, "#39") > 0) Or (InStr(1, sEventNo, "#40") > 0) Then
                        '***encode FREESTYLE RELAY
'                        bRelay = False
'                        sHeat = Trim(Cells(iRow, iColEvent - 1).Value)
                        If (InStr(1, sHeat, "-1", vbTextCompare) > 0) Then
                            sEventNo = sEventNo & "-50 Free"
                            bRelay = True
                            'Backstroke counts as an official individual time. If the age-group has a 50 Backstroke change the sEventNo to it.
                            'This is where the event should change to a 50 breast stroke in their age group or insert a second event.
                            'will work for groups b and c
                            If (InStr(1, sEventNo, "#37") > 0) And (Mid(sGroupName, 1, 1) = "B") Then
                                sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                                sThisSwitchedEventNo = "#07-50 Free"
                                bSwitchToIndividualEvent = True
                            ElseIf (InStr(1, sEventNo, "#38") > 0) And (Mid(sGroupName, 1, 1) = "B") Then
                                sHeat = Mid(sEventNo, 1, (InStr(1, sEventNo, "-") - 1)) & "x" & sHeat
                                sThisSwitchedEventNo = "#08-50 Free"
                                bSwitchToIndividualEvent = True
                            End If
                        ElseIf (InStr(1, sHeat, "-2", vbTextCompare) > 0) Then
                            sEventNo = sEventNo & "-50 Free"
                            bRelay = True
                        ElseIf (InStr(1, sHeat, "-3", vbTextCompare) > 0) Then
                            sEventNo = sEventNo & "-50 Free"
                            bRelay = True
                        ElseIf (InStr(1, sHeat, "-4", vbTextCompare) > 0) Then
                            sEventNo = sEventNo & "-50 Free"
                            bRelay = True
                        ElseIf (InStr(1, sHeat, "-0", vbTextCompare) > 0) Then
                            'this is the relay total time
                            sName = "Lane " & Mid(sHeat, 1, InStr(1, sHeat, "-", vbTextCompare) - 1)
                            'Put the total times for #37 or #38 in the C group.
                            If (InStr(1, sEventNo, "#37") > 0) Or (InStr(1, sEventNo, "#38") > 0) Then
                                Debug.Print cThisSub & " Switching group for Jr Freestyle Relay"
                                sGroupName = "C  Age Group (11 and 12)"
                            End If
                            bRelay = True
                        Else ' error
                            MsgBox cThisSub & "Relay position undefined -> " & sHeat
                            Stop
                        End If
                Else
                     'encode individual events
                     'special coding for DQ - Append DQ to sEventNo
                     If (Mid(sHeat, 1, 1) = "D") Then
                        sEventNo = sEventNo & "**" & "DQ" & "**"
                     End If
                End If 'process Medley Relay, Free Relay, other events.

                '***CONSTRUCT THE EVENT STRING.
                If bRelay Then sEventNo = Mid(sEventNo, 1, 1) & "r" & Mid(sEventNo, 2)
                'write the individual or relay event string
                sThisEvent = sMeetName & cCSV & sGroupName & cCSV & sEventNo & cCSV & sName & cCSV & sTime & cCSV & "'" & sHeat
                Debug.Print sThisEvent 'This is the output line we need
                Call WriteEvent(f, sThisEvent)
                iRecordCount = iRecordCount + 1 'output another event.
                If bSwitchToIndividualEvent Then 'write a second record for the individual event of the first leg of the relay.
                    sEventNo = sThisSwitchedEventNo
                    sThisEvent = sMeetName & cCSV & sGroupName & cCSV & sEventNo & cCSV & sName & cCSV & sTime & cCSV & "'" & sHeat
                    Debug.Print "**Additional Individual " & sThisEvent 'This is the output line we need
                    Call WriteEvent(f, sThisEvent)
                    iRecordCount = iRecordCount + 1 'output another event.
                End If
            End If 'wether or not we had a time
        Next 'next person - walking down rows
     End If 'finished processing all names for this Event
    Next 'next event - walking across columns
    NextAgeGroup = iRowAgeEnd 'pointer to starting row of next group.
    End Function
Function FindColumnWithName(sColName As String) As Integer

'ActiveCell.Rows("1:1").EntireRow.Select
 '   Selection.Find(What:="Time", After:=ActiveCell, LookIn:=xlValues, LookAt _
  '      :=xlWhole, SearchOrder:=xlByColumns, SearchDirection:=xlNext, MatchCase _
  '      :=True, SearchFormat:=False).Activate
  '   Range("Time").Select

'FindColumnWithName = ActiveCell.Column


Dim rngDateHeader As Range
Dim rngHeaders As Range
Set rngHeaders = Range("2:2") 'Looks in entire first row; adjust as needed.
Set rngDateHeader = rngHeaders.Find(sColName)
FindColumnWithName = rngDateHeader.Column
'Set rngDateHeader = Empty
'Set rngHeaders = Null
Debug.Print "hello"

'Application.Cursor = xlWait
'Application.ScreenUpdating = False
'...
'Application.ScreenUpdating = False
'Application.Cursor = xlDefault

End Function
Function WriteEvent(f, ByVal sThisEvent As String)
    'Debug.Print "..."
    'Write #iEventFile, sThisEvent
    f.writeline sThisEvent
'    Sub OpenTextFileTest()
'    Const ForReading = 1, ForWriting = 2, ForAppending = 3
'    Dim fs, f
'    Set fs = CreateObject("Scripting.FileSystemObject")
'    Set f   = fs.OpenTextFile("c:\testfile.txt", ForAppending, TristateFalse)
'    f.Write "Hello world!"
'    f.Close
'End Sub


End Function
Sub HeaderFromA1()
    'ActiveSheet.PageSetup.LeftHeader = Range("A1").Value
End Sub

Function FindLastRowForThisAgeGroup(ByVal iRow As Integer, ByVal iCol As Integer) As Integer
    'Find the last row for this age-group.
    '2018-11-04 replaces inline code FAJ
    Dim bStop As Boolean
    Dim sTemp As String
    Dim iRowAgeEnd As Integer

    bStop = False
    While (bStop = False)
        sTemp = Cells(iRow, iCol).Value
        If IsNumeric(sTemp) Then 'this is where we stop processing the age-group.
            iRowAgeEnd = iRow
            bStop = True
        Else
            iRow = iRow + 1
            'Cells(iRow, iCol).Select
        End If
    Wend
FindLastRowForThisAgeGroup = iRowAgeEnd
End Function
Function FindLastRowInTable(ByVal iRow As Integer, ByVal iCol As Integer, ByVal sLastLine As String) As Integer
    'walk down the column and look for cLastLine.
    '2018-11-04 replaces inline code FAJ

    Dim sTemp As String
    Dim bStop As Boolean
    Dim iRowsInTable As Integer
    sTemp = ""
    bStop = False

    While (bStop = False)
        sTemp = Cells(iRow, iCol).Value
        If sTemp = sLastLine Then
            iRowsInTable = iRow
            Debug.Print "MakeEvents: Rows in table " & iRowsInTable
            Debug.Print "Found last line at row " & iRowsInTable
            bStop = True 'Stop walking down table
        Else
            iRow = iRow + 1
        End If
    Wend
    FindLastRowInTable = iRowsInTable
End Function

Function SplitTimes()
'This function scans for the four 'splits' and the event-time of a specific heat, and
'calculates the event-time, or a split-time.
'
'Either the event-time or the missing split will be placed in the correct cell.
'The split-times for the Relay heats are entered as N-1 (split/leg 1), N-2 (split/leg 2), N-3 (split/leg 3), and N-4 (split/leg 4).
'The event-time is entered as N-0 and in this program it is refered to as leg zero; N-0
'where 'N' is an integer.

'The user must select (highlight) a range of cells in the HEAT column and then press control-t.
'To accomodate the Junior Relay, a range can span multiple age-groups but consist of ONE area (a contiguous selection).
'The user will be prompted for a HEAT number; enter an integer using a one digit. (*****The integer should accomodate two digits because
'the sometimes we use the HEAT as the lane number.

Dim cell As Range
Dim sTemp As String
Dim iRow As Integer
Dim iCol As Integer
Dim iIndex As Integer
Dim iThisRow As Integer
Dim iCount As Integer
Dim vResponse As Variant
'Dim iHeatNumber As Integer
Dim vHeatNumber As Variant
Dim sLegtime(4) As String
Dim iLegRow(4) As Integer
Dim iTargetIndex As Integer
Dim bCalculatedEventTime As Boolean
Dim bCalculatedSplit As Boolean
Dim sTime As String
Const cThisSub = "SplitTimes: "


'initiatlize variables
bCalculatedEventTime = False
bCalculatedSplit = False
For iIndex = 0 To 4
    iLegRow(iIndex) = 0
    sLegtime(iIndex) = ""
Next iIndex

'locate selection (selection of rows) and make sure it is only one area.
If (Selection.Areas.count <> 1) Then
    MsgBox "Select a continguous range.", vbCritical, cThisSub
    End
End If

vResponse = InputBox("Enter the heat/lane number.")
'If Not (IsNumeric(vResponse)) Then
'    MsgBox "Heat number must be an integer - you entered (" & vResponse & ").", vbCritical, cThisSub
'    End
'Else
'    iHeatNumber = vResponse
'End If
vHeatNumber = Trim(vResponse)

'Look for cells that begin with "heatnumber-"

iRow = ActiveCell.Row
iCol = ActiveCell.Column

'Locate all the legs (0-4) for the given HEAT.
iCount = 0
For Each cell In Selection
        iThisRow = cell.Row
        Debug.Print "row " & iThisRow
        Debug.Print cell.Text
        sTemp = Mid(cell.Text, 1, Len(vHeatNumber) + 1)
        Debug.Print sTemp
        If (sTemp = vHeatNumber & "-") Then
            'found this HEAT.
            Debug.Print "got a leg"
            sTemp = Mid(cell.Text, Len(vHeatNumber) + 2, 1)
            'is the leg designator good?
            If IsNumeric(sTemp) Then
                iIndex = sTemp
                Debug.Print iIndex
            Else
                MsgBox "Bad leg designator (" & cell.Text & ") in row " & iThisRow, vbCritical, cThisSub
                End
            End If
            'load the leg designator and leg time (may be blank)into an array.
            If (iLegRow(iIndex) <> 0) Then
                MsgBox "For HEAT " & vHeatNumber & " leg " & iIndex & " is duplicated in row " & iThisRow, vbCritical, cThisSub
                End
            End If
            iLegRow(iIndex) = cell.Row 'leg designator
            sLegtime(iIndex) = Cells(cell.Row, iCol + 1) 'leg time
            Debug.Print "row-> " & iLegRow(iIndex) & " is leg " & iIndex & " with time " & sLegtime(iIndex)
            iCount = iCount + 1
            If (iCount > 5) Then
                MsgBox "Too many legs (" & iCount & ") in this heat", vbCritical, cThisSub
                End
            End If
        End If
Next cell
Debug.Print "Located " & iCount & " legs in HEAT " & vHeatNumber
For iIndex = 0 To 4
Debug.Print "row-> " & iLegRow(iIndex) & " is leg " & iIndex & " with time " & sLegtime(iIndex)
Next iIndex
If (iCount <> 5) Then
    MsgBox "A leg is missing for HEAT " & vHeatNumber & ". Check the selected range.", vbCritical, cThisSub
    End
End If

'What do we have to calculate?
'Should we calculate the event-time (N-0)?
If sLegtime(0) = "" Then
    'calculate sum of the four legs
    sTime = 0
    For iIndex = 1 To 4
        sTime = SwimTime(sTime, sLegtime(iIndex), 1)
    Next iIndex
    Debug.Print sTime
    Cells(iLegRow(0), iCol + 1).Select
    Selection.NumberFormat = "00"":""00"".""00"
    Cells(iLegRow(0), iCol + 1) = sTime 'write time of leg 0 to cell.
    bCalculatedEventTime = True
    MsgBox "For HEAT " & vHeatNumber & " the calculated event-time is " & sTime, vbInformation, cThisSub
End If

'Event-time (N-0)is present and ONE of the splits are missing?
'How many splits are missing?
iCount = 0
For iIndex = 1 To 4
    If sLegtime(iIndex) = "" Then iCount = iCount + 1
Next iIndex

If iCount > 1 Then
    MsgBox iCount & " swim times are missing in HEAT " & vHeatNumber & ".", vbCritical, cThisSub
    End
End If

If (sLegtime(0) <> "") And (iCount = 1) Then
    'lets calculate the missing split-time.
    iTargetIndex = 0
    For iIndex = 1 To 4
        If (sLegtime(iIndex) = "") Then
            iTargetIndex = iIndex
        End If
    Next iIndex
    If iTargetIndex = 0 Then
        MsgBox "A split time is missing.", vbCritical, cThisSub 'check if more than one missing leg.
        End
    End If
    sLegtime(iTargetIndex) = "0"
    sTime = sLegtime(0)
    For iIndex = 1 To 4
        sTime = SwimTime(sLegtime(iIndex), sTime, 2)
    Next iIndex
    Debug.Print "The missing leg (" & vHeatNumber & "-" & iTargetIndex & ") is " & sTime
    Cells(iLegRow(iTargetIndex), iCol + 1).Select
    Selection.NumberFormat = "00"":""00"".""00"
    Cells(iLegRow(iTargetIndex), iCol + 1) = sTime
    bCalculatedSplit = True
    MsgBox "Calculated the missing split (" & vHeatNumber & "-" & iTargetIndex & ") as " & sTime, vbInformation, cThisSub
End If
'If the event-time and all the splits are present then validate the event-time.
If (bCalculatedEventTime = False And bCalculatedSplit = False) Then
    'Validate that the event-time is the sum of the 4 splits.
    sTime = 0
    For iIndex = 1 To 4
        sTime = SwimTime(sTime, sLegtime(iIndex), 1)
    Next iIndex

    'Compare the calculated event-time to the stated event-time (N-0)
    'but first trim leading zeros.
    If (CLng(sTime) = CLng(sLegtime(0))) Then
        sTemp = "The splits for HEAT " & vHeatNumber & " are correct."
        MsgBox sTemp, vbInformation, cThisSub
    Else
        sTemp = "For Heat " & vHeatNumber & " the sum of the split times (" & CLng(sTime) & ") do not equal the event time (" & CLng(sLegtime(0)) & ")."
        sTemp = sTemp & " They differ by " & (CLng(sTime) - CLng(sLegtime(0))) / 100 & "."
        MsgBox sTemp, vbCritical, cThisSub
    End If
End If


End Function


Public Sub SelectionTest()
Dim r As Range
Dim count As Integer

Dim cell As Range
Dim s As String

  Select Case Selection.Areas.count
  Case 0:
    MsgBox "Nothing selected."
  Case 1:
    MsgBox "Selected range: " & Selection.Areas(1).Address(False, False)
  Case Else
    s = ""
    For Each r In Selection.Areas
      s = s + vbNewLine + r.Address(False, False)
    Next r
    MsgBox "Selected several areas:" & s
  End Select
  For Each cell In Selection
        Debug.Print cell.Text
        count = count + 1
    Next cell

End Sub






