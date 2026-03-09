{ pkgs, inputs, ... }:
{
  imports = [
    (import "${inputs.home-manager}")
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.maxi = {pkgs, ...}: {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "25.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  };
}
