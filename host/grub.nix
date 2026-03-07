{
  pkgs,
  config,
  fetched,
  ...
}:
{
  # thanks to github.com/Stonks3141/ctp-nix
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub =
        let
          theme = pkgs.runCommand "catppuccin-grub-theme" { } ''
            mkdir -p "$out"
            cp -r ${fetched.catppuccin.grub}/src/catppuccin-${config.paint.dark.ctpCompat.flavor}-grub-theme/* "$out"/
          '';
        in
        {
          enable = true;
          inherit theme;
          splashImage = "${theme}/background.png";
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
          extraEntries = ''
            menuentry 'aetheria.' --class guix {
              search --set --label BOOTTMP
              configfile /grub/grub.cfg
            }

            menuentry 'ruina.' --class windows {
              insmod part_gpt
              insmod fat
              search --set=root --label ruinaboot
              chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            }
          '';
          gfxmodeBios = "auto";
          gfxmodeEfi = "auto";
          gfxpayloadBios = "keep";
          gfxpayloadEfi = "keep";
          font = "${pkgs.aporetic}/share/fonts/truetype/aporetic-sans-normalregularupright.ttf";
          fontSize = 16;
        };
    };
    # suppress all messeges
    kernelParams = [
      "quiet"
      "splash"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
