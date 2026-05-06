#!/usr/bin/env sh


dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots \
    && systemctl --user start xdg-desktop-portal xdg-desktop-portal-wlr

pgrep dunst || ( dunst & )

waybar -c ~/.config/mango/waybar.conf -s ~/.config/mango/waybar.css &

awww-daemon &

mktheme &

xwayland-satellite :12 &

swayidle -w timeout 300 'swaylock -d' &
