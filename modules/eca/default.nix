{ lib, pkgs, user, ... }:

let
  braveApiKeySecret = ./brave-api-key.age;
in
{
  environment.systemPackages = [ pkgs.curl ];

  systemd.tmpfiles.rules = [
    "d ${user.homedir}/.config/eca 0700 ${user.name} users -"
    "d ${user.homedir}/.config/eca/commands 0700 ${user.name} users -"
    "d ${user.homedir}/.config/eca/behaviors 0700 ${user.name} users -"
  ];

  repo.secrets.files = lib.optionalAttrs (builtins.pathExists braveApiKeySecret) {
    eca-brave-api-key = {
      file = braveApiKeySecret;
      path = "${user.homedir}/.config/eca/brave-api-key";
      owner = user.name;
      group = "users";
      mode = "0600";
    };
  };

  hm = { addHomeConfig, ... }: {
    home.file = {}
      // addHomeConfig "eca/config.json" {
        source = ./config.json;
      }
      // addHomeConfig "eca/commands/rewrite.md" {
        source = ./commands/rewrite.md;
      }
      // addHomeConfig "eca/behaviors/writing-assistant.md" {
        source = ./behaviors/writing-assistant.md;
      };
  };
}
