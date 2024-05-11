{ pkgs, osConfig, ... }:
{
  imports = [ ../../../modules/spicetify ];
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
          rev = "d3c4b697f1739149684e36977a1502f88c344b3a";
          sha256 = "sha256-VxkgW9qF1pmKnP7Ei7gobF0jVB1+qncfFeykWoXMRCo=";
        }
        + /catppuccin;
      colorScheme = osConfig.paint.active.ctpCompat.flavor;
    };
    extensions = [
      (
        pkgs.stdenv.mkDerivation {
          name = "spicetify-adblock.js";
          src = pkgs.fetchFromGitHub {
            owner = "CharlieS1103";
            repo = "spicetify-extensions";
            rev = "d618561c232f02a56223bae6276fc9fd8c6a357a";
            sha256 = "sha256-hha+Bs+bofIFBWw8331u4BaHyspdOJl/9gkS7aL/lYw=";
          };
          patches = [ ./adblockjs.patch ];
          installPhase = ''
            mkdir $out
            cp adblock/adblock.js $out
          '';
        }
        + /adblock.js
      )
      (
        pkgs.fetchFromGitHub {
          owner = "kyrie25";
          repo = "spicetify-utilities";
          rev = "af53aabc63b8d197b952f4ecb0e4252ee79eca26";
          sha256 = "sha256-LZcrmoA+SOpTeTiBeiOtneojzBhvbZfkawTyFRLhNk8=";
        }
        + /utilities.js
      )
    ];
    custom_apps = [ "${pkgs.spicetify-cli}/bin/CustomApps/lyrics-plus" ];
  };
}
