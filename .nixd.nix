let
  stringOr = s: other: if (builtins.stringLength s) == 0 then other else s;
  # lsp runs from root anyway on emacs, but in case it doesnt
  flake = stringOr (builtins.getEnv "PROJECT_ROOT") (builtins.getFlake "git+file://${toString ./.}");
  hostname =
    let
      file = builtins.readFile "/etc/hostname";
      stripped = builtins.substring 0 ((builtins.stringLength file) - 1) file;
    in
      stringOr (builtins.getEnv "HOSTNAME") stripped;
in
rec {
  nixpkgs = flake.inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
  nixos = flake.nixosConfigurations.${hostname}.options;
  home-manager = nixos.home-manager.users.type.nestedTypes.elemType.getSubOptions [];
}
