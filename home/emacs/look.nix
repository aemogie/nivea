{
  lib',
  config,
  osConfig,
  ...
}:
let
  inherit (lib'.elisp)
    call
    sym
    mkElispInline
    if'
    splice
    lambda
    when
    and
    sane-alist-cons
    ;
in
{
  programs.emacs.use-package.emacs.custom = {
    scroll-bar-mode = false;
    menu-bar-mode = false;
    tooltip-mode = false;
    tool-bar-mode = false;
  };

  programs.emacs.use-package.frame = {
    enable = true;
    package = null;
    custom = {
      line-spacing = 0.5;
      default-frame-alist = sane-alist-cons {
        font = "${config.fonts.monospace} 13";
        alpha-background = 70;
        internal-border-width = 24;
        vertical-scroll-bars = false;
      };
    };
  };

  programs.emacs.use-package.vertico = {
    enable = true;
    custom.vertico-mode = true;
  };
  programs.emacs.use-package.marginalia = {
    enable = true;
    custom.marginalia-mode = true;
  };
  programs.emacs.use-package.corfu = {
    enable = true;
    custom.global-corfu-mode = true;
  };
  programs.emacs.use-package.orderless = {
    enable = true;
    custom = {
      completion-styles = map sym [
        "orderless"
        "basic"
      ];
      completion-category-overrides = sane-alist-cons (
        lib'.mapAttrs (_: sane-alist-cons) {
          file.styles = map sym [
            "basic"
            "partial-completion"
          ];
        }
      );
      orderless-matching-styles = map sym [
        "orderless-flex"
        "orderless-regexp"
      ];
    };
  };

  programs.emacs.use-package.rainbow-delimiters = {
    enable = true;
    hook.prog-mode = true;
  };

  programs.emacs.use-package.compile = {
    enable = true;
    package = null;
    hook.compilation-filter = [
      "ansi-color-compilation-filter"
      "ansi-osc-compilation-filter"
    ];
  };

  programs.emacs.use-package.treesit = {
    enable = true;
    package = epkgs: epkgs.treesit-grammars.with-all-grammars;
    custom.treesit-font-lock-level = 4;
  };

  programs.emacs.use-package.org-modern = {
    enable = true;
    hook = {
      org-mode = true;
      org-agenda-finalize = "org-modern-agenda";
    };
  };

  programs.emacs.use-package.spacious-padding = {
    enable = false; # conflicts too much with other things
    custom.spacious-padding-mode = true;
  };

  programs.emacs.use-package.page-break-lines = {
    enable = true;
    custom.page-break-lines-modes = [ (sym "prog-mode") ];
    config' = call "global-page-break-lines-mode";
  };

  programs.emacs.use-package.visual-fill-column = {
    enable = true;
    custom.visual-fill-column-center-text = true;
  };
  programs.emacs.use-package.writeroom-mode.enable = true;

  programs.emacs.use-package.dbus = {
    enable = true;
    package = null;
    demand = true;
  };
  programs.emacs.use-package.catppuccin-theme = {
    enable = true;
    after = [ "dbus" ];
    custom = {
      custom-safe-themes = true;
      custom-enabled-themes = [ (sym "catppuccin") ];
    };
    /*nixfmt:disable*/
    config' =
      let
	changeTheme =
          value:
          if' (call "eq" value 2)
	    (call "catppuccin-load-flavor" (sym osConfig.paint.light.ctpCompat.flavor))
	    (call "catppuccin-load-flavor" (sym osConfig.paint.dark.ctpCompat.flavor));
        # dbus nonsense
        portal = {
          bus = mkElispInline ":session";
          service = "org.freedesktop.portal.Desktop";
          path = "/org/freedesktop/portal/desktop";
          interface = "org.freedesktop.portal.Settings";
        };
        qualifier = [portal.bus portal.service portal.path portal.interface];
        setting = {
	  # the settings portal is structured essentially as a bunch of (namespace.key = value)
          namespace = "org.freedesktop.appearance";
          key = "color-scheme";
        };
        signalHandler = lambda {
          args = ["namespace" "key" "value"];
          body =
            {namespace, key, value}:
            when (and [
              (call "string=" namespace setting.namespace)
              (call "string=" key setting.key)
            ]) (changeTheme (call "car" value));
        };
      in [
	# check setting for initial theeme
	(changeTheme (call "caar"
	  (call "dbus-call-method" (splice qualifier) "Read" setting.namespace setting.key)))
	# change it later when setting changes
	(call "dbus-register-signal" (splice qualifier) "SettingChanged" signalHandler)
      ];
    /*nixfmt:enable*/
  };

  systemd.user.services.emacs.Unit = {
    # provides the settings portal that we use above
    Wants = [ "xdg-desktop-portal-gtk.service" ];
    After = [ "xdg-desktop-portal-gtk.service" ];
  };
}
