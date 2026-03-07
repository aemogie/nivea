{
  pkgs,
  osConfig,
  fetched,
  ...
}:
let
  inherit (osConfig.paint.active.ctpCompat) flavor;
in
{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      # add_newline = false;
      palette = "catppuccin_${flavor}";
      # format = "$fill$line_break$all$line_break$character";
      # fill = {
      #   style = "surface2";
      #   symbol = "─";
      # };
    }
    // fromTOML (
      builtins.readFile "${fetched.catppuccin.starship}/themes/${flavor}.toml"
    );
  };
}
