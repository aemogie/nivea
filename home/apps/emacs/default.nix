{ pkgs, config, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
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
    ];

    extraConfig = ''
      ;; -*- lexical-binding: t; -*-
      ${builtins.readFile ./default.el}
      ${builtins.readFile ./binds.el}
      ${builtins.readFile ./look.el}
    '';
  };
  services.emacs.enable = false;
  # more saner env variables
  wayland.windowManager.hyprland.settings = {
     exec-once = [ "${config.programs.emacs.finalPackage}/bin/emacs --fg-daemon" ];
  };
}
