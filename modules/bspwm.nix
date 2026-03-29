{ config, lib, pkgs, ... }:

{
  imports = [ ./desktop.nix ];

  # Enable BSPWM and set as default
  services.xserver.windowManager.bspwm.enable = true;
  services.displayManager.defaultSession = "none+bspwm";

  environment.systemPackages = with pkgs; [
     bspwm
     sxhkd
     bsp-layout
     rofi
     devour
     feh
     (polybar.override { pulseSupport = true; })
     xsecurelock
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
     xwininfo
     # picom (manually starting instead of using services.picom.enable)
     picom
  ];
}
