{ config, lib, pkgs, ... }:

{
  imports = [
    ./home-manager.nix
  ];

  home-manager.backupFileExtension = ''home-manager-backup'';
  users.users.test = {
    isNormalUser = true;
    description = "Test User";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  programs.hyprland.enable = true;
  home-manager.users.test = { pkgs, ... }: {
    home.packages = [];
    programs.kitty.enable = true;
    wayland.windowManager.hyprland = {
      enable = true; # enable Hyprland

      settings = {
        "$mod" = "Super";
        bind = [
          "$mod, F, exec, firefox"
          "$mod, P, exec, kitty"
          "$mod, Space, exec, kitty"
          "$mod, Shift, Return, exec, alacritty"
        ];
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    gtk = {
      enable = true;

      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Grey-Darkest";
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };

      font = {
        name = "Sans";
        size = 11;
      };
    };
  };
}
