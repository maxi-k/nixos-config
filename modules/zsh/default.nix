{ pkgs, ... }:

{
  hm = { config, ... }: {
    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd" "z" ];
    };

    home.file = {
      ".zprofile".source = ./dotfiles/.zprofile;
      ".config/zsh/.zshrc".source = ./dotfiles/.zshrc;
      ".config/zsh/lookrc".source = ./dotfiles/lookrc;
      ".config/zsh/keyrc".source = ./dotfiles/keyrc;
      ".config/zsh/toolrc".source = ./dotfiles/toolrc;
      ".config/zsh/pluginrc".source = ./dotfiles/pluginrc;
      ".config/zsh/plugins/zsh-autocomplete".source = pkgs.zsh-autocomplete;
    };
  };
}
