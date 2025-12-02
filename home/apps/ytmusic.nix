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
      likeButtons = "force";
      themes =
        let
          ctp = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "youtubemusic";
            rev = "dc35fc46232e389ff761adec8242f956af405880";
            sha256 = "sha256-K5iwNBA/6/JDmmt/u9Dnsk0lvWY12YpY+BIScrRaDGw=";
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
      synced-lyrics = {
        enabled = true;
        preferredProvider = "LRCLib";
        romanization = true;
      };
      downloader.enabled = true;
      notifications.enabled = true;
      unobtrusive-player.enabled = true;
      discord.enabled = true;
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
