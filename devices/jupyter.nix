{ config, pkgs, lib, ...}@ctx:

{
  imports = [
    ../shared.nix
    ../modules/podman.nix
  ] ++ lib.optional (builtins.pathExists ../local.nix) ../local.nix;

  networking.hostName = "jupyter";
  # networking.wireless.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = let
    dev = import ../package-groups/development.nix ctx;
    bspwm = import ../package-groups/bspwm.nix ctx;
    local = with pkgs; [
      superTuxKart
      discord
      brave
      vlc
      zoom-us
      easyeffects
      amdgpu_top
      usb-modeswitch
      usb-modeswitch-data
      gamemode
      via
    ];
  in dev ++ bspwm ++ local;

  # steam package + some tweaks
  programs.steam.enable = true;

  # set java version
  programs.java = { enable = true; package = pkgs.openjdk21; };

  # wifi + bluetooth stick setup
  hardware.usb-modeswitch.enable = true;
  # wifi stick driver
  boot.initrd.kernelModules = [ "8821cu" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8821cu
    # amd gpu
    # amdgpu-pro
  ];

  # newer kernel version for development (uring etc.)
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_11;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?
}
