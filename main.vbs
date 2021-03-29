set objShell = CreateObject("wscript.shell")
set objFile = CreateObject("Scripting.FileSystemObject")
set objHTML = CreateObject("htmlfile")

'subDebug()

strDirectory = objShell.CurrentDirectory
varSeconds = 104
strPrev = ""
varFirst = 1

function funcMidString(fInput, fLeft, fRight)
    funcMidString = mid(fInput, instr(fInput, fLeft) + len(fLeft), instr(instr(fInput, fLeft), fInput, fRight) - (instr(fInput, fLeft) + len(fLeft)))
end function

function funcGetInput(fCommand)
    objShell.sendkeys("{F12}")
    wscript.sleep(500)
    objShell.sendkeys("^f")
    wscript.sleep(100)
    objShell.sendkeys("^a")
    wscript.sleep(100)
    objShell.sendkeys("12835210214241")
    wscript.sleep(100)
    objShell.sendkeys("^a")
    wscript.sleep(100)
    objShell.sendkeys("^c")
    wscript.sleep(100)

    if not objHTML.ParentWindow.ClipboardData.GetData("text") = "12835210214241" then
        funcGetInput = false
        wscript.echo("Failsafe activated")
        wscript.quit
    end if

    objShell.sendkeys("~")
    wscript.sleep(100)
    objShell.sendkeys("^a")
    wscript.sleep(100)
    objShell.sendkeys(fCommand)
    wscript.sleep(100)
    objShell.sendkeys("^a")
    wscript.sleep(100)
    objShell.sendkeys("^c")
    wscript.sleep(100)

    if not objHTML.ParentWindow.ClipboardData.GetData("text") = fCommand then
        funcGetInput = false
        wscript.echo("Failsafe activated")
        wscript.quit
    end if

    objShell.sendkeys("~")
    wscript.sleep(100)
    objShell.sendkeys("+~")
    wscript.sleep(100)
    
    for i = 1 to 3
        objShell.sendkeys("{TAB}")
        wscript.sleep(100)
    next

    wscript.sleep(500)
    objShell.sendkeys("^c")
    wscript.sleep(500)
    objShell.sendkeys("%{TAB}")
    wscript.sleep(500)

    funcGetInput = objHTML.ParentWindow.ClipboardData.GetData("text")
end function

function funcGetCommand(fInput, fCommand)
    if instr(fInput, fCommand) then
        funcGetCommand = funcMidString(objHTML.ParentWindow.ClipboardData.GetData("text"), fCommand, "</div>")
    else
        funcGetCommand = false
    end if
end function

sub subDebug()
    wscript.echo funcMidString(objHTML.ParentWindow.ClipboardData.GetData("text"), "/say", "</div>")
    wscript.quit
end sub

'Countermeasures initialization
objFile.createtextfile(strDirectory & "\ionvop-exit.vbs", true).writeline("set objShell = CreateObject(""WScript.Shell"")" & vbCrlf & "msgbox(""Kill bot"")" & vbCrlf & "call objShell.run(""taskkill /f /im wscript.exe"",,True)" & vbCrlf & "wscript.echo(""BEWARE: Bot was unsuccessfully killed"")")
objShell.run("""" & strDirectory & "\ionvop-exit.vbs""")
wscript.sleep(1000)
objFile.deletefile(strDirectory & "\ionvop-exit.vbs")

msgbox("Start")
wscript.sleep(3000)

do
    wscript.echo("Main body goes here")
    wscript.quit
loop