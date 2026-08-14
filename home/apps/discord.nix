{ pkgs, osConfig, ... }:
{
  services.arrpc.enable = true;
  programs.vesktop = {
    enable = true;
    settings = {
      enableSplashScreen = true;
      splashTheming = true;
      splashBackground = "#${osConfig.paint.active.palette.base}";
      splashColor = "#${osConfig.paint.active.palette.text}";
      splashPixelated = true;
      enabledThemes = [ "catppuccin.css" ];
    };
    vencord.themes.catppuccin =
      let
        line =
          { isDark, ctpCompat, ... }:
          let
            color-scheme = if isDark then "dark" else "light";
            file = "catppuccin-${ctpCompat.flavor}-${ctpCompat.accent}.theme.css";
            url = "https://catppuccin.github.io/discord/dist/${file}";
          in
          "@import url(${url}) (prefers-color-scheme: ${color-scheme});";
      in
      pkgs.writeText "ctpCompat.css" ''
        ${line osConfig.paint.dark}
        ${line osConfig.paint.light}
      '';
  };
}
