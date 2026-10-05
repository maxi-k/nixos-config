{ config, lib, pkgs, ... }:

let
  cfg = config.repo.terminal;
  settingsFormat = pkgs.formats.toml { };
  alacrittySettings = lib.recursiveUpdate
    (builtins.fromTOML (builtins.readFile ./alacritty/alacritty.toml))
    {
      font.size = cfg.fontSize;
    };
in
{
  options.repo.terminal = {
    defaultTheme = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin-frappe";
      description = "Default terminal theme from the Alacritty theme collection, shared with Ghostty.";
    };

    fontSize = lib.mkOption {
      type = lib.types.float;
      default = 18.0;
      description = "Alacritty and Ghostty font size.";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      alacritty
    ];

    hm = { lib, addHomeBinary, addHomeConfig, config, ... }: {
    home.file = {}
      // addHomeConfig "ghostty/config" {
        text = builtins.readFile ./ghostty/config + ''
          font-size = ${toString cfg.fontSize}
        '';
      }
      // addHomeConfig "alacritty/alacritty.toml" {
        source = settingsFormat.generate "alacritty.toml" alacrittySettings;
      }
      // addHomeConfig "alacritty/alacritty.keys.toml" {
        source = ./alacritty/alacritty.keys.toml;
      }
      // addHomeConfig "alacritty/themes" {
        source = ./alacritty/themes;
        recursive = true;
      }
      // addHomeBinary "change-terminal-theme" {
        source = pkgs.replaceVars ./change-terminal-theme {
          python = "${pkgs.python3}/bin/python3";
          themeConverter = ./ghostty/convert-theme.py;
          pkill = "${pkgs.procps}/bin/pkill";
        };
        executable = true;
      };

      home.activation.ensureAlacrittyTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "${config.xdg.configHome}/alacritty"
        if [ ! -e "${config.xdg.configHome}/alacritty/active-theme.toml" ] || [ -L "${config.xdg.configHome}/alacritty/active-theme.toml" ]; then
          install -m 0644 "${./alacritty/themes}/${cfg.defaultTheme}.toml" "${config.xdg.configHome}/alacritty/active-theme.toml"
        else
          chmod u+w "${config.xdg.configHome}/alacritty/active-theme.toml" || true
        fi
      '';

      home.activation.ensureGhosttyTheme = lib.hm.dag.entryAfter [ "ensureAlacrittyTheme" ] ''
        mkdir -p "${config.xdg.configHome}/ghostty"
        # Preserve the current selection, including themes chosen before Ghostty
        # was installed, instead of resetting to the configured default.
        themeFile=$(mktemp)
        ${pkgs.python3}/bin/python3 ${./ghostty/convert-theme.py} \
          "${config.xdg.configHome}/alacritty/active-theme.toml" > "$themeFile"
        install -m 0644 "$themeFile" "${config.xdg.configHome}/ghostty/active-theme"
        rm -f "$themeFile"
      '';
    };
  };
}
