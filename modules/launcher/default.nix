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
  };
}
