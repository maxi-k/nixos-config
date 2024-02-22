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
     # picom (manually starting instead of using services.picom.enable)
     picom
] ++ (import ./desktop.nix ctx)
