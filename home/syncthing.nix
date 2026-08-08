{
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    settings =
      let
        devices = {
          valina.id = "YAIG4U3-FLLXZNS-H3TW6PH-YGZHENZ-PB3JP32-AWXZDTL-XF5IRHX-KAUR3QH";
        };
        defaultDevices = builtins.attrNames devices; # all devices
        folders = {
          "~/Music".id = "f081e-vg3jz";
          "~/.password-store".id = "z6fh0-gvxw0";
          "~/sync/common".id = "7scf4-8mjf8";
          "~/sync/backups".id = "hvwag-fx4gj";
          "~/sync/org".id = "p4kup-1v2k5";
          "~/sync/px".id = "u7cxz-qyjfy";
        };
      in
      {
        inherit devices;
        folders = builtins.mapAttrs (
          _: f: f // { devices = f.devices or defaultDevices; }
        ) folders;
        options = {
          urAccepted = -1;
          localAnnounceEnabled = true;
        };
      };
  };
  systemd.user.services.syncthing.Services.Slice = "background.slice";
}
