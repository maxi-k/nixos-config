{ config, pkgs, lib, user, ... }:
{
  isoImage.volumeID = lib.mkForce "id-live";
  isoImage.isoName = lib.mkForce "id-live.iso";

  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-base.nix>
  ];

  networking.hostName = "live-usb";
  networking.networkmanager.enable = true; # nmcli for wi-fi
  networking.wireless.enable = lib.mkForce false;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  services.xserver = {
    displayManager = {
      autoLogin = { enable = true; user = user.name; };
    };
    #videoDrivers = [ "nvidia" "amdgpu" "vesa" "modesetting" ];
    videoDrivers = [ "amdgpu" "vesa" "modesetting" ];
  };

}
