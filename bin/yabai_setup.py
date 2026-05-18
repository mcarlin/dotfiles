#!/usr/bin/env python3

import sh
import json

y = sh.Command("yabai")
yq = y.bake("-m", "query")


home_monitors = [
    {
        "uuid": "37D8832A-2D66-02CA-B9F7-8F30A301B230",
        "name": "macbook",
        "position": "center",
    },
    {
        "uuid": "40D5AA7D-69FE-40EA-80EE-6BC5DC1B5843",
        "name": "dell ultrawide",
        "position": "center",
    },
    {
        "uuid": "759267AF-1A0F-4CE9-B5F7-A9F1D543AB98",
        "name": "lg 27 1080",
        "position": "right",
    },
    {
        "uuid": "D3DF856C-5E62-4007-98E4-407C03EF296B",
        "name": "lg 27 4k",
        "position": "left",
    },
]

home_setup = [
    {"application": "Goland", "position": "center"},
    {"application": "Goland-EAP", "position": "center"},
    {"application": "kitty", "position": "center"},
    {"application": "Slack", "position": "left"},
    {"application": "Microsoft Teams", "position": "left"},
    {"application": "Microsoft Outlook", "position": "left"},
    {"application": "Obsidian", "position": "bottom"},
    {"application": "Firefox", "position": "bottom"},
    {"application": "Firefox", "position": "right"},
]

current_displays = json.loads(yq("--displays"))
print(current_displays)
