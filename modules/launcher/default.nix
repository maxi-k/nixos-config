{ config, lib, pkgs, ... }:

let
  cfg = config.repo.launcher;
in
{
  options.repo.launcher.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Whether to install the launcher abstraction and its rofi-backed tools.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rofi
      flatpak
    ];

    hm = { addHomeBinary, ... }: {
      home.file = {}
        // addHomeBinary "launcher" {
          source = ./launcher;
          executable = true;
        }
        // addHomeBinary "selector" {
          source = ./selector;
          executable = true;
        }
        // addHomeBinary "run-flatpak" {
          source = ./run-flatpak;
          executable = true;
        };
    };
  };
}
