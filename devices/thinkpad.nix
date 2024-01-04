{ config, pkgs, ... }@ctx:

{
  imports = [
    ../shared.nix
  ];

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
    packages = with pkgs; [
      clang_16
      gcc13
      gcc
      tbb_2021_8
    ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = let
    dev = import ../package-groups/development.nix ctx;
    bspwm = import ../package-groups/bspwm.nix ctx;
  in dev ++ bspwm ++ [
    # local packages
  ];

  # test hyprland
  programs.hyprland = {
      # portalPackage = true;
      xwayland.enable = true;
      xwayland.hidpi = true;
      enable = true;
  };

  programs.sway = {
    enable = true;
  };

  # when enabling multiple desktop environments
  # (e.g. plasma & gnome), need to specify this
  # explicitly
  # see https://github.com/NixOS/nixpkgs/issues/75867
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";

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
