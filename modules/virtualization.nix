{ pkgs, ... }:

{
  #programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["maxi"];
  environment.systemPackages = with pkgs; [
    gnome-boxes
  ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
