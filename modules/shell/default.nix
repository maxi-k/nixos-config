{
  hm.home.file = {
    ".config/shell/profile".source = ./profile;
    ".config/shell/aliasrc".source = ./aliasrc;
    ".local/bin/select-recent-dir" = {
      source = ./select-recent-dir;
      executable = true;
    };
  };
}
