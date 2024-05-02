{ light, dark, ... }:
let
  theme =
    {
      crust,
      mantle,
      base,
      overlay0,
      surface0,
      text,
      primary,
      ...
    }:
    {
      toolbar = "#${base}";
      toolbar_text = "#${text}";
      frame = "#${crust}";
      tab_background_text = "#${text}";
      toolbar_field = "#${mantle}";
      toolbar_field_text = "#${text}";
      tab_line = "transparent";
      popup = "#${base}";
      popup_text = "#${text}";
      button_background_active = "#${overlay0}";
      frame_inactive = "#${crust}";
      icons_attention = "#${primary}";
      icons = "#${primary}";
      ntp_background = "#${base}";
      ntp_card_background = "#${surface0}";
      ntp_text = "#${text}";
      popup_border = "#${crust}";
      popup_highlight_text = "#${text}";
      popup_highlight = "#${overlay0}";
      sidebar_border = "#${primary}";
      sidebar_highlight_text = "#${text}";
      sidebar_highlight = "#${primary}";
      sidebar_text = "#${text}";
      sidebar = "#${base}";
      tab_background_separator = "#${primary}";
      tab_loading = "#${primary}";
      tab_selected = "#${base}";
      tab_text = "#${text}";
      toolbar_bottom_separator = "#${base}";
      toolbar_field_border_focus = "#${primary}";
      toolbar_field_border = "#${base}";
      toolbar_field_focus = "#${base}";
      toolbar_field_highlight_text = "#${base}";
      toolbar_field_highlight = "#${primary}";
      toolbar_vertical_separator = "#${primary}";
    };
in
{
  manifest_version = 2;

  browser_specific_settings.gecko.id = "custom@paint.nix";

  name = "paint.nix auto-generated theme";
  description = "Theme generated using home-manager paint.nix module.";
  author = "aemogie.";
  version = "0.2";

  theme.colors = theme light;
  dark_theme.colors = theme dark;
}
