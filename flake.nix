{
  description = "Shared Flake for my Systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:

    let
      system = "x86_64-linux"; 
      specialArgs = { inherit inputs; };

      overlays = [

      ];

      pkgs = import nixpkgs {
        inherit overlays system;
        config = {
          allowUnfree = true;
          allowAliases = true;
        };
      };

      # homeModule = {
      #   home-manager.useGlobalPkgs = true;
      #   home-manager.useUserPackages = true;
      #   home-manager.users.tziegler = import ./home.nix;
      # };

      baseModules = [
        ./shared.nix
        # home-manager.nixosModules.home-manager
        #homeModule
      ];

      hostModules = {
        jupyter = ./jupyter;
        thinkpad = ./thinkpad;
      };

      buildHost = name:
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = baseModules ++ [hostModules.${name}];
        };

    in {
      nixosConfigurations =
        nixpkgs.lib.mapAttrs (name: _: buildHost name) hostModules;
    };
}
