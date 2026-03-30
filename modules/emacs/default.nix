{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    emacs-all-the-icons-fonts
  ];

  environment.systemPackages = with pkgs; [
    emacs-gtk
    libvterm
    libtool
    ripgrep
    fd
    sqlite
    graphviz
    shellcheck
    nil
    nixfmt
    git
  ];

  hm.home.file.".local/bin/doom-install" = {
    source = ./doom-install;
    executable = true;
  };

  hm.home.file.".local/bin/emacs-scratchpad" = {
    source = ./emacs-scratchpad;
    executable = true;
  };
}
