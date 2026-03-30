{ lib, user, ... }:

let
  braveApiKeySecret = ./brave-api-key.age;
in
{
  repo.secrets.files = lib.optionalAttrs (builtins.pathExists braveApiKeySecret) {
    eca-brave-api-key = {
      file = braveApiKeySecret;
      path = "${user.homedir}/.config/eca/brave-api-key";
      owner = user.name;
      group = "users";
      mode = "0600";
    };
  };

  hm.home.file = {
    ".config/eca/config.json".source = ./config.json;
    ".config/eca/commands/rewrite.md".source = ./commands/rewrite.md;
    ".config/eca/behaviors/writing-assistant.md".source = ./behaviors/writing-assistant.md;
  };
}
