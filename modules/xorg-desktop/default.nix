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
  };
}
