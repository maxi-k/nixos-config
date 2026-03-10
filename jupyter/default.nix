{ config, pkgs, lib, inputs, ...}@ctx:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/tigerwm
    ../modules/bspwm.nix
    ../modules/development.nix
    ../modules/podman.nix
    ../modules/virtualization.nix
  ] ++ lib.optional (builtins.pathExists ../local.nix) ../local.nix;

  networking.hostName = "jupyter";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      supertuxkart
      limo
      discord
      vlc
      zoom-us
      amdgpu_top
      # btop-rocm # btop + amdgu support
      usb-modeswitch
      usb-modeswitch-data
      gamemode
      via
      # for controllers etc
      steam-devices-udev-rules
  ];

  services.tailscale.enable = true;
  # steam package + some tweaks
  programs.steam.enable = true;
  # set java version
  programs.java = { enable = true; package = pkgs.openjdk21; };

  # wifi + bluetooth stick setup
  hardware.bluetooth.enable = true;
  hardware.bluetooth.input.General.UserspaceHID = true;
  hardware.usb-modeswitch.enable = true;
  # auto mode switching for cd-rom mode (windows installer) to
  # networking stick mode for wifi + bluetooth stick
  services.udev.packages = with pkgs; [
    usb-modeswitch
    usb-modeswitch-data
  ];

  # newer kernel version for development (uring etc.)
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
