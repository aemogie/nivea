{
  services.syncthing = {
    enable = true;
    user = "aemogie";
    dataDir = "/home/aemogie/sync";
    configDir = "/home/aemogie/.config/syncthing";
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}
