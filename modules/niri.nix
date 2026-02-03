{ config, lib, pkgs, ... }:

{
  imports = [
    ./home-manager.nix
  ];

  programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    niri
    xwayland-satellite
    swaybg
  ];

  home-manager.users.maxi = { pkgs, inputs, ... }: {
    # import the home manager module
    imports = [
      inputs.noctalia.homeModules.default
    ];

    # enable the systemd service
    programs.noctalia-shell.systemd.enable = true;
  };
}
