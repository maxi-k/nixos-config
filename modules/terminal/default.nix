{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    alacritty
  ];

  hm = { lib, ... }: {
    home.file = {
      ".config/alacritty/alacritty.toml".source = ./alacritty/alacritty.toml;
      ".config/alacritty/alacritty.keys.toml".source = ./alacritty/alacritty.keys.toml;
      ".config/alacritty/themes" = {
        source = ./alacritty/themes;
        recursive = true;
      };
      ".local/bin/change-terminal-theme" = {
        source = ./change-terminal-theme;
        executable = true;
      };
    };

    home.activation.ensureAlacrittyTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/alacritty"
      if [ ! -e "$HOME/.config/alacritty/active-theme.toml" ]; then
        cp "${./alacritty/themes/catppuccin-frappe.toml}" "$HOME/.config/alacritty/active-theme.toml"
      fi
    '';
  };
}
