{
  description = "nivea: silly but pretty";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;
      snowfall.namespace = "nivea";
      outputs-builder = channels: {
        packages =
          channels.nixpkgs.lib.concatMapAttrs (k: v: {
            "${k}-vm" = v.config.system.build.vm;
          })
          inputs.self.nixosConfigurations;
      };
    };
}
