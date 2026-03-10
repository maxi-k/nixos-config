{ config, lib, pkgs, inputs, ... }:

# User configuration shared between hosts
{
  imports = [];

  users.users.maxi = {
    isNormalUser = true;
    description = "Maximilian Kuschewski";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
    # set some password for easier testing inside vms
    initialPassword = "test"; 
  };

  services.syncthing = {
   enable = true; 
   user = "maxi";
   dataDir = "/home/maxi";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.maxi = {pkgs, ...}: {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "25.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  };

}
