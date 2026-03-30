{ pkgs, ... }:

{
  imports = [
    ./launcher
    ./terminal
  ];

  services.printing.enable = true;

  services.displayManager.ly.enable = true;

  security.polkit.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.noto
    nerd-fonts.hack
    nerd-fonts.droid-sans-mono
    font-awesome
    noto-fonts-color-emoji
    inter
    jetbrains-mono
    libertinus
  ];

  environment.systemPackages = with pkgs; [
    networkmanager
    blueman bluez
    brightnessctl
    playerctl
    easyeffects
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    nautilus
    libreoffice-fresh
    zathura
    gimp
    xournalpp
    imagemagick ghostscript
    ncdu
    nix-tree
    brave
    spotify
  ];
}
