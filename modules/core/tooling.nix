{
  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt-tree.override {
      settings.formatter.nixfmt.options = [ "--width=80" ];
    };
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        pkgs.nixd
        pkgs.nixfmt # nixd expcets this in $PATH
      ];
    };
  };
}
