set objShell = CreateObject("wscript.shell")
set objFile = CreateObject("Scripting.FileSystemObject")
set objHTML = CreateObject("htmlfile")
randomize

'sDebug()

strDirectory = objShell.CurrentDirectory
strPrev = ""
varFirst = 1
strHTML = ""
strCommand = ""

function funcMidString(fInput, fLeft, fRight)
    funcMidString = mid(fInput, instr(fInput, fLeft) + len(fLeft), instr(instr(fInput, fLeft), fInput, fRight) - (instr(fInput, fLeft) + len(fLeft)))
end function

function funcRand(fMin, fMax)
    funcRand = int((fMax-fMin+1)*rnd+fMin)
end function

function funcGetHTML()
    objShell.sendkeys("{F12}")
    wscript.sleep(1000)
    objShell.sendkeys("^f")
    wscript.sleep(100)
    objShell.sendkeys("failsafe")
    wscript.sleep(100)
    objShell.sendkeys("~")
    wscript.sleep(100)
    objShell.sendkeys("^a")
    wscript.sleep(100)
    objShell.sendkeys("^c")
    wscript.sleep(100)

    if not objHTML.ParentWindow.ClipboardData.GetData("text") = "failsafe" then
        funcGetHTML = false
        wscript.echo("Failsafe activated")
        wscript.quit
    end if

    objShell.sendkeys("^a")
    wscript.sleep(100)
    objShell.sendkeys("body")
    wscript.sleep(100)
    objShell.sendkeys("~")
    wscript.sleep(100)
    objShell.sendkeys("+{TAB}")
    wscript.sleep(100)
    objShell.sendkeys("~")
    wscript.sleep(100)
    objShell.sendkeys("{F2}")
    wscript.sleep(1000)
    objShell.sendkeys("^a")
    wscript.sleep(1000)
    objShell.sendkeys("^c")
    wscript.sleep(5000)
    funcGetHTML = objHTML.ParentWindow.ClipboardData.GetData("text")
    objShell.sendkeys("%{TAB}")
    wscript.sleep(1000)
end function

function funcGetCommand(fInput, fCommand)
    if instr(fInput, fCommand) then
        funcGetCommand = funcMidString(mid(fInput, instrrev(fInput, fCommand)), fCommand, "</div>")
    else
        funcGetCommand = false
    end if
end function

function funcGetParameters(fInput, fCommand)
    funcGetParameters = mid(fInput, len(fCommand) + 1)
end function

objFile.createtextfile(strDirectory & "\ionvop-exit.vbs", true).writeline("set objShell = CreateObject(""wscript.shell"")" & vbCrlf & "msgbox(""Kill bot"")" & vbCrlf & "call objShell.run(""taskkill /f /im wscript.exe"",,True)" & vbCrlf & "wscript.echo(""BEWARE: Bot was unsuccessfully killed"")")
objShell.run("""" & strDirectory & "\ionvop-exit.vbs""")
wscript.sleep(1000)
objFile.deletefile(strDirectory & "\ionvop-exit.vbs")
msgbox("Start")
wscript.sleep(3000)

if varFirst = 1 then
    strPrev = funcGetCommand(funcGetHTML(), "/ionvop ")
end if

do
    strCommand = funcGetCommand(funcGetHTML(), "/ionvop ")

    if not strCommand = strPrev then
        strPrev = strCommand

        if left(strCommand, 4) = "say " then
            objShell.sendkeys(funcGetParameters(strCommand, "say "))
            wscript.sleep(1000)
            objShell.sendkeys("~")
            wscript.sleep(100)
        elseif left(strCommand, 5) = "roll " then
            if instr(funcGetParameters(strCommand, "roll "), " ") then
                if isnumeric(left(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") - 1)) and isnumeric(mid(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") + 1))  then
                    objShell.sendkeys(funcRand(left(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") - 1), mid(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") + 1)))
                    wscript.sleep(1000)
                    objShell.sendkeys("~")
                    wscript.sleep(100)
                else
                    objShell.sendkeys("Invalid parameters")
                    wscript.sleep(500)
                    objShell.sendkeys("~")
                    wscript.sleep(100)
                end if
            else
                if isnumeric(funcGetParameters(strCommand, "roll ")) then
                    objShell.sendkeys(funcRand(0, funcGetParameters(strCommand, "roll ")))
                    wscript.sleep(1000)
                    objShell.sendkeys("~")
                    wscript.sleep(100)
                else
                    objShell.sendkeys("Invalid parameters")
                    wscript.sleep(500)
                    objShell.sendkeys("~")
                    wscript.sleep(100)
                end if
            end if
        elseif left(strCommand, 4) = "help" then
            objShell.sendkeys("Currently available commands:+~+~say <sentence>+~It will make the bot repeat the sentence+~+~roll <lowest number> <highest number>+~It will randomly choose a number between the two+~+~help+~Display this message")
            wscript.sleep(5000)
            objShell.sendkeys("~")
            wscript.sleep(100)
        elseif left(strCommand, 4) = "time" then
            objShell.sendkeys(now)
            wscript.sleep(1000)
            objShell.sendkeys("~")
            wscript.sleep(100)
        else
            objShell.sendkeys("Unknown command")
            wscript.sleep(1000)
            objShell.sendkeys("~")
            wscript.sleep(100)
        end if
    else
        wscript.sleep(1000)
    end if
loop