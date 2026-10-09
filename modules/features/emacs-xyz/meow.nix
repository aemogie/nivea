{
  flake.modules.features.emacs-meow = {
    emacs.packages = epkgs: [ epkgs.meow ];
    emacs.setopt = {
      "!" = "(require 'meow)";
      meow-global-mode = "t";
      meow-use-clipboard = "t";
      meow-expand-hint-counts = "'((block . 0) (find . 0) (line . 0) (till . 0) (word . 0))";
    };
    emacs.keymaps.meow-normal-state-keymap = {
      "!" = "(require 'meow)";
      # motion cluster
      "n" = "#'meow-back-word";
      "e" = "#'meow-next";
      "i" = "#'meow-prev";
      "a" = "#'meow-next-word";

      # insert in various ways (shift + motion)
      "N" = "#'meow-insert";
      "E" = "#'meow-open-below";
      "I" = "#'meow-open-above";
      "A" = "#'meow-append";
      "F" = "#'meow-change";

      # undo
      "u" = "#'meow-undo";
      "U" = "#'meow-undo-in-selection";

      # mutation cluster
      "c" = "#'meow-yank";
      "C" = "#'meow-replace";
      "r" = "#'meow-block"; # to be replaced with expreg
      "s" = "#'meow-line";
      "t" = "#'meow-kill";
      "y" = "#'meow-save";

      "g" = "#'keyboard-quit";
      "<escape>" = "#'keyboard-quit";

      # search
      "h" = "#'meow-visit";
      "d" = "#'meow-search";

      # rare
      "G" = "#'meow-grab";
      "k" = "#'meow-till";
      "x" = "#'meow-join";
    };
    emacs.keymaps.meow-motion-state-keymap = {
      "!" = "(require 'meow)";

      "e" = "#'meow-next";
      "i" = "#'meow-prev";

      "h" = "#'meow-visit";
      "d" = "#'meow-search";

      "<escape>" = "#'keyboard-quit";
    };
    emacs.keymaps.mode-specific-map = {
      "!" = "(require 'meow)";
      # very frequent
      "<SPC>" = "#'save-buffer";
      "e" = "#'other-window";
      "E" = "#'delete-window";

      "t" = ''
        (lambda () (interactive)
          (if (eq major-mode 'erc-mode)
              (call-interactively #'erc-switch-to-buffer)
            (if (project-current nil)
                (call-interactively #'project-switch-to-buffer)
              (call-interactively #'switch-to-buffer))))
      '';
      "T" = "#'switch-to-buffer";

      "s" = ''
        (lambda () (interactive (list))
          (if (project-current nil)
              (call-interactively #'project-find-file)
            (call-interactively #'find-file)))
      '';
      "S" = "#'find-file";

      "r" = "#'kill-buffer";
      "R" = "#'project-kill-buffers";

      "y" = ''
        (lambda () (interactive (list))
          (if (project-current nil)
              (call-interactively #'project-compile)
            (call-interactively #'compile)))
      '';
      "Y" = "#'compile";

      "l" = ''
        (lambda () (interactive)
          (if (project-current nil)
              (call-interactively #'project-eshell)
            (call-interactively #'eshell)))
      '';
      "L" = "#'eshell";

      "p" = "#'project-switch-project";
    };
  };
}
