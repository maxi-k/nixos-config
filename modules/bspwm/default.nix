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
    (polybar.override { pulseSupport = true; })
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
      ".local/bin/start-keybindings" = {
        source = ./bin/start-keybindings;
        executable = true;
      };
      ".local/bin/list-keybindings" = {
        source = ./bin/list-keybindings;
        executable = true;
      };
      ".local/bin/external-monitor" = {
        source = ./bin/external-monitor;
        executable = true;
      };
      ".local/bin/tabc.sh" = {
        source = ./bin/tabc.sh;
        executable = true;
      };
      ".local/bin/powermenu-gui" = {
        source = ./bin/powermenu-gui;
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
