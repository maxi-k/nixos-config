{ config, pkgs, ... }@ctx:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/laptop.nix
    ../../modules/bspwm
    ../../modules/development.nix
    ../../modules/tigerwm
    # ../../modules/river.nix
  ];

  networking.hostName = "luna"; # Define your hostname.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  repo.terminal.fontSize = 16.0;
  repo.tigerwm.waybar.position = "top";

  services.desktopManager.gnome.enable = true;
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [ ];
  
  # when enabling multiple desktop environments
  # (e.g. plasma & gnome), need to specify this
  # explicitly
  # see https://github.com/NixOS/nixpkgs/issues/75867
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

  hardware = {  
     enableAllFirmware = true;
  }; 
  # enable firmware update for `fwupdmgr update`
  services.fwupd.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
