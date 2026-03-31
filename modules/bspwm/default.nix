{ pkgs, ... }:

{
  imports = [
    ../xorg-desktop
  ];

  repo.eww.enable = true;

  services.xserver.windowManager.bspwm.enable = true;
  services.displayManager.defaultSession = "none+bspwm";

  environment.systemPackages = with pkgs; [
    bspwm
    sxhkd
    bsp-layout
    (polybar.override { pulseSupport = true; })
    ripgrep
    tabbed
  ];

  hm = { addHomeBinary, addHomeConfig, ... }: {
    home.file = {}
      // addHomeConfig "bspwm/bspwmrc" {
        source = ./bspwmrc;
        executable = true;
      }
      // addHomeConfig "sxhkd/sxhkdrc" {
        source = ./sxhkdrc;
      }
      // addHomeBinary "bspwm-choose-layout" {
        source = ./bin/bspwm-choose-layout;
        executable = true;
      }
      // addHomeBinary "bspwm-hide-window" {
        source = ./bin/bspwm-hide-window;
        executable = true;
      }
      // addHomeBinary "bspwm-get-proportionate-rectangle" {
        source = ./bin/bspwm-get-proportionate-rectangle;
        executable = true;
      }
      // addHomeBinary "bspwm-scratch-program" {
        source = ./bin/bspwm-scratch-program;
        executable = true;
      }
      // addHomeBinary "start-keybindings" {
        source = ./bin/start-keybindings;
        executable = true;
      }
      // addHomeBinary "list-keybindings" {
        source = ./bin/list-keybindings;
        executable = true;
      }
      // addHomeBinary "external-monitor" {
        source = ./bin/external-monitor;
        executable = true;
      }
      // addHomeBinary "tabc.sh" {
        source = ./bin/tabc.sh;
        executable = true;
      }
      // addHomeBinary "powermenu-gui" {
        source = ./bin/powermenu-gui;
        executable = true;
      }
      // addHomeConfig "polybar/config.ini" {
        source = ./polybar/config.ini;
      }
      // addHomeConfig "polybar/colors.conf" {
        source = ./polybar/colors.conf;
      }
      // addHomeConfig "polybar/modules.conf" {
        source = ./polybar/modules.conf;
      }
      // addHomeConfig "polybar/wm.conf" {
        source = ./polybar/wm.conf;
      }
      // addHomeConfig "polybar/bars.conf" {
        source = ./polybar/bars.conf;
      }
      // addHomeConfig "polybar/start.sh" {
        source = ./polybar/start.sh;
        executable = true;
      };
  };
}
