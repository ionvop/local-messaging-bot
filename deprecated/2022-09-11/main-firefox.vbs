set objShell = CreateObject("wscript.shell")
set objFile = CreateObject("Scripting.FileSystemObject")
set objHTML = CreateObject("htmlfile")
randomize

'sDebug()

strDirectory = objShell.CurrentDirectory
strPrev = ""
strCurt = ""
varFirst = 1
strCommand = ""

function funcMidString(fInput, fLeft, fRight)
    funcMidString = mid(fInput, instr(fInput, fLeft) + len(fLeft), instr(instr(fInput, fLeft), fInput, fRight) - (instr(fInput, fLeft) + len(fLeft)))
end function

function funcRand(fMin, fMax)
    funcRand = int((fMax-fMin+1)*rnd+fMin)
end function

function funcGetInput(fCommand)
    objShell.sendkeys("{F12}")
    wscript.sleep(1000)
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
    wscript.sleep(500)
    objShell.sendkeys("+~")
    wscript.sleep(500)
    
    for i = 1 to 3
        objShell.sendkeys("{TAB}")
        wscript.sleep(100)
    next

    wscript.sleep(1000)
    objShell.sendkeys("^c")
    wscript.sleep(1000)
    objShell.sendkeys("%{TAB}")
    wscript.sleep(1000)

    funcGetInput = objHTML.ParentWindow.ClipboardData.GetData("text")
end function

function funcGetCommand(fInput, fCommand)
    if instr(fInput, fCommand) then
        funcGetCommand = funcMidString(objHTML.ParentWindow.ClipboardData.GetData("text"), fCommand, "</div>")
    else
        funcGetCommand = false
    end if
end function

function funcGetParameters(fInput, fCommand)
    funcGetParameters = right(fInput, len(fInput)- len(fCommand))
end function

sub sDebug()
    msgbox("Start")
    wscript.sleep(3000)
    objShell.sendkeys("Currently available commands:+~+~/say <sentence>+~It will make the bot repeat the sentence+~+~/roll <lowest number> <highest number>+~It will randomly choose a number between the two")
    wscript.quit
end sub

'Countermeasures initialization
objFile.createtextfile(strDirectory & "\ionvop-exit.vbs", true).writeline("set objShell = CreateObject(""wscript.shell"")" & vbCrlf & "msgbox(""Kill bot"")" & vbCrlf & "call objShell.run(""taskkill /f /im wscript.exe"",,True)" & vbCrlf & "wscript.echo(""BEWARE: Bot was unsuccessfully killed"")")
objShell.run("""" & strDirectory & "\ionvop-exit.vbs""")
wscript.sleep(1000)
objFile.deletefile(strDirectory & "\ionvop-exit.vbs")

msgbox("Start")
wscript.sleep(3000)

if varFirst = 1 then
    strPrev = funcGetInput("/ionvop ")
end if

do
    strCurt = funcGetInput("/ionvop ")

    if not strCurt = strPrev then
        strPrev = strCurt
        strCommand = funcGetCommand(strCurt, "/ionvop ")

        if instr(strCommand,"say ") then
            objShell.sendkeys(funcGetParameters(strCommand, "say "))
            wscript.sleep(1000)
            objShell.sendkeys("~")
            wscript.sleep(100)
        elseif instr(strCommand,"roll ") then
            if instr(funcGetParameters(strCommand, "roll "), " ") then
                if isnumeric(left(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") - 1)) and isnumeric(mid(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") + 1))  then
                    objShell.sendkeys(funcRand(left(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") - 1), mid(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") + 1)))
                    wscript.sleep(500)
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
                    wscript.sleep(500)
                    objShell.sendkeys("~")
                    wscript.sleep(100)
                else
                    objShell.sendkeys("Invalid parameters")
                    wscript.sleep(500)
                    objShell.sendkeys("~")
                    wscript.sleep(100)
                end if
            end if
        elseif instr(strCommand,"help") then
            objShell.sendkeys("Currently available commands:+~+~say <sentence>+~It will make the bot repeat the sentence+~+~roll <lowest number> <highest number>+~It will randomly choose a number between the two+~+~help+~Display this message")
            wscript.sleep(5000)
            objShell.sendkeys("~")
            wscript.sleep(100)
        else
            objShell.sendkeys("Unknown command")
            wscript.sleep(1000)
            objShell.sendkeys("~")
            wscript.sleep(100)
        end if
    end if
loop
