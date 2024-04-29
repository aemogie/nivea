{
  pkgs,
  lib,
  config,
  ...
}: let
  replaceVars = vars: lib.replaceStrings (map (k: "@${k}@") (builtins.attrNames vars)) (map toString (builtins.attrValues vars));
in {
  programs.nushell.extraConfig = replaceVars {
    nixfmt = "${lib.getExe pkgs.alejandra} -q";
    pager = lib.getExe pkgs.less;
    z_editor_tab = config.programs.zellij.layouts.editor.command.new-tab;
    z_editor_new = config.programs.zellij.layouts.editor.command.new-session;
    langs = ./languages.json;
  } (lib.fileContents ./config.nu);
}
