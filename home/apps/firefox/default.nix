{
  pkgs,
  config,
  osConfig,
  ...
}:
let
  inherit (osConfig.paint.active.palette) base text overlay0 crust;
  krabby-pkgs = pkgs.callPackage ./krabby.nix {
    krabby-config = pkgs.writeText "config.js" ''
      const { settings } = krabby

      settings['hint-style'] = {
        textColor: '#${crust}',
        activeCharacterTextColor: '#${overlay0}',
        backgroundColorStart: '#${text}',
        backgroundColorEnd: '#${text}',
        borderColor: '${crust}',
        fontSize: 17,
        fontFamilies: ['${config.fonts.monospace}'],
        fontWeight: 'normal',
      }
    '';
  };
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    profiles.old.id = 1;
    profiles.default = {
      name = "dev-edition-default";
      id = 0;
      settings =
        (if true then import ./privacy.nix else { })
        // {
          "devtools.chrome.enabled" = false; # the userChrome debugger (dont  need it rn)
          "browser.tabs.inTitlebar" = 0; # removes the close button, assumed to go from CSD to regular, but i dont hv titlebars
          "browser.tabs.closeWindowWithLastTab" = false;
          "ui.key.menuAccessKeyFocuses" = false; # disable the alt menu
          "privacy.query_stripping.enable" = true; # copy without site tracking
          "browser.tabs.maxOpenBeforeWarn" = 2;
          "browser.aboutConfig.showWarning" = false;
        }
        // {
          # downloads
          "browser.download.start_downloads_in_tmp_dir" = true;
          "browser.download.useDownloadDir" = false;
          "browser.download.always_ask_before_handling_new_types" = true;
        }
        // {
          # fake fullscreen
          "full-screen-api.ignore-widgets" = true;
          "full-screen-api.warning.timeout" = 0;
          "full-screen-api.transition.timeout" = 0;
        }
        // {
          # default theme colours
          "browser.display.foreground_color" = "#${text}";
          "browser.display.foreground_color.dark" = "#${text}";
          "browser.display.background_color" = "#${base}";
          "browser.display.background_color.dark" = "#${base}";
        }
        // {
          # default fonts
          "font.name.monospace.x-western" = config.fonts.monospace;
          "font.name.sans-serif.x-western" = config.fonts.sans;
          "font.name.serif.x-western" = config.fonts.serif;
          "font.default.x-western" = "sans-serif";
        }
        // {
          # overscroll. thanks, https://github.com/AbrarSL
          "apz.gtk.pangesture.delta_mode" = 2;
          "apz.gtk.pangesture.pixel_delta_mode_multiplier" = 25;
          "apz.fling_friction" = 4.0e-3;
          "apz.overscroll.enabled" = true;
        }
        // {
          # allow custom extensions
          "xpinstall.signatures.required" = false;
          "xpinstall.whitelist.required" = false;
        }
        // {
          # urlbar
          "browser.urlbar.suggest.trending" = false;
          "browser.urlbar.trimHttps" = true;
          "browser.urlbar.trimURLs" = true;
        }
        // {
          # disable "This time, search with" (part 1, see settings for rest)
          "browser.urlbar.shortcuts.bookmarks" = false;
          "browser.urlbar.shortcuts.history" = false;
          "browser.urlbar.shortcuts.quickactions" = false;
          "browser.urlbar.shortcuts.tabs" = false;
        }
        // {
          # the layout of the tabbar, urlbar and extension flyout
          "browser.uiCustomization.state" = builtins.toJSON (import ./ui.nix);
        };
      search = {
        force = true;
        default = "Google";
        engines = {
          # disable "This time, search with" (part 2, see settings for rest)
          "Bing".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
      };
      extensions = [
        (
          let
            manifest = import ./theme.nix {
              light = osConfig.paint.light.palette;
              dark = osConfig.paint.dark.palette;
            };
          in
          pkgs.stdenv.mkDerivation {
            pname = "paintnix-theme";
            version = manifest.version;
            nativeBuildInputs = [ pkgs.zip ];
            src = pkgs.writeTextDir "manifest.json" (builtins.toJSON manifest);
            buildCommand = ''
              dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
              mkdir -p $dst
              zip -jr "$dst/${manifest.browser_specific_settings.gecko.id}.xpi" $src/*
            '';
          }
        )
        krabby-pkgs.webextension-commands
        krabby-pkgs.krabby
      ];
    };
  };
}
