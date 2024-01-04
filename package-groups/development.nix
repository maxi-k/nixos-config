{ pkgs, ... }: with pkgs; [
  # dev tools & editors
  emacs29-gtk3 vim
  git git-lfs
  curl wget
  zip unzip unp
  tmux
  zsh bash
  gnumake
  man-pages
  man-pages-posix
  gdb
  killall
  # performace
  linuxPackages_latest.perf
  hotspot
  htop
  iotop
  powertop
  lm_sensors
  # Fonts
  jetbrains-mono
  font-awesome
  nerdfonts
  # nice-to-have global languages
  python3
  nodejs_18
  # other tools
  stow
]
