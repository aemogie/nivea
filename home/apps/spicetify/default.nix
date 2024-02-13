{pkgs, ...}: {
  imports = [../../../modules/spicetify];
  programs.spicetify = {
    enable = true;
    config = {
      Setting = {
        inject_css = true;
        inject_theme_js = true;
        replace_colors = true;
        overwrite_assets = true;
        # TODO: wayland support maybe?
        # spotify_launch_flags = [""];
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
          rev = "39ce773553e0dbc5ecb3dc91c59b03f905e95f88";
          sha256 = "sha256-Gmj6vh1smkH+CW7eqoHsDxDMh5hk1wa8LbW+RMPsTL8=";
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
  };

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "workspace special,title:Spotify"
  ];
}
