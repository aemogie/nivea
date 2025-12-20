{ pkgs, ... }:
{
  imports = [
    ./gtk.nix
    ./firefox
    ./discord.nix
    ./zathura.nix
    ./aseprite.nix
    ./foot.nix
    ./emacs
    ./scrcpy.nix
    ./ytmusic.nix
  ];
  home.packages = [
    # pkgs.jetbrains.idea-community
    # pkgs.lutris
    # pkgs.winetricks
    pkgs.wineWowPackages.waylandFull
    pkgs.vial
  ];
}
