#!/usr/bin/env bash

picom -b -c & # compositor
nitrogen --restore & # wallpaper
systemctl --user start emacs
