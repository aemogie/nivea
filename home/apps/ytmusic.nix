{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  text = {
    options = {
      autoUpdates = false;
      hideMenu = true;
      hideMenuWarned = true;
      removeUpgradeButton = true;
      resumeOnStart = true;
      restartOnConfigChanges = true;
      tray = true;
      themes =
        let
          ctp = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "youtubemusic";
            rev = "546293136a326394f7e528a125b012479dfaf642";
            sha256 = "sha256-eQCOE2SIlHhAkY/RK4EVs9Uoi7/OyjekAsHTFhPJC7U=";
          };
        in
        # TODO: use prefers-color-scheme
        [ "${ctp}/src/${osConfig.paint.active.ctpCompat.flavor}.css" ];
    };
    plugins = {
      adblocker.enabled = true;
      # not sure if this does much but
      lyrics-genius.enabled = true;
      shortcuts.enabled = true;
      sponsorblock.enabled = true;
      video-toggle.enabled = true;
    };
    __internal__.migrations = {
      inherit (pkgs.youtube-music) version;
    };
  };
in
{
  home.packages = [ pkgs.youtube-music ];
  # crashes on read-only
  home.activation.ytmusicConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.xdg.configHome}/YouTube Music"
    cat << EOF > "${config.xdg.configHome}/YouTube Music/config.json"
    ${builtins.toJSON text}
    EOF
  '';
}
