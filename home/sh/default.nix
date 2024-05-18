{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./git.nix
    ./helix
    ./bat.nix
    ./nushell
    ./zellij.nix
    ./yazi
    ./starship.nix
    ./direnv.nix
    ./runbg.nix
    # TODO: use snowfall
    ../../modules/typst.nix
  ];

  home.packages = [
    pkgs.wl-clipboard # wl-copy/wl-paste
    pkgs.fd
  ];

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
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };
  };
  services.ssh-agent.enable = true;
}
