option explicit
dim objShell, objFile
set objShell = CreateObject("wscript.shell")
set objFile = CreateObject("Scripting.FileSystemObject")
dim directory
directory = objFile.GetParentFolderName(wscript.ScriptFullName)

sub Main()
    msgbox("Terminate program")
    objShell.Run("taskkill /f /im wscript.exe")
    msgbox("Something went wrong")
    objShell.Run("taskkill /f /im wscript.exe")
    msgbox("Something went really wrong")
end sub

sub Breakpoint(message)
    wscript.Echo(message)
    wscript.Quit
end sub

Main()