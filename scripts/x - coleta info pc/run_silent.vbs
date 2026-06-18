Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Get the directory where this script is located
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
pythonScript = scriptDir & "\concatena_sheets.py"

' Run Python script silently (no console window)
WshShell.Run "pythonw.exe """ & pythonScript & """", 0, False




