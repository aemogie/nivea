{osConfig, ...}: let
  theme = {
    crust,
    mantle,
    base,
    overlay0,
    text,
    primary,
    ...
  }: {
    colors = {
      button_background_active = "rgb(108, 112, 134)";
      frame = "rgb(17, 17, 27)";
      frame_inactive = "rgb(17, 17, 27)";
      icons = "rgb(245, 194, 231)";
      icons_attention = "rgb(245, 194, 231)";
      ntp_background = "rgb(30, 30, 46)";
      ntp_text = "rgb(205, 214, 244)";
      popup = "rgb(30, 30, 46)";
      popup_border = "rgb(245, 194, 231)";
      popup_highlight = "rgb(108, 112, 134)";
      popup_highlight_text = "rgb(205, 214, 244)";
      popup_text = "rgb(205, 214, 244)";
      sidebar = "rgb(30, 30, 46)";
      sidebar_border = "rgb(245, 194, 231)";
      sidebar_highlight = "rgb(245, 194, 231)";
      sidebar_highlight_text = "rgb(17, 17, 27)";
      sidebar_text = "rgb(205, 214, 244)";
      tab_background_separator = "rgb(245, 194, 231)";
      tab_background_text = "rgb(205, 214, 244)";
      tab_line = "rgba(245, 194, 231, 0)";
      tab_loading = "rgb(245, 194, 231)";
      tab_selected = "rgb(30, 30, 46)";
      tab_text = "rgb(205, 214, 244)";
      toolbar = "rgb(30, 30, 46)";
      toolbar_bottom_separator = "rgb(30, 30, 46)";
      toolbar_field = "rgb(24, 24, 37)";
      toolbar_field_border = "rgb(30, 30, 46)";
      toolbar_field_border_focus = "rgb(245, 194, 231)";
      toolbar_field_focus = "rgb(30, 30, 46)";
      toolbar_field_highlight = "rgb(245, 194, 231)";
      toolbar_field_highlight_text = "rgb(30, 30, 46)";
      toolbar_field_separator = "rgb(245, 194, 231)";
      toolbar_field_text = "rgb(205, 214, 244)";
      toolbar_text = "rgb(205, 214, 244)";
      toolbar_vertical_separator = "rgb(245, 194, 231)";
    };
  };
in {
  manifest_version = 2;

  browser_specific_settings.gecko.id = "custom@paint.nix";

  name = "paint.nix auto-generated theme";
  description = "Theme generated using home-manager paint.nix module.";
  author = "aemogie.";
  version = "0.1";

  # icons = {"32" = "icon.svg";};

  theme = theme osConfig.paint.light;
  dark_theme = theme osConfig.paint.dark;

  # theme_experiment = {
  #   colors = {
  #     button = "--button-bgcolor";
  #     button_hover = "--button-hover-bgcolor";
  #     button_active = "--button-active-bgcolor";
  #     button_primary = "--button-primary-bgcolor";
  #     button_primary_hover = "--button-primary-hover-bgcolor";
  #     button_primary_active = "--button-primary-active-bgcolor";
  #     button_primary_color = "--button-primary-color";
  #     input_background = "--input-bgcolor";
  #     input_color = "--input-color";
  #     input_border = "--input-border-color";
  #     autocomplete_popup_separator = "--autocomplete-popup-separator-color";
  #     appmenu_update_icon_color = "--panel-banner-item-update-supported-bgcolor";
  #     appmenu_info_icon_color = "--panel-banner-item-info-icon-bgcolor";
  #     tab_icon_overlay_stroke = "--tab-icon-overlay-stroke";
  #     tab_icon_overlay_fill = "--tab-icon-overlay-fill";
  #   };
  #   properties = {
  #     panel_hover = "--panel-item-hover-bgcolor";
  #     panel_active = "--arrowpanel-dimmed-further";
  #     panel_active_darker = "--panel-item-active-bgcolor";
  #     toolbar_field_icon_opacity = "--urlbar-icon-fill-opacity";
  #     zap_gradient = "--panel-separator-zap-gradient";
  #   };
  # };
}
