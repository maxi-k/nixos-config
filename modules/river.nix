{ config, lib, pkgs, ... }:

let
  riverSession = pkgs.writeTextDir "share/wayland-sessions/river.desktop" ''
    [Desktop Entry]
    Name=River
    Comment=Dynamic Wayland compositor
    Exec=/run/current-system/sw/bin/river
    Type=Application
  '';
  riverSessionPackage = riverSession.overrideAttrs (_: {
    passthru.providedSessions = [ "river" ];
  });
in {
  environment.systemPackages = [
    pkgs.river
    riverSessionPackage
  ];

  services.displayManager.sessionPackages = [
    riverSessionPackage
  ];
}
