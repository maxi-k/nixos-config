{ pkgs, ... }: with pkgs; [
  # terminal
  alacritty
  # system utility
  networkmanager # network mgmnt
  blueman bluez  # bluetooth mgmnt
  tlp            # power mgmnt
  brightnessctl  # brightness mgmnt
  playerctl      # media player mgmnt
  easyeffects    # noise cancellation
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
  brave
  firefox
  thunderbird
  spotify
  syncthing
  cryptomator
]
