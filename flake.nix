{
  description = "Shared Flake for my Systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
     url = "github:nix-community/home-manager"; 
     inputs.nixpkgs.follows = "nixpkgs";
    };
    tigerwm = {
      url = "git+ssh://git@github.com/toziegler/tigerWM.git";
      # url = "path:/home/maxi/dev/tigerwm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, tigerwm, ... }:

    let
      system = "x86_64-linux"; 

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
      ];

      hostModules = {
        jupyter = ./jupyter;
        thinkpad = ./thinkpad;
      };

      user = {
        name = "maxi";
        homedir = "/home/maxi";
        fullName = "Maximilian Kuschewski";
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
