# non-api-response-bot
Just some crap I made with VBScript to make my account function like a Discord bot without the use of API.\
It also works on other sites like Facebook.\
Instead of getting inputs through an API, it retrieves them directly from the HTML of the current page through the Inspect Element tool.

Because of VBScript's limitations, I had to use some very inefficient workarounds to make it work.\
*Like the utilization of* `wscript.sleep()` *to prevent the script from doing anything while a process is loading and hope that it finishes loading before the script does anything.*\
This is a workaround for waiting until the desired process is detected, but I'm sure there's a much better workaround than this.

This is just a **personal project**, I only made this for shits and giggles.
