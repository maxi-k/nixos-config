{ pkgs, ... }@ctx:

pkgs.callPackage (builtins.fetchGit {
  url = "https://github.com/quickshell-mirror/quickshell";
  rev = "00858812f25b748d08b075a0d284093685fa3ffd";
}) {}
