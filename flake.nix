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
      "https://anyrun.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.lix.systems"
    ];
    extra-trusted-public-keys = [
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
  };

  inputs = {
    nixpkgs.url = "github:auxolotl/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
      flake = false;
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    typst-lsp = {
      url = "github:nvarner/typst-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dont follow nixpkgs for these, they hv binary caches

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";

    helix.url = "github:helix-editor/helix";
    # helix-icons.url = "github:lazytanuki/helix/icons"; # tried it, dont rlly like it.

    anyrun.url = "github:Kirottu/anyrun";
    ctp.url = "path:/home/aemogie/dev/ctp/nix";
    spicetify = {
      url = "github:the-argus/spicetify-nix/48-fix-schema";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs.url = "github:nix-community/emacs-overlay";
  };
}
