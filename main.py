import pyautogui
import requests
import pyperclip
import time
import math
import json


def main():
    targetUrl = "https://jsonblob.com/api/1296742335508242432"

    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
    }

    data = {
        "status": 204,
        "message": "Awaiting response..."
    }

    data = json.dumps(data)
    time.sleep(3)
    print("Putting...")
    requests.put(targetUrl, headers=headers, data=data)

    while True:
        print("Getting...")

        while True:
            try:
                start_time = time.time()
                response = requests.get(targetUrl, headers=headers)
                response = response.json()

                if response["status"] == 200:
                    break

                time_taken = time.time() - start_time
                print("Ping: " + str(math.floor(time_taken * 1000)) + "ms")
                time.sleep(4)
            except:
                print("Failed to get response")
                time.sleep(4)

        response = response["message"]
        print("Received: " + response)
        time_taken = time.time() - start_time
        print("Ping: " + str(math.floor(time_taken * 1000)) + "ms")
        print("Pasting...")
        pyperclip.copy("AI-chan: " + response)
        pyautogui.hotkey("ctrl", "v")
        pyautogui.press("enter")

        data = {
            "status": 204,
            "message": "Awaiting response..."
        }

        data = json.dumps(data)
        requests.put(targetUrl, headers=headers, data=data)


if __name__ == "__main__":
    main()