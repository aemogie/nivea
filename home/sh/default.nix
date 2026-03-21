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
    ./starship.nix
    ./direnv.nix
    ../../modules/typst.nix
  ];

  home.packages = [
    pkgs.fd
    pkgs.gnumake # why is this not builtin?
    pkgs.pass
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
      enableDefaultConfig = false;
      matchBlocks."*".addKeysToAgent = "yes";
    };
    gpg = {
      enable = true;
      settings.armor = true;
    };
  };
  services = {
    ssh-agent.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
  };
}
