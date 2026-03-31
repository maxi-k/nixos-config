{ pkgs, ... }:

{
  imports = [
    ./launcher
    ./terminal
    ./webapps
    ./eca
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
    networkmanagerapplet
    glib
    xdg-utils
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
    spotify
    edid-decode
  ];

  hm = { config, addHomeBinary, ... }: {
    home.file = addHomeBinary "list-display-serial-numbers" {
      text = ''
for file in $(ls -1 /sys/class/drm/*/edid); do
    text=$(tr -d 0 <"$file")
    if [ -n "$text" ]; then
        edid-decode "$file" | grep -e Manufacturer: -e Product
        sleep 0.0001
    fi
done
'';
      executable = true;
    };
  };
}
