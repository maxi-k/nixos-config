{ config, lib, pkgs, inputs, system, ... }:

let
  tigerwm_pkg = inputs.tigerwm.packages.${system}.default;
  tigerwm = tigerwm_pkg.overrideAttrs (_: {
    postInstall =
      let
        tigerwmSession = ''
          [Desktop Entry]
          Name=TigerWM
          Comment=Dynamic Wayland compositor
          Exec=${tigerwm_pkg}/bin/tigerstylewm
          Type=Application
        '';
      in
        ''
          mkdir -p $out/share/wayland-sessions
          echo "${tigerwmSession}" > $out/share/wayland-sessions/tigerwm.desktop
        '';
    passthru.providedSessions = [ "tigerwm" ];
    xwayland = true;
    configFile = ./config.zig;
    keybindingsFile = ./keybindings.zig;
  });
in
{
  nixpkgs.overlays = [
    # (final: prev: {
    #   tigerwm = inputs.tigerwm.packages.${system}.default.override {
    #     # configFile = ./tigerwm-config.zig;
    #     # keybindingsFile = ./tigerwm-keybindings.zig;
    #     xwayland = true;
    #   };
    # })
  ];

  environment.systemPackages = [
    tigerwm
  ];

  services.displayManager.sessionPackages = [
    tigerwm
  ];
}
