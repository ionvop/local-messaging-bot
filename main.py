import pyautogui
import requests
import pyperclip
import time
import math


def main():
    targetUrl = "https://jsonblob.com/api/1202412654697504768"

    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
    }

    data = "Awaiting response..."
    time.sleep(3)
    print("Putting...")
    requests.put(targetUrl, headers=headers, data=data)

    while True:
        print("Getting...")

        while True:
            start_time = time.time()
            response = requests.get(targetUrl, headers=headers)
            response = response.text

            if response != "Awaiting response...":
                break

            time_taken = time.time() - start_time
            print("Ping: " + str(math.floor(time_taken * 1000)) + "ms")
            time.sleep(1)

        print("Received: " + response)
        time_taken = time.time() - start_time
        print("Ping: " + str(math.floor(time_taken * 1000)) + "ms")
        print("Pasting...")
        pyperclip.copy(response)
        pyautogui.hotkey("ctrl", "v")
        pyautogui.press("enter")
        data = "Awaiting response..."
        requests.put(targetUrl, headers=headers, data=data)


if __name__ == "__main__":
    main()