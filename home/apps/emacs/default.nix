{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages =
      epkgs:
      let
        packages = [
          epkgs.catppuccin-theme
          epkgs.meow
          epkgs.treesit-grammars.with-all-grammars
          epkgs.disable-mouse
          epkgs.eat
          epkgs.vertico
          epkgs.marginalia
          epkgs.nix-mode
        ];
        config = epkgs.trivialBuild {
          pname = "default";
          src = ./.;
          version = "0.1.0";
          packageRequires = packages;
        };
      in
      [ config ];
  };
  services.emacs.enable = true;
}
