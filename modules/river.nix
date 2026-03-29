{ config, lib, pkgs, ... }:

let
  riverSession = ''
          [Desktop Entry]
          Name=River
          Comment=Dynamic Wayland compositor
          Exec=/run/xdg/river-session
          Type=Application
        '';
  river_install = 
    pkgs.river.overrideAttrs (_: {
      postInstall = ''
          mkdir -p $out/share/wayland-sessions
          echo "${riverSession}" > $out/share/wayland-sessions/river.desktop
        '';
      passthru.providedSessions = [ "river" ];
    });
in {
  environment.systemPackages = [
    river_install
  ];

  services.displayManager.sessionPackages = [
    river_install
  ];
}
