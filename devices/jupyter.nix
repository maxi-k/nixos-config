{ config, pkgs, ...}@ctx:

{
  imports = [
    ../shared.nix
  ];

  networking.hostName = "jupyter";
  # networking.wireless.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = let
    dev = import ../package-groups/development.nix ctx;
    bspwm = import ../package-groups/bspwm.nix ctx;
    local = with pkgs; [
      steam
      superTuxKart
      discord
    ];
  in dev ++ bspwm ++ local;

  # packages for the current kernel version
  boot.blacklistedKernelModules = ["rtl8xxxu"];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8821cu # wifi+bluetooth stick
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
