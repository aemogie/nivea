{ pkgs, osConfig, ... }:
{
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
    vencord = {
      useSystem = true;
      themes =
        let
          darkUrl =
            let
              inherit (osConfig.paint.dark.ctpCompat) flavor accent;
            in
            "https://catppuccin.github.io/discord/dist/catppuccin-${flavor}-${accent}.theme.css";
          lightUrl =
            let
              inherit (osConfig.paint.light.ctpCompat) flavor accent;
            in
            "https://catppuccin.github.io/discord/dist/catppuccin-${flavor}-${accent}.theme.css";
        in
        {
          catppuccin = pkgs.writeText "ctpCompat.css" ''
            @import url("${darkUrl}") (prefers-color-scheme: dark);
            @import url("${lightUrl}") (prefers-color-scheme: light);
          '';
        };
    };
  };
}
