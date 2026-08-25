{ pkgs, lib', ... }:
{
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
  };
  systemd.user.services.mpd.Service.Slice = "app-graphical.slice";
  # playerctl -F metadata -f 'notify-send -i "{{mpris:artUrl}}" "{{emoji(status)}} {{title}}" "{{artist}}"' | bash
  services.mpdris2-rs.enable = true;
  systemd.user.services.mpdris2-rs.Service.Slice = "background-graphical.slice";
  home.packages = [ pkgs.mpc ];
  programs.emacs.use-package.emacs.config' =
    let
      inherit (lib'.elisp)
        defun
        call
        var
        if'
        ;
      shell-command-to-string = call "shell-command-to-string";
      buildMpcFilters =
        filters:
        lib'.escapeShellArg "(${
          lib'.concatMapAttrsStringSep " AND " (
            tag: regex: "(${tag} =~ ${lib'.toJSON regex})"
          ) filters
        })";
      commonFilters = {
        filename = ".flac$";
      };
    in
    defun {
      name = "mpd-play-artist";
      args = [ "artist" ];
      docstring = "Play an artist via MusicPD";
      interactive.artist =
        let
          artistCmd = "${lib'.getExe pkgs.mpc} -q list artist ${buildMpcFilters commonFilters}";
          albumArtistCmd = "${lib'.getExe pkgs.mpc} -q list albumartist ${buildMpcFilters commonFilters}";
        in
        call "completing-read" "Select artist:" (call "split-string" (if'
          (var "current-prefix-arg")
          (shell-command-to-string artistCmd)
          # album artists just are a smaller list than artist
          (shell-command-to-string albumArtistCmd)
        ) "\n" true) false true;
      body =
        { artist }:
        let
          artist' = call "shell-quote-argument" (call "regexp-quote" artist);
          cmdSeq = [
            "${lib'.getExe pkgs.mpc} -q clear"
            "${lib'.getExe pkgs.mpc} -q findadd ${
              buildMpcFilters (commonFilters // { artist = "^%s$"; })
            }"
            "${lib'.getExe pkgs.mpc} -q shuffle"
            "${lib'.getExe pkgs.mpc} play"
          ];
          cmd = call "format" (lib'.concatStringsSep " && " cmdSeq) artist';
        in
        call "message" "%s" (call "string-trim" (shell-command-to-string cmd));
    };
}
