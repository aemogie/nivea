{ osConfig, ... }:
let
  inherit (osConfig.paint.active.palette)
    text
    base
    surface0
    surface2
    error
    warning
    primary
    alternate
    ;
  theme =
    builtins.mapAttrs
      (_: c: "rgba(${toString c.r}, ${toString c.g}, ${toString c.b}, ${toString (c.a or 1)})")
      {
        default-fg = text;
        default-bg = base;

        completion-bg = surface0;
        completion-fg = text;
        completion-highlight-bg = surface2;
        completion-highlight-fg = text;
        completion-group-bg = surface0;
        completion-group-fg = alternate;

        statusbar-fg = text;
        statusbar-bg = surface0;

        notification-bg = surface0;
        notification-fg = text;
        notification-error-bg = surface0;
        notification-error-fg = error;
        notification-warning-bg = surface0;
        notification-warning-fg = warning;

        inputbar-fg = text;
        inputbar-bg = surface0;

        recolor-lightcolor = base;
        recolor-darkcolor = text;

        index-fg = text;
        index-bg = base;
        index-active-fg = text;
        index-active-bg = surface0;

        render-loading-bg = base;
        render-loading-fg = text;

        highlight-color = primary // {
          a = 0.5;
        };
        highlight-fg = text;
        highlight-active-color = text;
      };
in
{
  programs.zathura = {
    enable = true;
    options = theme // {
      guioptions = "none";
      recolor = true;
      adjust-open = "width";
      selection-clipboard = "clipboard";
      selection-notification = false;
    };
  };
}
