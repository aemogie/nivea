{
  inputs,
  pkgs,
  config,
  ...
}:
{
  systemd.user.sessionVariables = {
    TYPST_FONT_PATHS = pkgs.symlinkJoin {
      name = "typst-ready-fonts";
      paths = config.fonts.packages;
    };
  };
  programs.helix.languages = {
    language = [
      {
        name = "typst";
        language-servers = [ "tinymist" ];
      }
    ];
    language-server.tinymist.command = "tinymist";
  };
}
