{ config, lib, pkgs, inputs, system, user, ... }:

let
  tigerwm_pkg = inputs.tigerwm.packages.${system}.default.override {
    configFile = ./config.zig;
    keybindingsFile = ./keybindings.zig;
    xwayland = true;
  };
  tigerwm = tigerwm_pkg.overrideAttrs (_: {
    postInstall =
      # don't use ${tigerwm_pkg}/bin because that is pinned to the
      # package version that created the file
      let
        tigerwmSession = ''
          [Desktop Entry]
          Name=TigerWM
          Comment=Dynamic Wayland compositor
          Exec=/run/current-system/sw/bin/tigerstylewm
          type=Application
        '';
      in
        ''
          mkdir -p $out/share/wayland-sessions
          echo "${tigerwmSession}" > $out/share/wayland-sessions/tigerwm.desktop
        '';
    passthru.providedSessions = [ "tigerwm" ];
  });
in
{
  nixpkgs.overlays = [
    # (final: prev: {
    #   tigerwm = inputs.tigerwm.packages.${system}.default.override {
    #     # configFile = ./tigerwm-config.zig;
    #     # keybindingsFile = ./tigerwm-keybindings.zig;
    #     xwayland = true;
    #   };
    # })
  ];

  environment.systemPackages = [tigerwm] ++ (with pkgs; [
    grim                                # grab images from wayland
    slurp                               # select a region in wayland
    wl-clipboard                        # xclip equivalent
    rofi                                # generic launcher
    swaylock                            # screen locking
    xwayland-satellite                  # x session inside wayland
    inputs.awww.packages.${system}.awww # wallpaper daemon
  ]);

  services.displayManager.sessionPackages = [
    tigerwm
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk];
    config.common.default = ["wlr" "gtk"];
  };

  # Zoom hardcodes /usr/libexec/xdg-desktop-portal for screen sharing
  systemd.tmpfiles.rules = [
    "L+ /usr/libexec/xdg-desktop-portal - - - - ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
  ];

  home-manager.users.${user.name}.programs = {
    swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
    };

    waybar = {
      enable = true;
      style = ''
        * {
          font-family: 'Jetbrains Mono';
          font-size: 18px;
        }
        window#waybar {
          background-color: rgba(34, 34, 34, 0.9);
          color: #ffffff;
        }
        #tags button {
          padding: .3em 1em;
          background-color: transparent;
          color: #888888;
        }
        #tags button.occupied {
          color: #cccccc;
        }
        #tags button.focused {
          color: #ffffff;
          background-color: rgba(0, 85, 119, 0.4);
        }
        #tags button.urgent {
          color: #ff0000;
        }
        #window, #clock, #battery, #network, #pulseaudio, #tray {
          padding: 0 1em;
          color: #ffffff;
        }
      '';
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          modules-left = ["dwl/tags"];
          modules-center = ["dwl/window"];
          modules-right = ["pulseaudio" "network" "battery" "clock" "tray" ];

          "dwl/tags" = {
            num-tags = 11;
            tag-labels = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "~"];
          };

          "dwl/window" = {
            format = "{layout} {title}";
            max-length = 80;
          };

          clock = {
            format = "{:%Y-%m-%d %H:%M}";
          };

          battery = {
            format = "{capacity}% {icon}";
            format-icons = ["" "" "" "" ""];
          };

          network = {
            format-wifi = "{essid}";
            format-ethernet = "Wired";
            format-disconnected = "Disconnected";
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-muted = "Muted";
            format-icons.default = ["" "" ""];
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          };
        };
      };
    };
  };
}
