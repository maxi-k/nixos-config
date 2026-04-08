{ config, pkgs, lib, ... }@ctx:

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
  repo.desktop.displayManager = "ly";
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

  # fingerprint auth
  services.fprintd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.gnome-keyring.fprintAuth = true;
  ## based on arch wiki
  # security.pam.services.ly-fingerprint = lib.mkIf (config.services.fprintd.enable && config.services.displayManager.ly.enable) {
  #   text = ''
  # auth		sufficient  	pam_unix.so try_first_pass likeauth nullok
  # auth		sufficient  	${pkgs.fprintd}/lib/security/pam_fprintd.so
  # '';
  # };
  ## based on nixos wiki
  # security.pam.services.pam-fingerprint.text = ''
  #   auth       required                    pam_shells.so
  #   auth       requisite                   pam_nologin.so
  #   auth       requisite                   pam_faillock.so      preauth
  #   auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
  #   auth       optional                    pam_permit.so
  #   auth       required                    pam_env.so
  #   # auth       [success=ok default=1]      ${pkgs.gdm}/lib/security/pam_gdm.so
  #   auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so

  #   account    include                     login

  #   password   required                    pam_deny.so

  #   session    include                     login
  #   session    optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
  # '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
