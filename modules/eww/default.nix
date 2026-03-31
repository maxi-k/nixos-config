{ config, lib, pkgs, ... }:

let
  cfg = config.repo.eww;
in
{
  options.repo.eww.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
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

    hm = { addHomeConfig, ... }: {
      home.file = addHomeConfig "eww" {
        source = ./config;
        recursive = true;
      };
    };
  };
}
