# Grok Bot desktop app + grokbot-popup helpers (niri keybinds live in
# modules/niri/config.kdl: Mod+Slash toggle, Mod+Ctrl+Slash pick).
#
# Both packages come from the local flakes in ~/dev/grokbot (flake inputs
# `grok-bot` and `grokbot-popup`). The Grok Bot .deb is pulled in via
# requireFile and must be added to the nix store once, by hand:
#
#   nix-store --add-fixed sha256 ~/dev/grokbot/vendor/grok-bot_0.61.0_amd64.deb
{ config, lib, pkgs, inputs, system, ... }:

let
  cfg = config.repo.grokbot;
  grokBot = inputs.grok-bot.packages.${system}.grok-bot;
  grokPopup = inputs.grokbot-popup.packages.${system}.grokbot-popup;
in
{
  options.repo.grokbot.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Whether to install the Grok Bot desktop app and the grokbot-popup helpers.";
  };

  config = lib.mkIf cfg.enable {
    # grok-bot ships its own .desktop entry (incl. the grokbot:// handler)
    environment.systemPackages = [ grokBot grokPopup ];
  };
}
