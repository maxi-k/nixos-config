{
  description = "Shared Flake for my Systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
     url = "github:nix-community/home-manager"; 
     inputs.nixpkgs.follows = "nixpkgs";
    };
    tigerwm = {
      # url = "git+ssh://git@github.com/toziegler/tigerWM.git";
      url = "path:/home/maxi/dev/tigerwm";
      # url = "git+file:/home/maxi/dev/tigerwm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awww = {
      url = "git+https://codeberg.org/LGFae/awww"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lispwm = {
      # url = "git+ssh://git@github.com/maxi-k/lispwm.git";
      url = "path:/home/maxi/dev/lispwm";
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
        home-manager.nixosModules.home-manager
      ] ++ pkgs.lib.optional (builtins.pathExists localModulePath) localModulePath;

      hostModules = {
        jupyter = ./hosts/jupyter;
        thinkpad-maxi = ./hosts/thinkpad;
        live-usb = ./hosts/live-usb.nix;
      };

      buildHost = name:
        nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = { inherit inputs; inherit system; inherit user; };
          modules = sharedModules ++ [hostModules.${name}];
        };

    in {
      nixosConfigurations =
        nixpkgs.lib.mapAttrs (name: _: buildHost name) hostModules;
    };
}
