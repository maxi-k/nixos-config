{ config,  pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

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

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    # desktopManager.plasma5.enable = true;

    # Enable BSPWM and set as default
    windowManager.bspwm.enable = true;
    displayManager.defaultSession = "none+bspwm";

    # Configure keymap in X11
    layout = "us,de";
    xkbVariant = "";
    # xkbOptions = "grp:win_space_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable power management with tlp
  # already provided by gnome services.power-profiles-daemon
  services.power-profiles-daemon.enable = true;
  # services.tlp.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
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
  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maxi = {
    isNormalUser = true;
    description = "Maximilian Kuschewski";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      thunderbird
      stow
      spotify
      syncthing
      cryptomator
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US
    ];
    shell = pkgs.zsh;
  };

  # Nix setup
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Enable nix-direnv for automatically loading shell.nix files
  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
  };
  environment.pathsToLink = [ "/share/nix-direnv" ];
  environment.systemPackages = with pkgs; [
    direnv
    nix-direnv
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.firefox.speechSynthesisSupport = true;

  # Enable zsh
  programs.zsh.enable = true;
  # enable command-not-found support
  programs.command-not-found.enable = true;

  documentation = {
    # enable dev documentation (manpages)
    dev.enable = true;
    # re-generate man cache for apropos, whatis, man -k
    man.generateCaches = true;
  };
}
