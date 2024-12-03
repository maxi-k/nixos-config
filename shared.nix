{ config,  pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
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

  services.displayManager.defaultSession = "none+bspwm";
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    # desktopManager.plasma5.enable = true;

    # Enable BSPWM and set as default
    windowManager.bspwm.enable = true;

    # Configure keymap in X11
    xkb.layout = "us,de";
    xkb.variant = "";
    # xkbOptions = "grp:win_space_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable power management with tlp
  # already provided by gnome services.power-profiles-daemon
  services.power-profiles-daemon.enable = true;
  # services.tlp.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true; # pre 24.05
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maxi = {
    isNormalUser = true;
    description = "Maximilian Kuschewski";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
  };

  # Nix setup
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.firefox.speechSynthesisSupport = true;

  # enable the nix user repository
  # nixpkgs.config.packageOverrides = pkgs: {
  #   nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #     inherit pkgs;
  #   };
  # };

  # font packages
  fonts.packages = with pkgs; [
      # icons
      emacs-all-the-icons-fonts
      nerdfonts
      font-awesome
      noto-fonts-emoji
      # emacs variable-pitch font
      inter
      # monospace font
      jetbrains-mono
  ];

  # Enable zsh
  programs.zsh.enable = true;
  # enable command-not-found support
  programs.command-not-found.enable = true;
  # Enable nix-direnv for automatically loading shell.nix files
  programs.direnv.enable = true;

  documentation = {
    # enable dev documentation (manpages)
    dev.enable = true;
    # re-generate man cache for apropos, whatis, man -k
    man.generateCaches = true;
  };
}
