{ config, lib, pkgs, ... }:

{
  imports = [
    ./home-manager.nix
  ];

  home-manager.backupFileExtension = ''home-manager-backup'';
  programs.hyprland.enable = true;
  home-manager.users.maxi = { pkgs, ... }: {
    imports = [
      pkgs.inputs.noctalia.homeModules.default
    ];

  # configure options
  programs.noctalia-shell = {
    enable = true;
    settings = {
      # configure noctalia here
      bar = {
        density = "compact";
        position = "right";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Monochrome";
      location = {
        monthBeforeDay = true;
        name = "Munich, Germany";
      };
    };
    # this may also be a string or a path to a JSON file.
  };
  };

}
