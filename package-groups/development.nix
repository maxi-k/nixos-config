{ pkgs, ... }: with pkgs; [
  # dev tools & editors
  emacs vim libvterm
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
  nodejs_22
  # other tools
  stow
  usbutils
  pciutils
  entr
  copilot-language-server
  claude-code
  # documentation
  man-pages
  man-pages-posix
]
