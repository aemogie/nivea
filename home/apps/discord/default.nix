{
  pkgs,
  osConfig,
  config,
  ...
}@args:
let
  ctp = import ./ctp.nix args;
  midnight = pkgs.callPackage ./midnight.nix {
    inherit (osConfig.paint.active) palette;
    font = config.fonts.sans;
  };
in
{
  imports = [ ../../../modules/discord ];
  programs.discord = {
    enable = true;
    client = "webcord";
    style = midnight;

    openasar.config.openasar = {
      setup = true;
      quickstart = true;
      cmdPreset = "battery";
    };

    webcord = {
      package = pkgs.webcord;
      config = {
        settings = {
          general = {
            menuBar.hide = true;
            window.transparent = true;
          };
          privacy.permissions = {
            background-sync = true;
            notifications = true;
          };
        };
      };
      extensions = [
        (pkgs.runCommand "webcord_disable_menu_bar" { } ''
          mkdir $out
          cat <<EOF > $out/manifest.json
          ${builtins.toJSON {
            content_scripts = [
              {
                js = [ "disable_menu_bar.js" ];
                matches = [ "<all_urls>" ];
              }
            ];
            manifest_version = 3;
            name = "Disable Menu Bar";
            version = "0.1.0";
          }}
          EOF

          cat <<EOF > $out/disable_menu_bar.js
          ${
            #js
            ''
              document.addEventListener('keyup', e => { if (e.key == "Alt" || e.key == "Meta") e.preventDefault(); });
            ''}
          EOF
        '')
      ];
    };
  };
}
