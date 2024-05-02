{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (_: prev: {
      wezterm = prev.wezterm.overrideAttrs (
        old:
        let
          src = prev.fetchFromGitHub {
            owner = "wez";
            repo = "wezterm";
            rev = "fec90ae04bf448d4b1475ba1d0ba1392846a70d6";
            sha256 = "sha256-+FyAbPq7G644OOHBaDp5hS6u+NEvL5204EmaHdwvLpA=";
          };
        in
        {
          # FIXME: doesnt work, dissect
          # inherit src;
          # cargoDeps = prev.rustPlatform.importCargoLock {
          #   lockFile = "${src}/Cargo.lock";
          #   outputHashes = {
          #     "xcb-1.2.1" = "sha256-zkuW5ATix3WXBAj2hzum1MJ5JTX3+uVQ01R1vL6F1rY=";
          #     "xcb-imdkit-0.2.0" = "sha256-L+NKD0rsCk9bFABQF4FZi9YoqBHr4VAZeKAWgsaAegw=";
          #   };
          # };
          patches = (old.patches or [ ]) ++ [ ./custom_fancy_tabbar.patch ];
        }
      );
    })
  ];
  home.packages = [ pkgs.wezterm ];
}
