{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.catppuccin-papirus-folders.override {
      accent = "mauve";
      flavor = "mocha";
    })
    (pkgs.catppuccin-gtk.override {
      accents = ["mauve"];
      variant = "mocha";
    })
    pkgs.catppuccin-cursors.mochaDark
  ];
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ../../assets/street.png;
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
        font_name = "Iosevka Aile 11";
        cursor_theme_name = "Catppuccin-Mocha-Dark-Cursors";
        theme_name = "Catppuccin-Mocha-Standard-Mauve-Dark";
        icon_theme_name = "Papirus-Dark";
      };
    };
  };
}
