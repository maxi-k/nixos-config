{ pkgs, ... }:

{
  hm = { config, addHomeFile, addHomeConfig, ... }: {
    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      initExtra = builtins.readFile ./dotfiles/.zshrc;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd" "z" ];
    };

    home.file = {}
      // addHomeFile ".zprofile" {
        source = ./dotfiles/.zprofile;
      }
      // addHomeConfig "zsh/lookrc" {
        source = ./dotfiles/lookrc;
      }
      // addHomeConfig "zsh/keyrc" {
        source = ./dotfiles/keyrc;
      }
      // addHomeConfig "zsh/toolrc" {
        source = ./dotfiles/toolrc;
      }
      // addHomeConfig "zsh/pluginrc" {
        source = ./dotfiles/pluginrc;
      }
      // addHomeConfig "zsh/plugins/zsh-autocomplete" {
        source = pkgs.zsh-autocomplete;
      };
  };
}
