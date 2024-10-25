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
            rev = "7ed6a5033639540e68068e17c4e3613026f3bf82";
            sha256 = "sha256-BQu0pUHUj94F4SY6om0yW+PIftTvwJO6BO3osQ02RXg=";
          };
        in
        # TODO: use prefers-color-scheme
        [ "${ctp}/src/${osConfig.paint.active.ctpCompat.flavor}.css" ];
    };
    plugins = {
      adblocker.enabled = true;
      shortcuts.enabled = true;
      sponsorblock.enabled = true;
      video-toggle = {
        enabled = true;
        hideVideo = true;
      };
      synced-lyrics.enabled = true;
      downloader.enabled = true;
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
    mkdir -p "${config.xdg.configHome}/YouTube Music/"
    cat << EOF > "${config.xdg.configHome}/YouTube Music/config.json"
    ${builtins.toJSON text}
    EOF
  '';
}
