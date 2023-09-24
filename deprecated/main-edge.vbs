set objShell = CreateObject("wscript.shell")
set objFile = CreateObject("Scripting.FileSystemObject")
set objHTML = CreateObject("htmlfile")
set objHTTP = CreateObject("MSXML2.XMLHTTP")
randomize

'sDebug()

dim arrNhentaiInfo(4)
strDirectory = objShell.CurrentDirectory
strPrev = ""
varFirst = 1
strHTML = ""
strCommand = ""
strData = ""
varNhentaiLatest = 0

function funcMidString(fInput, fLeft, fRight)
    'if instr(fInput, fLeft) and instr(fInput, fRight) then
        funcMidString = mid(fInput, instr(fInput, fLeft) + len(fLeft), instr(instr(fInput, fLeft), fInput, fRight) - (instr(fInput, fLeft) + len(fLeft)))
    'else
    '    funcMidString = false
    'end if
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
    wscript.sleep(500)
    objShell.sendkeys("^a")
    wscript.sleep(500)
    objShell.sendkeys("^c")
    wscript.sleep(500)
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

function funcNhentaiGetLatest()
    objHTTP.open "GET", "https://nhentai.net", false
    objHTTP.send
    strData = objHTTP.responsetext
    funcNhentaiGetLatest = funcMidString(funcMidString(strData, "</i> New Uploads</h2>", "cover"" style="), "href=""/g/", "/"" c")
end function

sub sNhentaiGetInfo(fCode)
    '0 = Name
    '1 = Artist
    '2 = Tags
    '3 = Language
    '4 = Code

    objHTTP.open "GET", "https://nhentai.net/g/" & fCode, false
    objHTTP.send
    strData = objHTTP.responsetext
    objFile.createtextfile(strDirectory & "\htmldata.txt", true, true).writeline(strData)
    arrNhentaiInfo(0) = funcMidString(strData, "<meta itemprop=""name"" content=""", """ />")
    arrNhentaiInfo(1) = funcMidString(strData, "<span class=""tags""><a href=""/artist/", "/"" class=")
    arrNhentaiInfo(2) = funcMidString(strData, "<meta name=""twitter:description"" content=""", """ />")
    arrNhentaiInfo(3) = funcMidString(strData, "</span></a><a href=""/language/", "/"" class=")
    arrNhentaiInfo(4) = fCode
end sub

sub sDebug()
    objHTTP.open "GET", "https://nhentai.net/g/177013", false
    wscript.echo("Debug start")
    objHTTP.send
    strData = objHTTP.responsetext
    wscript.echo(left(strData, 100))
    objFile.createtextfile(strDirectory & "\htmldata.txt", true, true).writeline(strData)
    'wscript.echo(funcMidString(strData, "<meta itemprop=""name"" content=""", """ />"))
    'wscript.echo(funcMidString(strData, "<meta name=""twitter:description"" content=""", """ />"))
    'wscript.echo(funcMidString(strData, "<span class=""tags""><a href=""/artist/", "/"" class="))
    'wscript.echo(funcMidString(strData, "</i> New Uploads</h2>", "cover"" style="))
    'wscript.echo(funcMidString(funcMidString(strData, "</i> New Uploads</h2>", "cover"" style="), "href=""/g/", "/"" c"))
    'wscript.echo(funcMidString(strData, "</span></a><a href=""/language/", "/"" class="))
    wscript.echo("Done")
    wscript.quit
end sub

'sDebug()

objFile.createtextfile(strDirectory & "\ionvop-exit.vbs", true).writeline("set objShell = CreateObject(""wscript.shell"")" & vbCrlf & "msgbox(""Kill bot"")" & vbCrlf & "call objShell.run(""taskkill /f /im wscript.exe"",,True)" & vbCrlf & "wscript.echo(""BEWARE: Bot was unsuccessfully killed"")")
objShell.run("""" & strDirectory & "\ionvop-exit.vbs""")
wscript.sleep(1000)
objFile.deletefile(strDirectory & "\ionvop-exit.vbs")
msgbox("Start0")
wscript.sleep(3000)

if varFirst = 1 then
    strPrev = funcGetCommand(funcGetHTML(), "/ionvop ")
end if

varNhentaiLatest = funcNhentaiGetLatest()

do
    strCommand = funcGetCommand(funcGetHTML(), "/ionvop ")

    if not strCommand = strPrev then
        strPrev = strCommand

        if left(strCommand, 4) = "say " then
            objShell.sendkeys(funcGetParameters(strCommand, "say "))
            wscript.sleep(1000)
            objShell.sendkeys("~")
            wscript.sleep(1000)
        elseif left(strCommand, 5) = "roll " then
            if instr(funcGetParameters(strCommand, "roll "), " ") then
                if isnumeric(left(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") - 1)) and isnumeric(mid(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") + 1))  then
                    objShell.sendkeys(funcRand(left(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") - 1), mid(funcGetParameters(strCommand, "roll "), instr(funcGetParameters(strCommand, "roll "), " ") + 1)))
                    wscript.sleep(1000)
                    objShell.sendkeys("~")
                    wscript.sleep(1000)
                else
                    objShell.sendkeys("Invalid parameters")
                    wscript.sleep(500)
                    objShell.sendkeys("~")
                    wscript.sleep(1000)
                end if
            else
                if isnumeric(funcGetParameters(strCommand, "roll ")) then
                    objShell.sendkeys(funcRand(0, funcGetParameters(strCommand, "roll ")))
                    wscript.sleep(1000)
                    objShell.sendkeys("~")
                    wscript.sleep(1000)
                else
                    objShell.sendkeys("Invalid parameters")
                    wscript.sleep(500)
                    objShell.sendkeys("~")
                    wscript.sleep(1000)
                end if
            end if
        elseif left(strCommand, 4) = "help" then
            objShell.sendkeys("Currently available commands:+~+~say <sentence>+~It will make the bot repeat the sentence+~+~roll <lowest number> <highest number>+~It will randomly choose a number between the two+~+~help+~Display this message+~+~ time+~Check the current time and date+~+~sauce <code>+~Check the info of the nhentai code")
            wscript.sleep(10000)
            objShell.sendkeys("~")
            wscript.sleep(1000)
        elseif left(strCommand, 4) = "time" then
            objShell.sendkeys(now)
            wscript.sleep(1000)
            objShell.sendkeys("~")
            wscript.sleep(1000)
        elseif left(strCommand, 5) = "sauce" then
            if strCommand = "sauce" then
                sNhentaiGetInfo(funcRand(1, varNhentaiLatest))
                objShell.sendkeys(arrNhentaiInfo(0) & " by " & arrNhentaiInfo(1) & "+~Tags: " & arrNhentaiInfo(2) & "+~Language: " & arrNhentaiInfo(3) & "+~Code: " & arrNhentaiInfo(4))
                wscript.sleep(10000)
                objShell.sendkeys("~")
                wscript.sleep(5000)
            elseif isnumeric(funcGetParameters(strCommand, "sauce ")) then
                if funcGetParameters(strCommand, "sauce ") > varNhentaiLatest or funcGetParameters(strCommand, "sauce ") < 1 then
                    objShell.sendkeys("Invalid parameters")
                    wscript.sleep(500)
                    objShell.sendkeys("~")
                    wscript.sleep(1000)
                else
                    sNhentaiGetInfo(int(funcGetParameters(strCommand, "sauce ")))
                    objShell.sendkeys(arrNhentaiInfo(0) & " by " & arrNhentaiInfo(1) & "+~Tags: " & arrNhentaiInfo(2) & "+~Language: " & arrNhentaiInfo(3) & "+~Code: " & arrNhentaiInfo(4))
                    wscript.sleep(20000)
                    objShell.sendkeys("~")
                    wscript.sleep(1000)
                end if
            else
                objShell.sendkeys("Invalid parameters")
                    wscript.sleep(500)
                    objShell.sendkeys("~")
                    wscript.sleep(1000)
            end if
        elseif left(strCommand, 6) = "resync" then
            wscript.sleep(1000)
        else
            objShell.sendkeys("Unknown command")
            wscript.sleep(1000)
            objShell.sendkeys("~")
            wscript.sleep(1000)
        end if
    else
        wscript.sleep(1000)
    end if
loop
