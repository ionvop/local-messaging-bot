# non-api-response-bot
Just some crap I made with VBScript to make my account function like a Discord bot without the use of API.\
It works on both Discord and Facebook, and might also work on other sites as well.\
What it does is instead of getting data through an API, it retrieves them directly from the HTML of the current page through the Inspect Element tool.

Because of VBScript's limitations, I had to use some very inefficient workarounds to make it work.\
*Like the utilization of* `wscript.sleep()` *to prevent the script from doing anything while a process is loading and hope that it finishes loading before the script does anything, or simulating keypresses just to navigate through the menu and get the desired data.*\
I'm sure there's a much better workaround than this.\
Because it heavily relies on delay, just a single bit of lag can break the whole process.

There are multiple variations of the script available.\
This is because Developer Tools work differently on different browsers, and some sites load much slower than others.\
The variation that is currently the first to be updated is `main-edge.vbs`

This is just a **personal project**.\
I only made this for shits and giggles.

## Script variations
### main-edge.vbs
- Copies the entire HTML of the current page.
- Compatible on most sites, requires longer delay on larger HTML.
- Works well on Discord, works absolutely shit on Facebook because of how much HTML it contains.

### main-edge-facebook
- A copy of `main-edge.vbs` but tuned specifically for Facebook to avoid breaking.
- Responses are extremely delayed.

### main-firefox
- The first variation I worked on.
- Only finds and copies the div element where a command is located.
- Much faster and requires lesser delay.
- Not compatible on some situations.
- Will not work on large text on Discord since Discord handles large texts differently causing inconsistency on the navigation which breaks the bot.
