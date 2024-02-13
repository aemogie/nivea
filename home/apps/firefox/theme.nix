{
  author = "Mozilla";
  browser_specific_settings = {gecko = {id = "default-theme@mozilla.org";};};
  dark_theme = {
    colors = let
      inherit (config.paint.core) base text green mauve;
    in {
      appmenu_info_icon_color = "#80EBFF";
      appmenu_update_icon_color = "#54FFBD";
      autocomplete_popup_separator = "rgb(82,82,94)";
      button = "rgb(43,42,51)";
      button_active = "rgb(91,91,102)";
      button_hover = "rgb(82,82,94)";
      button_primary = "rgb(0, 221, 255)";
      button_primary_active = "rgb(170, 242, 255)";
      button_primary_color = "rgb(43, 42, 51)";
      button_primary_hover = "rgb(128, 235, 255)";
      frame = "#1c1b22";
      icons = "rgb(251,251,254)";
      input_background = "#42414D";
      input_border = "#8f8f9d";
      input_color = "rgb(251,251,254)";
      ntp_background = "rgb(43, 42, 51)";
      ntp_text = "rgb(251, 251, 254)";
      popup = "rgb(66,65,77)";
      popup_border = "rgb(82,82,94)";
      popup_highlight = "rgb(43,42,51)";
      popup_text = "rgb(251,251,254)";
      sidebar = "#38383D";
      sidebar_border = "rgba(255, 255, 255, 0.1)";
      sidebar_text = "rgb(249, 249, 250)";
      tab_background_text = "#fbfbfe";
      tab_icon_overlay_fill = "rgb(251,251,254)";
      tab_icon_overlay_stroke = "rgb(66,65,77)";
      tab_line = "transparent";
      tab_selected = "rgb(66,65,77)";
      tab_text = "rgb(251,251,254)";
      toolbar = "#2b2a33";
      toolbar_bottom_separator = "hsl(240, 5%, 5%)";
      toolbar_field = "rgb(28,27,34)";
      toolbar_field_border = "transparent";
      toolbar_field_focus = "rgb(66,65,77)";
      toolbar_field_text = "rgb(251,251,254)";
      toolbar_text = "rgb(251, 251, 254)";
      toolbar_top_separator = "transparent";
    };
    properties = {
      panel_active = "color-mix(in srgb, currentColor 14%, transparent)";
      panel_active_darker = "color-mix(in srgb, currentColor 25%, transparent)";
      panel_hover = "color-mix(in srgb, currentColor 9%, transparent)";
      toolbar_field_icon_opacity = "1";
      zap_gradient = "linear-gradient(90deg, #9059FF 0%, #FF4AA2 52.08%, #FFBD4F 100%)";
    };
  };
  description = "Follow the operating system setting for buttons, menus, and windows.";
  icons = {"32" = "icon.svg";};
  manifest_version = 2;
  name = "System theme — auto";
  theme = {};
  theme_experiment = {
    colors = {
      appmenu_info_icon_color = "--panel-banner-item-info-icon-bgcolor";
      appmenu_update_icon_color = "--panel-banner-item-update-supported-bgcolor";
      autocomplete_popup_separator = "--autocomplete-popup-separator-color";
      button = "--button-bgcolor";
      button_active = "--button-active-bgcolor";
      button_hover = "--button-hover-bgcolor";
      button_primary = "--button-primary-bgcolor";
      button_primary_active = "--button-primary-active-bgcolor";
      button_primary_color = "--button-primary-color";
      button_primary_hover = "--button-primary-hover-bgcolor";
      input_background = "--input-bgcolor";
      input_border = "--input-border-color";
      input_color = "--input-color";
      tab_icon_overlay_fill = "--tab-icon-overlay-fill";
      tab_icon_overlay_stroke = "--tab-icon-overlay-stroke";
    };
    properties = {
      panel_active = "--arrowpanel-dimmed-further";
      panel_active_darker = "--panel-item-active-bgcolor";
      panel_hover = "--panel-item-hover-bgcolor";
      toolbar_field_icon_opacity = "--urlbar-icon-fill-opacity";
      zap_gradient = "--panel-separator-zap-gradient";
    };
  };
  version = "1.3";
}
