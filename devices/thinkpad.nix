{ config, pkgs, ... }@ctx:

{
  imports = [
    ../shared.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "thinkpad-maxi"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Define a chair account for shared usage
  users.users.chair = {
    isNormalUser = true;
    description = "Chair Account";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = let
    dev = import ../package-groups/development.nix ctx;
    bspwm = import ../package-groups/bspwm.nix ctx;
  in dev ++ bspwm ++ (with pkgs; [
    # local packages
    zoom-us
    google-chrome  
    chromium
    xournalpp
    screenkey
    sqlite
    vscode
    clang
    gcc
    # droidcam setup b/c this computer's mic is abysmal
    # android-tools
    # android-udev-rules
    # linuxKernel.packages.linux_6_1.v4l2loopback
    # droidcam
  ]);

  services.xserver.desktopManager.gnome.enable = true;
  
  programs.adb.enable = true;
  users.users.maxi.extraGroups = ["adbusers" "plugdev"];
  boot.kernelModules = [ "v4l2loopback" ];

  # test hyprland
  # programs.hyprland = {
  #     # portalPackage = true;
  #     xwayland.enable = true;
  #     #xwayland.hidpi = true;
  #     enable = true;
  # };

  # programs.sway = {
  #   enable = true;
  # };

  # when enabling multiple desktop environments
  # (e.g. plasma & gnome), need to specify this
  # explicitly
  # see https://github.com/NixOS/nixpkgs/issues/75867
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

  hardware = {  
     enableAllFirmware = true;
  }; 

  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   pulse.enable = true;
  #   wireplumber.extraConfig = {
  #    "wh-1000xm3-ldac-hq" = {
  #           "monitor.bluez.rules" = [
  #             {
  #               matches = [
  #                 {
  #                   # Match any bluetooth device with ids equal to that of a WH-1000XM3
  #                   "device.name" = "~bluez_card.*";
  #                   "device.product.id" = "0x0cd3";
  #                   "device.vendor.id" = "usb:054c";
  #                 }
  #               ];
  #               actions = {
  #                 update-props = {
  #                   # Set quality to high quality instead of the default of auto
  #                   "bluez5.a2dp.ldac.quality" = "hq";
  #                 };
  #               };
  #             }
  #          ];
  #       };
  #   };
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
