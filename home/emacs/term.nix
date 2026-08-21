{ lib', ... }:
let
  inherit (lib'.elisp)
    call
    sym
    var
    defun
    ;
in
{
  programs.emacs.use-package.eat = {
    enable = true;
    hook.eshell-load = [
      "eat-eshell-mode"
      "eat-eshell-visual-command-mode"
    ];
  };

  programs.emacs.use-package.tramp = {
    enable = true;
    custom = {
      password-cache = true;
      password-cache-expiry = 5 * 60;
      tramp-remote-path = call "append" [ (sym "tramp-own-remote-path") ] (
        var "tramp-remote-path"
      );
    };
  };

  programs.emacs.use-package.eshell = {
    enable = true;
    package = null; # builtin
    after = [ "tramp" ];
    custom.eshell-modules-list = map sym [
      # "eshell-alias"
      # "eshell-banner"
      "eshell-basic"
      "eshell-cmpl"
      "eshell-dirs"
      "eshell-extpipe"
      "eshell-glob"
      "eshell-hist" # TODO: replace with "eshell-atuin"
      "eshell-ls"
      "eshell-pred" # NOTE: looks useful, maybe learn? if not get rid of it
      "eshell-prompt"
      "eshell-script" # sure??? sounds dumb tho
      "eshell-term"
      "eshell-unix"
      "eshell-tramp"
      # "eshell-smart" # it's awful... IMHO!!!
    ];
    config' = defun {
      name = "eshell/c";
      docstring = "Alias to clear screen+scrollback";
      body = call "eshell/clear" true;
    };
  };

  programs.emacs.use-package.comint = {
    enable = true;
    package = null;
    custom.comint-terminfo-terminal = "eterm-color";
  };
}
