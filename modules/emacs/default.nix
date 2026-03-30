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

  hm = { addHomeBinary, ... }: {
    home.file = {}
      // addHomeBinary "doom-install" {
        source = ./doom-install;
        executable = true;
      }
      // addHomeBinary "emacs-scratchpad" {
        source = ./emacs-scratchpad;
        executable = true;
      };
  };
}
