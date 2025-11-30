{
  config,
  osConfig,
  ...
}:
{
  programs.helix =
    let
      inherit (osConfig.paint.active.ctpCompat) flavor;
    in
    {
      enable = true;
      settings = {
        editor = {
          auto-save = false; # just got annoying
          # bufferline = "multiple";
          completion-replace = true;
          completion-trigger-len = 0;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          cursorline = true;
          indent-guides.render = true;
          lsp = {
            display-inlay-hints = true;
            display-messages = true;
          };
          soft-wrap = {
            enable = false;
            wrap-at-text-width = true;
          };
          smart-tab.supersede-menu = true;
        };
        keys = {
          insert = {
            j.j = "normal_mode";
            j.k = "normal_mode";
          };
          normal = {
            H = ":buffer-previous";
            K = "hover";
            L = ":buffer-next";
            space = {
              c = ":buffer-close";
              q = ":quit";
              tab = ":buffer-next";
              w = ":write";
              f = "file_picker_in_current_directory";
              F = "no_op";
            };
          };
        };
        theme = "catppuccin_${flavor}_transparent";
      };

      themes."catppuccin_${flavor}_transparent" = {
        inherits = "catppuccin_${flavor}";
        "ui.background" = { };
        "ui.cursorline.primary" = { };
      };
    };
}
