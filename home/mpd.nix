{ pkgs, lib, ... }:
{
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
  };
  systemd.user.services.mpd.Service.Slice = "background-graphical.slice";
  services.mpdris2-rs.enable = true;
  home.packages = [ ];
  programs.emacs.extraConfig =
    let
      mpc = lib.getExe pkgs.mpc;
    in
    ''
      (defun mpd-play-artist (artist)
        "Play an artist via MusicPD"
        (interactive (list
      		(completing-read "Select artist:"
      				 (split-string
      				  (if current-prefix-arg
      				      (shell-command-to-string "${mpc} -q list artist")
      				    ;; album artists just are a smaller list than artist
      				    (shell-command-to-string "${mpc} -q list albumartist"))
      				  "\n" t)
      				 nil t)))
        (message "%s" (string-trim
      		 (shell-command-to-string
      		  (string-join
      		   (list
      		    "${mpc} -q clear"
      		    (format "${mpc} -q findadd artist %s" (shell-quote-argument artist))
      		    "${mpc} -q shuffle"
      		    "${mpc} -q play"
      		    "${mpc} -q playlist")
      		   " && ")))))
    '';
}
