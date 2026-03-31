{ config, pkgs, ... }:

{
  imports = [];

  # Nix setup
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking, set name servers to cloudflare & google
  networking = {
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "8.8.8.8"];
    enableIPv6  = true;
  };

  # Enable my VPN services
  services.tailscale.enable = true;
  services.mullvad-vpn.enable = true;

  # Set time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    # supportedLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
    # inputMethod.ibus.engines = with pkgs.ibus-engines; [ uniemoji ];
    # inputMethod.enabled = "ibus";
  };

  # Enable sound with pipewire.
  # sound.enable = true; # pre 24.05
  security.rtkit.enable = true;

  # enable gnupg + pinentry
  services.pcscd.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
     pinentryPackage = pkgs.lib.mkForce pkgs.pinentry-emacs;
  };

  # Enable zsh
  programs.zsh.enable = true;
  # enable command-not-found support
  programs.command-not-found.enable = true;
  # Enable nix-direnv for automatically loading shell.nix files
  programs.direnv.enable = true;

  documentation = {
    # enable dev documentation (manpages)
    enable = true;
    man.enable = true;
    doc.enable = true;
    dev.enable = true;
    # re-generate man cache for apropos, whatis, man -k
    # man.cache.enable = true; # <-- this takes forever
  };
}
