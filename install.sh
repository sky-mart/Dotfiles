#!/usr/bin/env bash

# See https://stackoverflow.com/a/246128/3561275
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

mkdir ~/.config/kitty
cp $DIR/kitty/* ~/.config/kitty

mkdir ~/.config/rofi
cp $DIR/rofi/* ~/.config/rofi

mkdir ~/.config/qtile
ln -s $DIR/qtile/config.py ~/.config/qtile/config.py

mkdir ~/.config/picom
ln -s $DIR/picom/picom.conf ~/.config/picom/picom.conf
