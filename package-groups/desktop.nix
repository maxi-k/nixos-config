{ pkgs, ... }: with pkgs; [
  # terminal
  alacritty
  # system utility
  networkmanager # network mgmnt
  blueman # bluetooth mgmnt
  tlp  # power mgmnt
  brightnessctl # brightness mgmnt
  playerctl # media player mgmnt
  # spell checking
  hunspell
  hunspellDicts.de_DE
  hunspellDicts.en_US
  # utility programs
  libreoffice-fresh
  sxiv
  zathura
  gimp
  xournalpp
  # disk usage visualization
  ncdu
  nix-tree
  # web stuff
  firefox
  thunderbird
  spotify
  syncthing
  cryptomator
]
