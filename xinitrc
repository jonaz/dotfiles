#!/bin/sh
## TODO remove this file? not beeing used anymore?
#
# ~/.xinitrc
# 
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

#fix mouse
xset m 1/1 0
#start-pulseaudio-x11
export TERMINAL=alacritty
exec i3

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
