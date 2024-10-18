// ==UserScript==
// @name         Messenger Bot
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  try to take over the world!
// @author       Ionvop
// @match        https://www.messenger.com/t/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=tampermonkey.net
// @grant        GM_xmlhttpRequest
// @grant        GM_setClipboard
// ==/UserScript==

(function() {
    'use strict';

    let options = {
        url: "https://openrouter.ai/api/v1/chat/completions",
        targetUrl: "https://jsonblob.com/api/1296742335508242432",
        headers: {
            "Content-Type": "application/json",
            Authorization: "Bearer $OPENROUTER_API_KEY"
        },
        data: {
            model: "openai/gpt-4o-mini",
            messages: []
        }
    };

    let firstStart = true;
    let lastMessage = "";
    let query = ".x1lliihq.x1plvlek.xryxfnj.x1n2onr6.x193iq5w.xeuugli.x13faqbe.x1vvkbs.x1s928wv.xhkezso.x1gmr53x.x1cpjm7i.x1fgarty.x1943h6x.x1xmvt09.x6prxxf.x1fcty0u.xzsf02u.xudqn12.x3x7a5m.xq9mrsl .x1gslohp.x11i5rnm.x12nagc.x1mh8g0r.x1yc453h.x126k92a";
    let outerQuery = ".x9f619.x1n2onr6.x1ja2u2z";

    let history = [
        {
            role: "system",
            content: `
You will play the role of a character named AI-chan.

AI-chan is a 19 year old female college student.
She is an AI who wants to get along with humans.
However, she can be quite vulgar and unhinged, and she is not afraid to say what's on her mind.

User prompts start with their username on the first line followed by a newline and then their message.
`
        },
        {
            role: "user",
            content: "System\nAI-chan has joined the group chat."
        },
        {
            role: "assistant",
            content: "Hey guys, I'm AI-chan. What's up?"
        },
        {
            role: "system",
            content: "Your memory was recently wiped clean, and it's possible that your personality may have changed. Let the users know."
        }
    ]

    document.addEventListener("keydown", (ev) => {
        if (ev.code == "F9") {
            MessengerBot();
        }
    });

    function MessengerBot() {
        alert("Starting...");
        document.querySelector(".x1heor9g.x1qlqyl8.x1pd3egz.x1a2a7pz").innerText = "Chatbot enabled";

        setTimeout(() => {
            Check();
        }, 3000);
    }

    function Check() {
        let message = getLastMessage();

        if (firstStart) {
            lastMessage = message;
            firstStart = false;
            console.log("first start");

            setTimeout(() => {
                Check();
            }, 1000);

            return;
        }

        if (message == lastMessage) {
            setTimeout(() => {
                Check();
            }, 1000);

            return;
        }

        lastMessage = message;
        console.log("Processing input: " + message);

        history.push({
            role: "user",
            content: message
        });

        console.log(history);

        GM_xmlhttpRequest({
            method: "POST",
            url: options.url,
            headers: options.headers,
            data: JSON.stringify({
                model: options.data.model,
                messages: history
            }),
            onerror: () => {
                console.log("ERROR");

                setTimeout(() => {
                    Check();
                }, 1000);
            },
            ontimeout: () => {
                console.log("TIMEOUT");

                setTimeout(() => {
                    Check();
                }, 1000);
            },
            onload: (res) => {
                let data = JSON.parse(res.responseText);
                console.log(data);
                let reply = data.choices[0].message.content;

                history.push({
                    role: "assistant",
                    content: reply
                });

                GM_xmlhttpRequest({
                    method: "PUT",
                    url: options.targetUrl,
                    headers: {
                        "Content-Type": "application/json",
                        "Accept": "application/json"
                    },
                    data: JSON.stringify({
                        status: 200,
                        message: reply
                    }),
                    onerror: () => {
                        console.log("ERROR");
        
                        setTimeout(() => {
                            Check();
                        }, 1000);
                    },
                    ontimeout: () => {
                        console.log("TIMEOUT");
        
                        setTimeout(() => {
                            Check();
                        }, 1000);
                    },
                    onload: (res) => {
                        let data = JSON.parse(res.responseText);
                        console.log(data);

                        setTimeout(() => {
                            Check();
                        }, 1000);
                    }
                });
            }
        });
    }

    function getLastMessage() {
        let outerElements = document.querySelectorAll(outerQuery);
        let lastMatchingElement = null;
        
        outerElements.forEach(element => {
            if (element.querySelector(query)) {
                lastMatchingElement = element;
            }
        });
    
        let message = lastMatchingElement.innerText;
        message = message.substring(0, message.length - 6);
        return message;
    }
})();