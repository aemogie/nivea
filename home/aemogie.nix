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
      nerd-fonts.symbols-only
      corefonts
      helvetica-neue-lt-std
      carlito
      aporetic
    ];
    monospace = "Aporetic Sans Mono";
    serif = "Aporetic Serif";
    sans = "Aporetic Sans";
    fontconfig.enable = true;
  };
}
