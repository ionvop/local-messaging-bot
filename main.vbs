option explicit
dim objShell, objFile, objHttp
set objShell = CreateObject("wscript.shell")
set objFile = CreateObject("Scripting.FileSystemObject")
set objHttp = CreateObject("MSXML2.XMLHTTP.6.0")
dim directory
directory = objFile.GetParentFolderName(wscript.ScriptFullName)

sub Main()
    dim i, headers, res, reply
    objShell.Run("""" & directory & "\stop.vbs""")
    msgbox("Start")
    wscript.Sleep(3000)
    set headers = CreateObject("Scripting.Dictionary")
    headers.Add "Content-Type", "application/json"
    headers.Add "Accept", "application/json"
    headers.Add "Cache-Control", "no-cache"

    do
        res = Curl("https://jsonblob.com/api/1155196492201189376", "PUT", headers, "awaiting request")
        wscript.Sleep(4000)

        for i = 1 to 999
            res = Curl("https://jsonblob.com/api/1155196492201189376?i=" & mid(Rnd, 3), "GET", headers, "")

            if res <> "awaiting request" then
                exit for
            end if

            wscript.Sleep(4000)
        next

        reply = res
        reply = replace(reply, "{{char}}", "Ai-chan")
        reply = replace(reply, "{{user}}}", "the user")
        reply = replace(reply, "{", "")
        reply = replace(reply, "}", "")
        reply = replace(reply, "~", "{~}")
        reply = replace(reply, "!", "{!}")
        reply = replace(reply, "^", "{^}")
        reply = replace(reply, "+", "{+}")
        reply = replace(reply, "%", "{%}")
        objShell.SendKeys reply
        wscript.Sleep(1000)
        objShell.SendKeys "~"
        wscript.Sleep(500)
    loop
end sub

function Curl(url, method, headers, data)
    dim element, headerKeys
    set objHttp = CreateObject("MSXML2.XMLHTTP.6.0")
    objHttp.Open method, url, false
    
    for each element in headers.Keys()
        objHttp.SetRequestHeader element, headers.Item(element)
    next

    objHttp.Send(data)
    Curl = objHttp.ResponseText
end function

sub Breakpoint(message)
    wscript.Echo(message)
    wscript.Quit
end sub

Main()