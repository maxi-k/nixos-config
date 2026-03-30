{
  hm = { addHomeBinary, addHomeConfig, ... }: {
    home.file = {}
      // addHomeConfig "shell/profile" {
        source = ./profile;
      }
      // addHomeConfig "shell/aliasrc" {
        source = ./aliasrc;
      }
      // addHomeBinary "select-recent-dir" {
        source = ./select-recent-dir;
        executable = true;
      };
  };
}
