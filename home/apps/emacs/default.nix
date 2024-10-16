{ pkgs, config, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages = epkgs: [
      epkgs.catppuccin-theme
      epkgs.meow
      epkgs.kakoune
      epkgs.treesit-grammars.with-all-grammars
      epkgs.disable-mouse
      epkgs.eat
      epkgs.vertico
      epkgs.marginalia
      epkgs.nix-mode
      epkgs.magit
      epkgs.envrc
      epkgs.corfu
      epkgs.orderless
      epkgs.org-modern
      epkgs.kotlin-mode
      epkgs.tramp
    ];

    extraConfig = ''
      ;; -*- lexical-binding: t; -*-
      ${builtins.readFile ./default.el}
      ${builtins.readFile ./binds.el}
      ${builtins.readFile ./look.el}
      ${builtins.readFile ./commands.el}
      ${builtins.readFile ./term.el}
      ${builtins.readFile ./eshell-frame.el}
    '';
  };
  services.emacs = {
    enable = true;
    defaultEditor = true;
    startWithUserSession = "graphical";
  };
}
