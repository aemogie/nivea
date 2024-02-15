{
  pkgs,
  lib,
  ...
}: {
  imports = [../../../modules/spicetify];
  programs.spicetify = {
    enable = true;
    config = {
      Setting = {
        inject_css = true;
        inject_theme_js = true;
        replace_colors = true;
        overwrite_assets = true;
      };
      AdditionalOptions = {
        sidebar_config = false;
        home_config = false;
        experimental_features = true;
      };
    };
    theme = {
      enable = true;
      path =
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "spicetify";
          rev = "8717687db9ddcae758f88224295bbe732d8ff724";
          sha256 = "sha256-BU/M1hRIyju2mQGZKCvpR4JpRBGjJzCcnnty4ypJjDs=";
        }
        + "/catppuccin";
      colorScheme = "mocha";
    };
    extensions = [
      (pkgs.fetchFromGitHub {
          owner = "CharlieS1103";
          repo = "spicetify-extensions";
          rev = "d618561c232f02a56223bae6276fc9fd8c6a357a";
          sha256 = "sha256-hha+Bs+bofIFBWw8331u4BaHyspdOJl/9gkS7aL/lYw=";
        }
        + "/adblock/adblock.js")
    ];
    # extraCommands = ''
    #   HOME=/home/aemogie spicetify-cli enable-devtools
    # '';
  };

  # nix.settings.sandbox = false;

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "workspace special,title:Spotify"
  ];
}
