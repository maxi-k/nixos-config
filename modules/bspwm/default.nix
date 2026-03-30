{ pkgs, ... }:

{
  imports = [
    ../xorg-desktop
  ];

  services.xserver.windowManager.bspwm.enable = true;
  services.displayManager.defaultSession = "none+bspwm";

  environment.systemPackages = with pkgs; [
    bspwm
    sxhkd
    bsp-layout
    rofi
    devour
    (polybar.override { pulseSupport = true; })
    xsecurelock
    eww
    ripgrep
    tabbed
  ];

  hm = {
    home.file = {
      ".config/bspwm/bspwmrc" = {
        source = ./bspwmrc;
        executable = true;
      };
      ".config/sxhkd/sxhkdrc".source = ./sxhkdrc;
      ".local/bin/bspwm-choose-layout" = {
        source = ./bin/bspwm-choose-layout;
        executable = true;
      };
      ".local/bin/bspwm-hide-window" = {
        source = ./bin/bspwm-hide-window;
        executable = true;
      };
      ".local/bin/bspwm-get-proportionate-rectangle" = {
        source = ./bin/bspwm-get-proportionate-rectangle;
        executable = true;
      };
      ".local/bin/bspwm-scratch-program" = {
        source = ./bin/bspwm-scratch-program;
        executable = true;
      };
    };
  };
}
