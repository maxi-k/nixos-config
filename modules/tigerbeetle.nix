{ config, lib, pkgs, ... }:

{
  system.autoUpgrade.enable = true;
  environment.systemPackages = with pkgs; [
    # _1password-gui
    zoom-us
  ];
}
