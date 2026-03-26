{ config, lib, pkgs, inputs, system, user, ... }:

{
  imports = [
    inputs.lispwm.nixosModules.default
  ];
  environment.systemPackages = with pkgs; [
    wl-clipboard                        # xclip equivalent
    rofi                                # generic launcher
    swaylock                            # screen locking
    xwayland-satellite                  # x session inside wayland
    inputs.awww.packages.${system}.awww # wallpaper daemon
    grim                                # grab images from wayland
    slurp                               # select a region in wayland
    kooha                               # screen recording
  ];

  services.displayManager.lispwm.river.enable = true;
}
