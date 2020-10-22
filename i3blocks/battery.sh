#!/usr/bin/env python3
#
# Copyright (C) 2016 James Murphy
# Licensed under the GPL version 2 only
#
# A battery indicator blocklet script for i3blocks

import re
from subprocess import check_output

status = check_output(['acpi'], universal_newlines=True)

if not status:
    # stands for no battery found
    fulltext = "<span color='red'><span font='Font Awesome 5 Free,Font Awesome 5 Free Regular'>\uf00d \uf240</span></span>"
    percentleft = 100
else:
    # if there is more than one battery in one laptop, the percentage left is 
    # available for each battery separately, although state and remaining 
    # time for overall block is shown in the status of the first battery 
    batteries = status.split("\n")
    state_batteries=[]
    commasplitstatus_batteries=[]
    percentleft_batteries=[]
    time = ""
    for battery in batteries:
        if battery!='':
            state_batteries.append(battery.split(": ")[1].split(", ")[0])
            commasplitstatus = battery.split(", ")
            if not time:
                time = commasplitstatus[-1].strip()
                # check if it matches a time
                time = re.match(r"(\d+):(\d+)", time)
                if time:
                    time = ":".join(time.groups())
                    timeleft = " ({})".format(time)
                else:
                    timeleft = ""

            p = int(commasplitstatus[1].rstrip("%\n"))
            if p>0:
                percentleft_batteries.append(p)
            commasplitstatus_batteries.append(commasplitstatus)
    state = state_batteries[0]
    commasplitstatus = commasplitstatus_batteries[0]
    if percentleft_batteries:
        percentleft = int(sum(percentleft_batteries)/len(percentleft_batteries))
    else:
        percentleft = 0

    # stands for charging
    FA_LIGHTNING = "<span font='Font Awesome 5 Free,Font Awesome 5 Free Regular'>\uf0e7</span>"

    # stands for plugged in
    FA_PLUG = "<span font='Font Awesome 5 Free,Font Awesome 5 Free Regular'>\uf1e6</span>"

    # stands for using battery
    FA_BATTERY = "<span font='Font Awesome 5 Free,Font Awesome 5 Free Regular'>\uf240</span>"

    # stands for unknown status of battery
    FA_QUESTION = "<span font='Font Awesome 5 Free,Font Awesome 5 Free Regular'>\uf128</span>"


    if state == "Discharging":
        fulltext = " " + FA_BATTERY + " "
    elif state == "Full":
        fulltext = FA_PLUG + " "
        timeleft = ""
    elif state == "Unknown":
        fulltext = FA_QUESTION + " " + FA_BATTERY + " "
        timeleft = ""
    else:
        fulltext = FA_LIGHTNING + " " + FA_PLUG + " "

    def color(percent):
        if percent < 10:
            # exit code 33 will turn background red
            return "#282a36"
        if percent < 20:
            return "#282a36"
        if percent < 30:
            return "#282a36"
        if percent < 40:
            return "#282a36"
        if percent < 50:
            return "#282a36"
        if percent < 60:
            return "#282a36"
        if percent < 70:
            return "#282a36"
        if percent < 80:
            return "#282a36"
        return "#282a36"

    form =  ' <span color="{}">{}%</span> '
    fulltext += form.format(color(percentleft), percentleft)
    fulltext += timeleft

print(fulltext)
print(fulltext)
if percentleft < 10:
    exit(33)

