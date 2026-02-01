{ pkgs, config, fetched, ... }:
{
  boot.plymouth = {
    enable = false;
    theme = "catppuccin-${config.paint.active.ctpCompat.flavor}";
    themePackages = [
      (pkgs.stdenv.mkDerivation {
        name = "catppuccin-plymouth";

        src = fetched.catppuccin.plymouth;

        # github:nekowinston/nur
        installPhase = ''
          mkdir -p "$out/share/plymouth/themes/"
          cp -r "themes/"* "$out/share/plymouth/themes/"

          themes=("mocha" "macchiato" "frappe" "latte")
          for dir in "''${themes[@]}"; do
            cat "themes/catppuccin-''${dir}/catppuccin-''${dir}.plymouth" | sed "s@\/usr\/@''${out}\/@" > "''${out}/share/plymouth/themes/catppuccin-''${dir}/catppuccin-''${dir}.plymouth"
          done
        '';
      })
    ];
  };
}
