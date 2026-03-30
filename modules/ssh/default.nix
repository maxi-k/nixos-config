{ config, lib, user, hostPath, ... }:

let
  hostDir = builtins.toString hostPath;
  sharedSshConfigSecret = ./ssh-config.shared.age;
  hostSshConfigSecret = hostDir + "/secrets/ssh-config.local.age";
  githubKeySecret = hostDir + "/secrets/github-id-ed25519.age";

  hasSharedSshConfig = builtins.pathExists sharedSshConfigSecret;
  hasHostSshConfig = builtins.pathExists hostSshConfigSecret;
  hasGithubKey = builtins.pathExists githubKeySecret;

  sshConfigIncludes = lib.concatStrings (
    lib.optional hasSharedSshConfig "Include ~/.ssh/config.shared\n"
    ++ lib.optional hasHostSshConfig "Include ~/.ssh/config.local\n"
  );
in
{
  systemd.tmpfiles.rules = [
    "d ${user.homedir}/.ssh 0700 ${user.name} users -"
  ];

  repo.secrets.files =
    lib.optionalAttrs hasSharedSshConfig {
      ssh-config-shared = {
        file = sharedSshConfigSecret;
        path = "${user.homedir}/.ssh/config.shared";
        owner = user.name;
        group = "users";
        mode = "0600";
      };
    }
    // lib.optionalAttrs hasHostSshConfig {
      ssh-config-local = {
        file = hostSshConfigSecret;
        path = "${user.homedir}/.ssh/config.local";
        owner = user.name;
        group = "users";
        mode = "0600";
      };
    }
    // lib.optionalAttrs hasGithubKey {
      github-ssh-key = {
        file = githubKeySecret;
        path = "${user.homedir}/.ssh/id_ed25519";
        owner = user.name;
        group = "users";
        mode = "0600";
      };
    };

  hm.home.file.".ssh/config" = {
    text = if sshConfigIncludes != "" then sshConfigIncludes else "# Managed by Home Manager\n";
    force = true;
  };
}
