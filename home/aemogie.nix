{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports =
    [
      ../modules/fonts.nix
      ../modules/typst.nix
    ]
    ++ [
      ./wm/hyprland
      ./wm/swww.nix
      ./wm/waybar
      ./wm/anyrun
      ./wm/mako.nix
      ./wm/swaylock.nix
    ]
    ++ [
      ./sh/git.nix
      ./sh/helix
      ./sh/bat.nix
      ./sh/nushell
      ./sh/zellij.nix
      ./sh/yazi
      ./sh/starship.nix
      ./sh/direnv.nix
    ]
    ++ [
      ./apps/gtk.nix
      ./apps/firefox
      ./apps/discord
      ./apps/zathura.nix
      ./apps/aseprite.nix
      ./apps/spicetify
      ./apps/foot.nix
      ./apps/emacs.nix
      ./apps/scrcpy.nix
      # ./apps/warp
      # ./apps/wezterm
      # ./apps/ue4.nix
    ];

  nix.settings.warn-dirty = false;

  # refactor
  home.packages = [
    pkgs.jetbrains.idea-community
    pkgs.wl-clipboard # wl-copy/wl-paste
    pkgs.fd
  ];

  # this as well. maybe to ../tui?
  home.shellAliases = {
    # `clear` on nushell doesn't clear scrollback
    s = "switch";
    c = "printf '\\e[H\\e[2J\\e[3J'";
    cc = "printf '\\e[H\\e[2J\\e[3J'";
    l = "ls -la";
    o = lib.getExe pkgs.bat;
    fk = "cd ${config.home.homeDirectory}/dev/flake";
    q = "exit";
    qq = "exit";
  };

  programs = {
    tealdeer.enable = true;
    ripgrep.enable = true;
    typst.enable = true;
  };

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
