{ pkgs, ... }:
{
  imports = [
    ./sh
    ./apps
    ./wm
    # TODO: use snowfall
    ../modules/fonts.nix
  ];

  # misc
  fonts = {
    packages = with pkgs; [
      iosevka-bin
      (iosevka-bin.override { variant = "Aile"; })
      (iosevka-bin.override { variant = "Etoile"; })
      twitter-color-emoji
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      corefonts
      helvetica-neue-lt-std
      carlito
    ];
    monospace = "Iosevka Term";
    serif = "Iosevka Etoile";
    sans = "Iosevka Aile";
    fontconfig.enable = true;
  };
}
