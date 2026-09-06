#!/usr/bin/python3
"""
Sophos captive-portal login/logout script for wifi.codelif.in

Credentials are read from ~/.config/wifi.env (KEY=VALUE lines,
# comments allowed):

    WIFI_USER=your_username
    WIFI_PASS=your_password

Usage:
    python3 wifi.py               # log in
    python3 wifi.py logout        # log out
"""

import os
import sys
import time
import html
import shutil
import subprocess
import requests
from io import BytesIO
import xml.etree.ElementTree as ET

WIFI_ENV_FILE = os.path.expanduser("~/.config/wifi.env")


def load_credentials():
    creds = {}
    env_path = os.path.expanduser("~/.config/wifi.env")
    if os.path.isfile(env_path):
        with open(env_path) as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#") or "=" not in line:
                    continue
                key, _, value = line.partition("=")
                creds[key.strip()] = value.strip()
    for key in ("WIFI_USER", "WIFI_PASS"):
        if key in os.environ:
            creds[key] = os.environ[key]
    return creds


class Sophos:
    def __init__(self):
        self.GATEWAY = "http://172.16.68.6:8090/"
        self.LOGIN_LINK = "login.xml"
        self.LOGOUT_LINK = "logout.xml"

    def __get_milliepoch(self) -> str:
        return str(int(time.time() * 100))

    def login(self, user: str, pswd: str) -> str:
        link = self.GATEWAY + self.LOGIN_LINK
        data = {
            "mode": "191",
            "username": user,
            "password": pswd,
            "a": self.__get_milliepoch(),
            "producttype": "0",
        }
        resp = requests.post(link, data=data, timeout=10)
        return self.get_message(resp.content).format(username=user)

    def logout(self, user: str) -> str:
        link = self.GATEWAY + self.LOGOUT_LINK
        data = {
            "mode": "193",
            "username": user,
            "a": self.__get_milliepoch(),
            "producttype": "0",
        }
        resp = requests.post(link, data=data, timeout=10)
        return self.get_message(resp.content)

    def get_message(self, response: bytes) -> str:
        f = BytesIO(response)
        tree = ET.parse(f)
        root = tree.getroot()
        return html.unescape(root.find("./message").text)


def notify(message: str) -> None:
    """Send a desktop notification if notify-send is available, else just print."""
    if shutil.which("notify-send"):
        try:
            subprocess.run(["notify-send", message], check=False)
        except Exception:
            pass


if __name__ == "__main__":
    creds = load_credentials()
    USER = creds.get("WIFI_USER")
    PSWD = creds.get("WIFI_PASS")

    if not USER or not PSWD:
        print("Missing Wi-Fi credentials.")
        print(f"Create {WIFI_ENV_FILE} with WIFI_USER=... and WIFI_PASS=... "
              "(or export them as environment variables).")
        sys.exit(1)

    s = Sophos()
    try:
        if len(sys.argv) > 1 and "logout".startswith(sys.argv[1]):
            print("Logging out... ", end="")
            ret_msg = s.logout(USER)
        else:
            print("Logging in... ", end="")
            ret_msg = s.login(USER, PSWD)
        print("done")
        print(ret_msg)
        notify(ret_msg)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)