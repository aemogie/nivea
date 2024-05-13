{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  replaceVars =
    vars:
    lib.replaceStrings (map (k: "@${k}@") (builtins.attrNames vars)) (
      map toString (builtins.attrValues vars)
    );
in
{
  programs.nushell.extraConfig =
    #nu
    ''
      ${replaceVars osConfig.paint.active.palette (lib.fileContents ./theme.nu)}
      $env.LS_COLORS = (${lib.getExe pkgs.vivid} generate catppuccin-${osConfig.paint.active.ctpCompat.flavor})
      ${replaceVars {
        z_editor_tab = config.programs.zellij.layouts.editor.command.new-tab;
        z_editor_new = config.programs.zellij.layouts.editor.command.new-session;
      } (lib.fileContents ./config.nu)}
    '';
}
