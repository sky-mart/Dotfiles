#!/usr/bin/env bash

# See https://stackoverflow.com/a/246128/3561275
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

ln -sf "$DIR/emacs/init.el" ~/.emacs.d/

ln -sf "$DIR/scripts/blconnect.sh" ~/.local/bin/

ln -sf "$DIR"/.zshrc ~/.zshrc

# git clone https://github.com/nonpop/xkblayout-state.git
# cd xkblayout-state
# make
# sudo cp xkblayout-state /usr/bin/
# cd ..
# rm -r xkblayout-state

mkdir -p ~/.config/kitty
cp $DIR/kitty/* ~/.config/kitty

mkdir -p ~/.config/rofi
cp $DIR/rofi/* ~/.config/rofi

# sudo cp $DIR/qtile/qtile.desktop /usr/share/xsessions/
# mkdir ~/.config/qtile
# ln -sf $DIR/qtile/config.py ~/.config/qtile/config.py

# mkdir ~/.config/picom
# ln -sf $DIR/picom/picom.conf ~/.config/picom/picom.conf

# ln -sf $DIR/scripts/autosart.sh ~/.local/bin/autostart.sh
# ln -sf $DIR/scripts/shutdown.sh ~/.local/bin/shutdown.sh
