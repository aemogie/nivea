{
  flake.modules.features.emacs-builtin-ui = {
    emacs.setopt = {
      scroll-bar-mode = "nil";
      menu-bar-mode = "nil";
      tooltip-mode = "nil";
      tool-bar-mode = "nil";

      line-spacing = "0.5";
      default-frame-alist = ''
        '((alpha-background . 70)
         (font . "Aporetic Sans Mono 13")
         (internal-border-width . 24)
         (vertical-scroll-bars . nil))
      '';
    };
  };

  flake.modules.features.emacs-vertico = {
    emacs.packages = epkgs: [ epkgs.vertico ];
    emacs.init = ''
      (require 'vertico)
      (vertico-mode t)
    '';
  };

  flake.modules.features.emacs-marginalia = {
    emacs.packages = epkgs: [ epkgs.marginalia ];
    emacs.init = ''
      (require 'marginalia)
      (marginalia-mode t)
    '';
  };

  flake.modules.features.emacs-orderless = {
    emacs.packages = epkgs: [ epkgs.orderless ];
    emacs.setopt = {
      "!" = "(require 'orderless)";
      completion-styles = "'(orderless basic)";
      completion-category-overrides = "'((file . ((styles . (basic partial-completion)))))";
      orderless-matching-styles = "'(orderless-flex orderless-regexp)";
    };
  };
}
