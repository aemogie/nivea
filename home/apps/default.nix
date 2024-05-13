{ pkgs, ... }:
{
  imports = [
    ./gtk.nix
    ./firefox
    ./discord
    ./zathura.nix
    ./aseprite.nix
    ./spicetify
    ./foot.nix
    ./emacs
    ./scrcpy.nix
    # ./warp
    # ./wezterm
    # ./ue4.nix
  ];
  home.packages = [ pkgs.jetbrains.idea-community ];
}
