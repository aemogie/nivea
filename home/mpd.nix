{
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
  };
  systemd.user.services.mpd.Services.Slice = "background.slice";
}
