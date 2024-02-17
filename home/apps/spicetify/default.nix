{
  pkgs,
  lib,
  inputs,
  ...
}: let
  _ = {
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
        (pkgs.fetchFromGitHub {
            owner = "kyrie25";
            repo = "spicetify-utilities";
            rev = "af53aabc63b8d197b952f4ecb0e4252ee79eca26";
            sha256 = "sha256-LZcrmoA+SOpTeTiBeiOtneojzBhvbZfkawTyFRLhNk8=";
          }
          + "/utilities.js")
      ];
      # extraCommands = ''
      #   HOME=/home/aemogie spicetify-cli enable-devtools
      # '';
    };

    # nix.settings.sandbox = false;
  };
in {
  imports = [inputs.spicetify.homeManagerModule];
  programs.spicetify = let
    spicePkgs = inputs.spicetify.spicePkgs.${pkgs.system};
  in {
    enable = true;
    theme =
      spicePkgs.themes.catppuccin
      // {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "spicetify";
          rev = "8717687db9ddcae758f88224295bbe732d8ff724";
          sha256 = "sha256-BU/M1hRIyju2mQGZKCvpR4JpRBGjJzCcnnty4ypJjDs=";
        };
      };
    colorScheme = "mocha";
    enabledExtensions = with spicePkgs.extensions; [
      {
        src = pkgs.fetchFromGitHub {
          owner = "kyrie25";
          repo = "spicetify-utilities";
          rev = "af53aabc63b8d197b952f4ecb0e4252ee79eca26";
          sha256 = "sha256-LZcrmoA+SOpTeTiBeiOtneojzBhvbZfkawTyFRLhNk8=";
        };
        filename = "utilities.js";
      }
      adblock
      fullAppDisplay
      keyboardShortcut
      autoSkipVideo
    ];
  };
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "workspace special,title:Spotify"
  ];
}
