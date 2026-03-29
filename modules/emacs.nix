{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
      emacs-all-the-icons-fonts
  ];

  environment.systemPackages = with pkgs; [
    emacs-gtk 
    libvterm
    libtool
  ];
}
