{
  description = "aemogie's config: i like pretty things";

  outputs =
    {
      nixpkgs,
      home-manager,
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
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
