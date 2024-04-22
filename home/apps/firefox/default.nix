{
  pkgs,
  osConfig,
  ...
}: {
  /*
  wayland.windowManager.hyprland.settings.windowrulev2 =
    [
      ''opacity 1 override,class:firefox,title:^(.*\[.*\b(youtube\.com|twitch\.tv)\] — Mozilla Firefox)''
      ''opacity 0.9 override,class:firefox,title:^(?!.*\[.*\b(youtube\.com|twitch\.tv)\] — Mozilla Firefox)''
    ]
    ++ (let
      hCfg = config.wayland.windowManager.hyprland.settings;
      inherit (hCfg.general) gaps_out;
    in [
      ''float,class:firefox,title:^(Picture-in-Picture)''
      ''move 100%-${toString gaps_out} 100%-${toString gaps_out},class:firefox,title:^(Picture-in-Picture)''
      ''pin,class:firefox,title:^(Picture-in-Picture)''
      ''nofocus,class:firefox,title:^(Picture-in-Picture)''
    ]);
  */
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    /*
    .override {
      extraPrefs = let
        reloadStylesheets =
          #js https://gist.github.com/jscher2000/ad268422c3187dbcbc0d15216a3a8060
          ''
            var ss = Cc["@mozilla.org/content/style-sheet-service;1"].getService(Ci.nsIStyleSheetService);

            var dir = Services.dirsvc.get("UChrm", Ci.nsIFile);

            var chrome = dir.clone();chrome.append("userChrome.css");
            chrome = Services.io.newFileURI(chrome);

            var content = dir.clone();content.append("userContent.css");
            content = Services.io.newFileURI(content);

            setInterval(() => {
              // Unregister the sheet
              if (ss.sheetRegistered(chrome, ss.USER_SHEET)) {
                ss.unregisterSheet(chrome, ss.USER_SHEET);
              }
              ss.loadAndRegisterSheet(chrome, ss.USER_SHEET);

              if (ss.sheetRegistered(content, ss.USER_SHEET)) {
                ss.unregisterSheet(content, ss.USER_SHEET);
              }
              ss.loadAndRegisterSheet(content, ss.USER_SHEET);
            }, 1000);
          '';
        fxAutoconfig =
          #js github:MrOtherGuy/fx-autoconfig
          ''
            try {
              let cmanifest = Cc['@mozilla.org/file/directory_service;1'].getService(Ci.nsIProperties).get('UChrm', Ci.nsIFile);
              cmanifest.append('utils');
              cmanifest.append('chrome.manifest');

              if (cmanifest.exists()){
                Components.manager.QueryInterface(Ci.nsIComponentRegistrar).autoRegister(cmanifest);
                ChromeUtils.importESModule('chrome://userscript/content/boot.sys.mjs');
              }
            } catch(ex) {};
          '';
      in "";

      extraPolicies.ExtensionSettings = let
        theme = let
          manifest = import ./theme.nix {
            light = osConfig.paint.light.pal;
            dark = osConfig.paint.dark.pal;
          };
        in
          pkgs.stdenv.mkDerivation {
            pname = "paintnix-theme";
            version = manifest.version;
            nativeBuildInputs = [pkgs.zip];
            src = pkgs.writeTextDir "manifest.json" (builtins.toJSON manifest);
            addonId = manifest.browser_specific_settings.gecko.id;
            buildCommand = ''
              mkdir $out
              zip -jr $out/$addonId.xpi $src/*
            '';
          };
      in {
        ${theme.addonId} = {
          install_url = "file://${theme}/${theme.addonId}.xpi";
          installation_mode = "force_installed";
        };
      };
    };
    */
    profiles.old.id = 1;
    profiles.default = {
      name = "dev-edition-default";
      id = 0;
      settings = let
        inherit (osConfig.paint.active.pal) base text;
      in
        {
          "browser.download.useDownloadDir" = true;
          "devtools.chrome.enabled" = true; # allow running the userChrome debugger
          "browser.tabs.inTitlebar" = 0; # removes the close button, assumed to go from CSD to regular, but i dont hv titlebars
          "browser.tabs.closeWindowWithLastTab" = false;
          "ui.key.menuAccessKeyFocuses" = false; # disable the alt menu
          "privacy.query_stripping.enable" = true; # copy without site tracking
        }
        // {
          # fullscreen
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
          # overscroll. thanks, @AbrarSL
          "apz.gtk.pangesture.delta_mode" = 2;
          "apz.gtk.pangesture.pixel_delta_mode_multiplier" = 25;
          "apz.fling_friction" = 0.004;
          "apz.overscroll.enabled" = true;
        }
        // {
          "xpinstall.signatures.required" = false;
          "xpinstall.whitelist.required" = false;
        };
      extensions = [
        (
          let
            manifest = import ./theme.nix {
              light = osConfig.paint.light.pal;
              dark = osConfig.paint.dark.pal;
            };
          in
            pkgs.stdenv.mkDerivation {
              pname = "paintnix-theme";
              version = manifest.version;
              nativeBuildInputs = [pkgs.zip];
              src = pkgs.writeTextDir "manifest.json" (builtins.toJSON manifest);
              buildCommand = ''
                dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
                mkdir -p $dst
                zip -jr "$dst/${manifest.browser_specific_settings.gecko.id}.xpi" $src/*
              '';
            }
        )
      ];
    };
  };
}
