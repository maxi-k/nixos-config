{ config, lib, pkgs, ... }:

let
  mangowc = pkgs.mangowc.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/mangowm/mango/pull/676.diff";
        hash = "sha256-dxDsTbSSRZp3gIizO7Q5XLHqsJfENTy97ZOkc2emrWU=";
      })
    ];
  });
in
{
  programs.mangowc.enable = true;
  programs.mangowc.package = mangowc;
}
