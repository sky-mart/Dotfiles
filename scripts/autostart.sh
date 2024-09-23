#!/usr/bin/env bash

picom -b -c & # compositor
nitrogen --restore & # wallpaper

# lock screen
xset s 300 5
xss-lock -n /usr/lib/xsecurelock/dimmer -l xsecurelock &

systemctl --user start emacs

dunst &

bluetoothctl connect 00:42:79:B7:C9:8D # JBL

playerctld daemon
