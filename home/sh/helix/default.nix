{
  inputs,
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  imports = [
    # ./typst.nix
    ./nil.nix
    # ./nushell.nix
  ];
  programs.helix =
    let
      inherit (osConfig.paint.active.ctpCompat) flavor;
    in
    {
      enable = true;
      package = inputs.helix.packages.${pkgs.system}.helix;
      defaultEditor = true;
      settings = {
        editor = {
          auto-save = false; # just got annoying
          # bufferline = "multiple";
          completion-replace = true;
          completion-trigger-len = 0;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          cursorline = true;
          indent-guides.render = true;
          lsp = {
            display-inlay-hints = true;
            display-messages = true;
          };
          shell = config.home.loginShell.cmd;
          soft-wrap = {
            enable = false;
            wrap-at-text-width = true;
          };
          smart-tab.supersede-menu = true;
        };
        keys = {
          insert = {
            j.j = "normal_mode";
            j.k = "normal_mode";
          };
          normal = {
            H = ":buffer-previous";
            K = "hover";
            L = ":buffer-next";
            space = {
              c = ":buffer-close";
              q = ":quit";
              tab = ":buffer-next";
              w = ":write";
              f = "file_picker_in_current_directory";
              F = "no_op";
            };
          };
        };
        theme = "catppuccin_${flavor}_transparent";
      };

      themes."catppuccin_${flavor}_transparent" = {
        inherits = "catppuccin_${flavor}";
        "ui.background" = { };
        "ui.cursorline.primary" = { };
      };

      languages = {
        language-server = {
          # rust-analyzer expects cargo to be in $PATH. idk how to cleanly handle it, maybe wrapper?
          # rust-analyzer.command = lib.getExe pkgs.rust-analyzer;
          # lua-language-server.command = "${pkgs.lua-language-server}/bin/lua-language-server";
        };
      };
    };
}
