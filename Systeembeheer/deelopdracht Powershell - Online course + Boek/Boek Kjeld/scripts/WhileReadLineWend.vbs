Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile("C:\fso\testfile.txt")
While Not objFile.AtEndOfStream
WScript.Echo objFile.ReadLine
Wend