{ config, lib, pkgs, ... }:

let
  cfg = config.repo.desktop;
  displayManager = cfg.displayManager;
in
{
  imports = [
    ./launcher
    ./terminal
    ./eww
    ./webapps
    ./eca
  ];

  options.repo.desktop.displayManager = lib.mkOption {
    type = lib.types.enum [ "gdm" "ly" "lemurs" ];
    default = "ly";
    description = "Display manager to use for logging in.";
  };

  config = {
    services.displayManager.${displayManager}.enable = true;
    security.polkit.enable = true;
    services.printing.enable = true;
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
  };
}
