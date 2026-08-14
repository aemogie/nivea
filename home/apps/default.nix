{ pkgs, ... }:
{
  imports = [
    ./firefox
    ./discord.nix
    ./zathura.nix
    ./aseprite.nix
    ./foot.nix
    ./scrcpy.nix
    ./ytmusic.nix
  ];
  home.packages = [
    # pkgs.jetbrains.idea-community
    # pkgs.lutris
    # pkgs.winetricks
    pkgs.wineWow64Packages.waylandFull
    pkgs.vial
    pkgs.mpv
  ];
}
