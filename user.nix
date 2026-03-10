{ config, lib, pkgs, inputs, user, ... }:

# User configuration shared between hosts
{
  imports = [];

  users.users.${user.name} = {
    isNormalUser = true;
    description = user.fullName;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
    # set some password for easier testing inside vms
    initialPassword = "test"; 
  };

  services.syncthing = {
   enable = true; 
   user = user.name;
   dataDir = user.homedir;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${user.name} = {pkgs, ...}: {
    home.homeDirectory = user.homedir;
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "25.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  };

}
