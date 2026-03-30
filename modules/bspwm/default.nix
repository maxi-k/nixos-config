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
      ".config/polybar/config.ini".source = ./polybar/config.ini;
      ".config/polybar/colors.conf".source = ./polybar/colors.conf;
      ".config/polybar/modules.conf".source = ./polybar/modules.conf;
      ".config/polybar/wm.conf".source = ./polybar/wm.conf;
      ".config/polybar/bars.conf".source = ./polybar/bars.conf;
      ".config/polybar/start.sh" = {
        source = ./polybar/start.sh;
        executable = true;
      };
    };
  };
}
