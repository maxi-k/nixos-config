{ config, lib, pkgs, inputs, user, ... }:

let
  repoRoot = builtins.toString ../.;
  hostSecretsDir = "${repoRoot}/secrets/hosts/${config.networking.hostName}";
  sharedSecretsDir = "${repoRoot}/secrets/shared";
  sharedSshConfigSecret = "${sharedSecretsDir}/ssh-config.age";
  hostSshConfigSecret = "${hostSecretsDir}/ssh-config.local.age";
  githubKeySecret = "${hostSecretsDir}/github-id-ed25519.age";

  hasSharedSshConfig = builtins.pathExists sharedSshConfigSecret;
  hasHostSshConfig = builtins.pathExists hostSshConfigSecret;

  sshConfigIncludes = lib.concatStrings (
    lib.optional hasSharedSshConfig "Include ~/.ssh/config.shared\n"
    ++ lib.optional hasHostSshConfig "Include ~/.ssh/config.local\n"
  );
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
  ];

  age.identityPaths = [
    "${user.homedir}/.config/agenix/keys.txt"
  ];

  systemd.tmpfiles.rules = [
    "d ${user.homedir}/.ssh 0700 ${user.name} users -"
  ];

  age.secrets =
    lib.optionalAttrs hasSharedSshConfig {
      ssh-config-shared = {
        file = sharedSshConfigSecret;
        path = "${user.homedir}/.ssh/config.shared";
        owner = user.name;
        mode = "600";
      };
    }
    // lib.optionalAttrs hasHostSshConfig {
      ssh-config-local = {
        file = hostSshConfigSecret;
        path = "${user.homedir}/.ssh/config.local";
        owner = user.name;
        mode = "600";
      };
    }
    // lib.optionalAttrs (builtins.pathExists githubKeySecret) {
      github-ssh-key = {
        file = githubKeySecret;
        path = "${user.homedir}/.ssh/id_ed25519";
        owner = user.name;
        mode = "600";
      };
    };

  hm.home.file.".ssh/config" = {
    text = if sshConfigIncludes != "" then sshConfigIncludes else "# Managed by Home Manager\n";
    force = true;
  };
}
