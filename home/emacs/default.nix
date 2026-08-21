{ pkgs, ... }:
{
  imports = [
    ../../modules/emacs
    ./simple.nix
    ./binds.nix
    ./look.nix
    ./term.nix
  ];
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
  };
  services.emacs = {
    enable = true;
    defaultEditor = true;
    startWithUserSession = "graphical";
  };
  systemd.user.services.emacs.Service.Slice = "app-graphical.slice";
}
