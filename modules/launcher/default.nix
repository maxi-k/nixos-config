{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rofi
  ];

  hm.home.file = {
    ".local/bin/launcher" = {
      source = ./launcher;
      executable = true;
    };
    ".local/bin/selector" = {
      source = ./selector;
      executable = true;
    };
    ".local/bin/run-flatpak" = {
      source = ./run-flatpak;
      executable = true;
    };
  };
}
