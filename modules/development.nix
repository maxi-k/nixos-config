{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
    perf
    hotspot
    htop
    iotop
    powertop
    lm_sensors
    # nice-to-have global languages
    python3
    nodejs_22
    # scientific calculator
    numbat
    # other tools
    stow
    usbutils
    pciutils
    entr
    copilot-language-server
    codex
    # documentation
    man-pages
    man-pages-posix
    #
    libtool
    cmake
    glib
  ];
}
