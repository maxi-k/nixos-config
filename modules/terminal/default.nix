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
      description = "Default Alacritty theme name to copy into active-theme.toml.";
    };

    fontSize = lib.mkOption {
      type = lib.types.float;
      default = 18.0;
      description = "Alacritty font size.";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      alacritty
    ];

    hm = { lib, addHomeBinary, addHomeConfig, config, ... }: {
    home.file = {}
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
        source = ./change-terminal-theme;
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
    };
  };
}
