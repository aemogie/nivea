{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    wrapper-modules.url = "github:nix-community/nix-wrapper-modules";
    wrapper-modules.inputs.nixpkgs.follows = "nixpkgs";
    reka.url = "git+https://code.tvl.fyi/depot.git:/tools/emacs-pkgs/reka.git";
    reka.flake = false;
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./modules ]; };
}
