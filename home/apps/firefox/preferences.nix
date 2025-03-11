{config, ...}: {
  # my own privacy-ish tweaks
  "browser.search.region" = "US";
  "doh-rollout.home-region" = "US";
  "network.captive-portal-service.enabled" = false; # might be a bad idea, my isp adds a captive portal on plan expiration
  "privacy.globalprivacycontrol.enabled" = true; # "Tell websites not to sell or share my data"
  "privacy.donottrackheader.enabled" = true; # "Send websites a "Do Not Trac" request"
  "cookiebanners.service.mode.privateBrowsing" = 1; # "Automatically refuse cookie banners"
  "signon.firefoxRelay.feature" = "disabled"; # "Suggest Firefox Relay email masks to protect your email address"
  "browser.discover.enabled" = false; # "Allow Firefox to make personalised extension recommendations"
  "datareporting.healthreport.uploadEnabled" = false; # "Allow Firefox to send technical and interaction data to Mozilla"
  # not sure how well this actually works in practice, i just hope it respects my freedoms
  "dom.private-attribution.submission.enabled" = true; # "Allow website to perform privacy-preserving ad measurement"

  # DoH - im not sure if this is good or bad currently
  "doh-rollout.disbale-heuristics" = true;
  "network.trr.mode" = 2;
  # maybe try out a diff
  "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";

  "devtools.chrome.enabled" = false; # the userChrome debugger (dont  need it rn)
  "browser.tabs.inTitlebar" = 0; # removes the close button, assumed to go from CSD to regular, but i dont hv titlebars
  "browser.tabs.closeWindowWithLastTab" = false;
  "ui.key.menuAccessKeyFocuses" = false; # disable the alt menu
  "privacy.query_stripping.enable" = true; # copy without site tracking
  "browser.tabs.maxOpenBeforeWarn" = 2;
  "browser.aboutConfig.showWarning" = false;

  # downloads
  "browser.download.start_downloads_in_tmp_dir" = true;
  "browser.download.useDownloadDir" = false;
  "browser.download.always_ask_before_handling_new_types" = true;
  "browser.download.dir" = "/tmp/firefox-downloads/"; # override anyways
  "browser.download.lastDir" = "/tmp/firefox-downloads/";

  # fake fullscreen
  "full-screen-api.ignore-widgets" = true;
  "full-screen-api.warning.timeout" = 0;
  "full-screen-api.transition.timeout" = 0;

  # default fonts
  "font.name.monospace.x-western" = config.fonts.monospace;
  "font.name.sans-serif.x-western" = config.fonts.sans;
  "font.name.serif.x-western" = config.fonts.serif;
  "font.default.x-western" = "sans-serif";

  # overscroll. thanks, https://github.com/AbrarSL
  "apz.gtk.pangesture.delta_mode" = 2;
  "apz.gtk.pangesture.pixel_delta_mode_multiplier" = 25;
  "apz.fling_friction" = 4.0e-3;
  "apz.overscroll.enabled" = true;

  # allow custom extensions
  "xpinstall.signatures.required" = false;
  "xpinstall.whitelist.required" = false;

  # urlbar
  "browser.urlbar.suggest.trending" = false;
  "browser.urlbar.trimHttps" = true;
  "browser.urlbar.trimURLs" = true;

  # disable "This time, search with" (part 1, see default.nix for rest)
  "browser.urlbar.shortcuts.bookmarks" = false;
  "browser.urlbar.shortcuts.history" = false;
  "browser.urlbar.shortcuts.quickactions" = false;
  "browser.urlbar.shortcuts.tabs" = false;
}
