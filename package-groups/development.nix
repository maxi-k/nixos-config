{ pkgs, ... }: with pkgs; [
  # dev tools & editors
  emacs29-gtk3 vim
  git git-lfs
  curl wget
  zip unzip unp
  tmux
  zsh bash
  gnumake
  gdb
  gcc
  bc
  killall
  # performace
  linuxPackages_latest.perf
  hotspot
  htop
  iotop
  powertop
  lm_sensors
  # nice-to-have global languages
  python3
  nodejs_18
  # other tools
  stow
  usbutils
  pciutils
  entr
  # documentation
  man-pages
  man-pages-posix
]
