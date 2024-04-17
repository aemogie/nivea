{
  description = "aemogie's config: i like pretty things";

  outputs = {
    nixpkgs,
    home-manager,
    hyprland,
    self,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = let
      system = {isVm ? false}: let
        specialArgs = {inherit inputs isVm;};
      in
        lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./host
            ./home
            home-manager.nixosModules.home-manager
            {home-manager.extraSpecialArgs = specialArgs;}
          ];
        };
    in {
      nixos = system {};
      vmnix = system {isVm = true;};
    };
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
    ];
    extra-trusted-public-keys = [
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ue4-nixpkgs.url = "github:yvt/nixpkgs/update-ue4";
    netbeans-nixpkgs.url = "nixpkgs/976fa3369d722e76f37c77493d99829540d43845";
    home-manager = {
      url = "github:nix-community/home-manager";
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
