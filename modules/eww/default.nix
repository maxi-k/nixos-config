{ config, lib, pkgs, ... }:

let
  cfg = config.repo.eww;
in
{
  options.repo.eww.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to install and configure eww.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      eww
      curl
      jq
      lm_sensors
      htop
      pavucontrol
    ];

    hm = { addHomeBinary, addHomeConfig, ... }: {
      home.file = {}
        // addHomeConfig "eww" {
          source = ./config;
          recursive = true;
        }
        // addHomeBinary "eww-sysmenu" {
          text = ''
            #!/usr/bin/env sh

            window_name=''${1:-"sysmenu-bottom-left"}

            pgrep eww || eww daemon

            if pgrep picom > /dev/null; then
              eww open-many --toggle "$window_name-closer" "$window_name"
            else
              eww open --toggle "$window_name"
            fi
          '';
          executable = true;
        };
    };
  };
}
