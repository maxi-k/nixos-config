{ pkgs, ... }: with pkgs; [
  # terminal
  alacritty
  # system utility
  networkmanager # network mgmnt
  blueman # bluetooth mgmnt
  tlp  # power mgmnt
  brightnessctl # brightness mgmnt
  playerctl # media player mgmnt
  # utility programs
  libreoffice-fresh
  sxiv
  zathura
  gimp
  xournalpp
  # web stuff
  firefox
  thunderbird
  spotify
  syncthing
  cryptomator
  hunspell
  hunspellDicts.de_DE
  hunspellDicts.en_US
]
