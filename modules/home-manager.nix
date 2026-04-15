{ lib, inputs, user, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user.name ])
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "home-manager-backup";
  home-manager.sharedModules = [
    ({ config, ... }: {
      xdg.enable = true;

      _module.args = {
        addHomeFile = path: value: {
          "${path}" = value;
        };
        addHomeConfig = path: value: {
          ".config/${path}" = value;
        };
        addHomeBinary = name: value: {
          ".local/bin/${name}" = { executable = true; } // value;
        };
        addHomeData = path: value: {
          ".local/share/${path}" = value;
        };
      };
    })
  ];

  hm = {
    home.homeDirectory = user.homedir;
    home.stateVersion = "25.05";
  };
}
