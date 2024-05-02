# thanks https://github.com/montchr/dotfield
{
  currentVersion = 20;
  newElementCount = 2;
  dirtyAreaCache = [
    "unified-extensions-area"
    "nav-bar"
    "PersonalToolbar"
    "toolbar-menubar"
    "TabsToolbar"
  ];
  placements = {
    PersonalToolbar = [
      # "import-button"
      "personal-bookmarks"
    ];
    TabsToolbar = [
      # "firefox-view-button"
      "tabbrowser-tabs"
      # "new-tab-button"
      # "alltabs-button"
    ];
    nav-bar = [
      "back-button"
      "forward-button"
      # "stop-reload-button"
      # "customizableui-special-spring1"
      "urlbar-container"
      # "customizableui-special-spring2"
      # "save-to-pocket-button"
      "downloads-button"
      # "developer-button"
      # "fxa-toolbar-menu-button"
      "unified-extensions-button"
    ];
    toolbar-menubar = [ "menubar-items" ];
    unified-extensions-area = [
      "enhancerforyoutube_maximerf_addons_mozilla_org-browser-action"
      "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" # Bitwarden
      "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action" # Stylus
      "addon_darkreader_org-browser-action"
      "sponsorblocker_ajay_app-browser-action"
      "ublock0_raymondhill_net-browser-action"
      "dearrow_ajay_app-browser-action"
    ];
    widget-overflow-fixed-list = [ ];
  };
  # seen = [
  #   "save-to-pocket-button"
  #   "developer-button"
  #   "profiler-button"
  #   "enhancerforyoutube_maximerf_addons_mozilla_org-browser-action"
  #   "sponsorblocker_ajay_app-browser-action"
  #   "ublock0_raymondhill_net-browser-action"
  #   "addon_darkreader_org-browser-action"
  #   "dearrow_ajay_app-browser-action"
  #   "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" # Bitwarden
  #   "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action" # Stylus
  # ];
}
