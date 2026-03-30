{ config, lib, pkgs, ... }:

{
  imports = [
    ./emacs
    ./perf-utils
  ];

  environment.systemPackages = with pkgs; [
    # dev tools & editors
    git git-lfs jujutsu 
    vim 
    zsh bash tmux
    curl wget
    zip unzip unp
    gdb gcc
    cmake glib gnumake
    killall
    # performace
    htop iotop powertop
    lm_sensors
    # nice-to-have global languages
    python3 nodejs_22
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
  ];

  hm = {
    programs.git = {
      enable = true;
      signing = {
        key = "BA96B52648D56595";
        signByDefault = false;
      };
      settings = {
        user = {
          name = "Maximilian Kuschewski";
          email = "maxi.kuschewski@gmail.com";
        };
        core.editor = "vim";
        credential.helper = "cache";
        init.defaultBranch = "master";
        commit.gpgsign = false;
      };
    };
  };
}
