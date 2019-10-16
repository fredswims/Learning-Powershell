<<<<<<< HEAD
Attribute VB_Name = "Module1"
Sub RunSplitTimes()
Attribute RunSplitTimes.VB_Description = "Runs the function SplitTimes"
Attribute RunSplitTimes.VB_ProcData.VB_Invoke_Func = "t\n14"
'
' RunSplitTimes Macro
' Runs the function SplitTimes
'
' Keyboard Shortcut: Ctrl+t
'
    Call SplitTimes
    
End Sub
Sub Place()
Attribute Place.VB_ProcData.VB_Invoke_Func = "I\n14"
'
' Place Macro
' Append Place to the Heat/Lane column as Px
'
' Keyboard Shortcut: Ctrl+Shift+I
'

Dim myPlace As Variant
myPlace = InputBox("Give me some input")
ActiveCell = "'" & ActiveCell.Text & "P" & myPlace
Cells(ActiveCell.Row, ActiveCell.Column + 1).Select


End Sub


=======
Attribute VB_Name = "Module1"
Sub RunSplitTimes()
Attribute RunSplitTimes.VB_Description = "Runs the function SplitTimes"
Attribute RunSplitTimes.VB_ProcData.VB_Invoke_Func = "t\n14"
'
' RunSplitTimes Macro
' Runs the function SplitTimes
'
' Keyboard Shortcut: Ctrl+t
'
    Call SplitTimes
    
End Sub
Sub Place()
Attribute Place.VB_ProcData.VB_Invoke_Func = "I\n14"
'
' Place Macro
' Append Place to the Heat/Lane column as Px
'
' Keyboard Shortcut: Ctrl+Shift+I
'

Dim myPlace As Variant
myPlace = InputBox("Give me some input")
ActiveCell = "'" & ActiveCell.Text & "P" & myPlace
Cells(ActiveCell.Row, ActiveCell.Column + 1).Select


End Sub


>>>>>>> 41ee0154166690cedebc71e59c867db9d6ed5ea8
