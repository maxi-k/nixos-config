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

  # Syncing setup
  services.syncthing = {
   enable = true; 
   user = user.name;
   dataDir = user.homedir;
  };
  hm = { pkgs, ... }: {
    home.packages = with pkgs; [
      cryptomator
    ];
  };

}
