{ config, lib, pkgs, inputs, system, ... }:

let
  tigerwm_pkg = inputs.tigerwm.packages.${system}.default.override {
    configFile = ./config.zig;
    keybindingsFile = ./keybindings.zig;
    xwayland = true;
  };
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

  environment.systemPackages = [tigerwm] ++ (with pkgs; [
    waybar
    rofi
    swaylock
  ]);

  services.displayManager.sessionPackages = [
    tigerwm
  ];
}
