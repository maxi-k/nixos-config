{ user, ... }:

{
  services.syncthing = {
    enable = true;
    user = user.name;
    dataDir = user.homedir;
  };
}
