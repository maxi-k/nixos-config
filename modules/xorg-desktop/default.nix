{ pkgs, user, ... }:

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

  hm = {
    home.file.".xprofile" = {
      source = xprofile;
      executable = true;
    };
    home.file.".config/wal/postrun" = {
      source = ./wal/postrun;
      executable = true;
    };
    home.file.".local/bin/x-mac-layout" = {
      source = ./bin/x-mac-layout;
      executable = true;
    };
    home.file.".local/bin/x-cycle-layout" = {
      source = ./bin/x-cycle-layout;
      executable = true;
    };
    home.file.".local/bin/x-caps-is-escape" = {
      source = ./bin/x-caps-is-escape;
      executable = true;
    };
    home.file.".local/bin/x-switch-layout" = {
      source = ./bin/x-switch-layout;
      executable = true;
    };
    home.file.".local/bin/day-mode" = {
      source = ./bin/day-mode;
      executable = true;
    };
    home.file.".local/bin/night-mode" = {
      source = ./bin/night-mode;
      executable = true;
    };
    home.file.".local/bin/dopen" = {
      source = ./bin/dopen;
      executable = true;
    };
    home.file.".local/bin/lock" = {
      source = ./bin/lock;
      executable = true;
    };
  };
}
