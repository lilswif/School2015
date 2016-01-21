ary = Array(1,2,3,4,5)
For Each i In ary
If i = 3 Then Exit For
WScript.Echo i
Next
WScript.Echo "Statement following Next"