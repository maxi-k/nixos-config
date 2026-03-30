{ config, lib, user, hostPath, ... }:

let
  hostDir = builtins.toString hostPath;
  sharedSshConfigSecret = ./secrets/ssh-config.shared.age;
  hostSshConfigSecret = hostDir + "/secrets/ssh-config.local.age";

  hasSharedSshConfig = builtins.pathExists sharedSshConfigSecret;
  hasHostSshConfig = builtins.pathExists hostSshConfigSecret;

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
    } // {
      github-key-private = {
        file = ./secrets/github.age;
        path = "${user.homedir}/.ssh/github";
        owner = user.name;
        group = "users";
        mode = "0600";
      };
    }
  ;

  hm = { addHomeFile, ... }: {
    home.file = addHomeFile ".ssh/config" {
      text = if sshConfigIncludes != "" then sshConfigIncludes else "# Managed by Home Manager\n";
      force = true;
    } // addHomeFile ".ssh/github.pub" {
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQgz6q77myMHCEvE1gYeBRTApbdhtbHe392LLwOCjn4 maxi-k@github";
      force = true;
    };
  };
}
