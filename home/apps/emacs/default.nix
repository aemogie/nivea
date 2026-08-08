{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages = epkgs: [
      epkgs.catppuccin-theme
      epkgs.meow
      epkgs.kakoune
      epkgs.multiple-cursors
      epkgs.treesit-grammars.with-all-grammars
      epkgs.expreg
      epkgs.disable-mouse
      epkgs.eat
      epkgs.vertico
      epkgs.marginalia
      epkgs.nix-ts-mode
      epkgs.magit
      epkgs.envrc
      epkgs.corfu
      epkgs.orderless
      epkgs.org-modern
      epkgs.kotlin-mode
      epkgs.tramp
      epkgs.geiser
      epkgs.geiser-guile
      epkgs.paredit
      epkgs.rainbow-delimiters
      epkgs.guix
      epkgs.spacious-padding
      epkgs.typst-ts-mode
      epkgs.ox-typst
      epkgs.page-break-lines
      epkgs.writeroom-mode
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
