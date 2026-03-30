{ config, lib, pkgs, inputs, user, ... }:

let
  cfg = config.repo.secrets;
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  options.repo.secrets = {
    identityPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "${user.homedir}/.config/agenix/keys.txt" ];
      description = "Identity files used by agenix to decrypt managed secrets.";
    };

    files = lib.mkOption {
      default = { };
      description = "Secret definitions collected from modules and hosts and forwarded to agenix.";
      type = lib.types.attrsOf (lib.types.submodule ({ ... }: {
        options = {
          file = lib.mkOption {
            type = lib.types.either lib.types.path lib.types.str;
            description = "Encrypted source file in the repository.";
          };
          path = lib.mkOption {
            type = lib.types.str;
            description = "Deployment target path on the system.";
          };
          owner = lib.mkOption {
            type = lib.types.str;
            default = "root";
            description = "Owner of the deployed secret file.";
          };
          group = lib.mkOption {
            type = lib.types.str;
            default = "root";
            description = "Group of the deployed secret file.";
          };
          mode = lib.mkOption {
            type = lib.types.str;
            default = "0400";
            description = "Permissions for the deployed secret file.";
          };
          symlink = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether agenix should deploy the secret as a symlink.";
          };
        };
      }));
    };
  };

  config = {
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    age.identityPaths = cfg.identityPaths;
    age.secrets = cfg.files;
  };
}
