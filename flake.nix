{
  description = "Shared Flake for my Systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
     url = "github:nix-community/home-manager"; 
     inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tigerwm = {
      url = "git+ssh://git@github.com/toziegler/tigerWM.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awww = {
      url = "git+https://codeberg.org/LGFae/awww"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lispwm = {
      url = "git+ssh://git@github.com/maxi-k/lispwm.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, tigerwm, lispwm, ... }:

    let
      system = "x86_64-linux"; 
      user = {
        name = "maxi";
        homedir = "/home/maxi";
        fullName = "Maximilian Kuschewski";
      };
      localModulePath = "${user.homedir}/dev/nixos-config/local.nix";

      overlays = [];

      pkgs = import nixpkgs {
        inherit overlays system;
        config = {
          allowUnfree = true;
          allowAliases = true;
        };
      };

      sharedModules = [
        ./system.nix
        ./user.nix
        ./modules/home-manager.nix
        ./modules/secrets
        ./modules/ssh
        ./modules/syncthing.nix
        ./modules/shell
        ./modules/zsh
      ] ++ pkgs.lib.optional (builtins.pathExists localModulePath) localModulePath;

      hostModules = {
        jupyter = ./hosts/jupyter;
        thinkpad-maxi = ./hosts/thinkpad;
        luna = ./hosts/luna;
        live-usb = ./hosts/live-usb.nix;
      };

      buildHost = name:
        nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = {
            inherit inputs system user;
            hostName = name;
            hostPath = hostModules.${name};
          };
          modules = sharedModules ++ [hostModules.${name}];
        };

    in {
      nixosConfigurations =
        nixpkgs.lib.mapAttrs (name: _: buildHost name) hostModules;
    };
}
