{ config, lib, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.displayManager.ly.enable = true; #
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable the GNOME Desktop Environment.
    # desktopManager.gnome.enable = true;
    # desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    xkb.layout = "us,de";
    xkb.variant = "";
    # xkbOptions = "grp:win_space_toggle";
    xkb.options = "caps:escape,escape:";
  };

  # font packages
  fonts.packages = with pkgs; [
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

  environment.systemPackages = with pkgs; [
    # terminal
    alacritty
    # system utility
    networkmanager # network mgmnt
    blueman bluez  # bluetooth mgmnt
    brightnessctl  # brightness mgmnt
    playerctl      # media player mgmnt
    easyeffects    # noise cancellation
    # spell checking
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    # utility programs
    nautilus
    libreoffice-fresh
    sxiv
    zathura
    gimp
    xournalpp
    imagemagick ghostscript
    # disk usage visualization
    ncdu
    nix-tree
    # web stuff
    brave
    spotify
  ];
}
