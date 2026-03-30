{ pkgs, ... }:

let
  xprofile = ./xprofile;
  mktheme = pkgs.writeShellScriptBin "mktheme" (builtins.readFile ./bin/mktheme);
  startThemedApps = pkgs.writeShellScriptBin "start-themed-apps" ''
    command -v dunst >/dev/null && (pgrep dunst >/dev/null || dunst) &
  '';
in
{
  services.xserver = {
    enable = true;
    xkb.layout = "us,de";
    xkb.variant = "";
    xkb.options = "caps:escape,escape:";
  };

  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  environment.systemPackages = with pkgs; [
    feh
    picom
    wmname
    xdotool
    scrot
    jq
    redshift
    xwininfo
    xrandr
    xrdb
    xinput
    xset
    xsetroot
    xkill
    xprop
    xdpyinfo
    unclutter
    pywal
    dunst
    libnotify
    pavucontrol
    sxiv
    devour
    xsecurelock
    mktheme
    startThemedApps
  ];

  hm = { addHomeFile, addHomeBinary, addHomeConfig, ... }: {
    home.file = {}
      // addHomeFile ".xprofile" {
        source = xprofile;
        executable = true;
      }
      // addHomeConfig "wal/postrun" {
        source = ./wal/postrun;
        executable = true;
      }
      // addHomeBinary "x-mac-layout" {
        source = ./bin/x-mac-layout;
        executable = true;
      }
      // addHomeBinary "x-cycle-layout" {
        source = ./bin/x-cycle-layout;
        executable = true;
      }
      // addHomeBinary "x-caps-is-escape" {
        source = ./bin/x-caps-is-escape;
        executable = true;
      }
      // addHomeBinary "x-switch-layout" {
        source = ./bin/x-switch-layout;
        executable = true;
      }
      // addHomeBinary "day-mode" {
        source = ./bin/day-mode;
        executable = true;
      }
      // addHomeBinary "night-mode" {
        source = ./bin/night-mode;
        executable = true;
      }
      // addHomeBinary "dopen" {
        source = ./bin/dopen;
        executable = true;
      }
      // addHomeBinary "lock" {
        source = ./bin/lock;
        executable = true;
      }
      // addHomeConfig "sxiv/exec/key-handler" {
        source = ./sxiv/key-handler;
        executable = true;
      };
  };
}
