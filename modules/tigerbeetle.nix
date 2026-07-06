{ config, lib, pkgs, flakeOutputPath, ... }:

{
  system.autoUpgrade = {
    enable = true;
    flake = "${flakeOutputPath}#${config.networking.hostName}";

    dates = "daily";
    # build + set next boot, but do not switch live
    operation = "boot"; 
    # If missed while laptop was off, run later.
    persistent = true;
    allowReboot = false;
  };
  networking.firewall.enable = true;
  security.apparmor.enable = true;

  environment.systemPackages = with pkgs; [
    # _1password-gui
    zoom-us
    dmidecode
  ];

    hm = { config, addHomeBinary, ... }: {
      home.file = addHomeBinary "tb-check-soc2-compliance" {
        text = ''
  echo "Device security evidence - $(date -I)"
  echo
  echo "== Host =="
  sudo dmidecode -s system-serial-number
  echo
  echo "== NixOS version =="
  nixos-version
  echo
  echo "== Firewall =="
  systemctl status firewall.service --no-pager
  echo
  echo "== Automatic upgrades =="
  systemctl status nixos-upgrade.timer --no-pager
  echo
  echo "== Linux Security Modules =="
  cat /sys/kernel/security/lsm
  echo
  echo "== AppArmor =="
  aa-status 2>/dev/null || echo "AppArmor status not available"
'';
        executable = true;
      };
    };
}
