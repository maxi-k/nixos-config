{ pkgs, ... }@ctx: with pkgs; [
     bspwm
     sxhkd
     bsp-layout
     rofi
     devour
     feh
     (polybar.override { pulseSupport = true; })
     eww
     dunst
     libnotify
     pavucontrol
     pywal
     wmname
     ripgrep
     xdotool
     scrot
     jq
     redshift
     tabbed
     xorg.xwininfo
     # picom (manually starting instead of using services.picom.enable)
     picom
     i3lock-fancy-rapid
] ++ (import ./desktop.nix ctx)
