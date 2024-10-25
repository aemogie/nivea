((nix-mode . ((eglot-server-programs . ((nix-mode . ("nixd"))))
              (eglot-workspace-configuration
               . (:nixd
                  (:nixpkgs (:expr "(import ./.nixd.nix).nixpkgs")
                   :options (:nixos (:expr "(import ./.nixd.nix).nixos")
                             :home-manager (:expr "(import ./.nixd.nix).home-manager"))
                   :formatting (:command ["nixfmt"]))))))
 (emacs-lisp-mode . ((lexical-binding . t))))
