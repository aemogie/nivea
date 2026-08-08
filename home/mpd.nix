{ pkgs, lib, ... }:
{
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
  };
  systemd.user.services.mpd.Service.Slice = "app-graphical.slice";
  services.mpdris2-rs.enable = true;
  systemd.user.services.mpdris2-rs.Service.Slice = "background-graphical.slice";
  home.packages = [ pkgs.mpc ];
  programs.emacs.extraConfig = ''
    (defun mpd-play-artist (artist)
      "Play an artist via MusicPD"
      (interactive (list
                    (completing-read "Select artist:"
                                     (split-string
                                      (if current-prefix-arg
                                          (shell-command-to-string "${lib.getExe pkgs.mpc} -q list artist")
                                        ;; album artists just are a smaller list than artist
                                        (shell-command-to-string "${lib.getExe pkgs.mpc} -q list albumartist"))
                                      "\n" t)
                                     nil t)))
      (message "%s" (string-trim
                     (shell-command-to-string
                      (string-join
                       (list
                        "${lib.getExe pkgs.mpc} -q clear"
                        (format "${lib.getExe pkgs.mpc} -q findadd artist %s" (shell-quote-argument artist))
                        "${lib.getExe pkgs.mpc} -q shuffle"
                        "${lib.getExe pkgs.mpc} play")
                       " && ")))))
  '';
}
