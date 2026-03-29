{ lib, inputs, user, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user.name ])
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "home-manager-backup";

  hm = {
    home.homeDirectory = user.homedir;
    home.stateVersion = "25.05";
  };
}
