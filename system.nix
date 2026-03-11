{ config, pkgs, ... }:

{
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

  services.displayManager.defaultSession = "none+bspwm";
  services.displayManager.ly.enable = true; #
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable BSPWM and set as default
    windowManager.bspwm.enable = true;

    # Enable the GNOME Desktop Environment.
    # desktopManager.gnome.enable = true;
    # desktopManager.plasma5.enable = true;

    # Configure keymap in X11
    xkb.layout = "us,de";
    xkb.variant = "";
    # xkbOptions = "grp:win_space_toggle";
    xkb.options = "caps:escape,escape:";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable power management with tlp
  # already provided by gnome services.power-profiles-daemon
  # services.power-profiles-daemon.enable = true;
  # services.tlp.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true; # pre 24.05
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
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

  # font packages
  fonts.packages = with pkgs; [
      # icons
      emacs-all-the-icons-fonts
      nerd-fonts.symbols-only
      nerd-fonts.noto
      nerd-fonts.hack
      nerd-fonts.droid-sans-mono
      font-awesome
      noto-fonts-color-emoji
      # emacs variable-pitch font
      inter
      # monospace font
      jetbrains-mono
      libertinus
  ];

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
