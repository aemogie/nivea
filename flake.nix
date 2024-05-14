{
  description = "aemogie's config: i like pretty things";

  outputs =
    {
      nixpkgs,
      home-manager,
      lix-module,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      hostName = "seren";
    in
    {
      nixosConfigurations.${hostName} = lib.nixosSystem rec {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          lix-module.nixosModules.default
          {
            networking.hostName = hostName;
            home-manager.extraSpecialArgs = specialArgs;
          }
          ./host
          ./home
        ];
      };
      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };

  nixConfig = {
    # sandbox = false;
    builders-use-substitutes = true;
    keep-going = true;
    extra-substituters = [
      "https://helix.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.lix.systems"
    ];
    extra-trusted-public-keys = [
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix";
      flake = false;
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    helix.url = "github:helix-editor/helix";
  };
}
