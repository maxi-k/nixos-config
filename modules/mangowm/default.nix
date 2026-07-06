{ config, lib, pkgs, ... }:

# let
#   mango = pkgs.mango.overrideAttrs (oldAttrs: {
#     patches = (oldAttrs.patches or [ ]) ++ [
#       (pkgs.fetchpatch {
#         url = "https://patch-diff.githubusercontent.com/raw/mangowm/mango/pull/676.diff";
#         hash = "sha256-wRQiF2BHFHEipeU3K2gtBgm/Xr+oz9KfETJgCfttaoI=";
#       })
#     ];
#   });
# in
{
  programs.mangowc.enable = true;
  # programs.mangowc.package = mango;
}
