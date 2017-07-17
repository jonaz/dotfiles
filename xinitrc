#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# IF USING lightdm copy this file to .xprofile and remove exec line

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

#xrandr --output HDMI3 --auto --primary --output VGA1 --auto --right-of HDMI3 --output LVDS1 --off
#~/jonaz-dotfiles/setupscreen.php 3

#fix mouse
xset m 1/1 0
#start-pulseaudio-x11
exec i3

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
