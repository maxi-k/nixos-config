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
          "${config.home.homeDirectory}/${path}" = value;
        };
        addHomeConfig = path: value: {
          "${config.xdg.configHome}/${path}" = value;
        };
        addHomeBinary = name: value: {
          "${config.home.homeDirectory}/.local/bin/${name}" = value;
        };
        addHomeData = path: value: {
          "${config.xdg.dataHome}/${path}" = value;
        };
      };
    })
  ];

  hm = {
    home.homeDirectory = user.homedir;
    home.stateVersion = "25.05";
  };
}
