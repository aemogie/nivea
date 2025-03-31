{
  description = "aemogie's config: i like pretty things";

  outputs =
    {
      nixpkgs,
      nixpkgs2,
      home-manager,
      stylix,
      self,
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      hostName = "serena";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.${hostName} = lib.nixosSystem rec {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            networking.hostName = hostName;
            home-manager.extraSpecialArgs = specialArgs;
          }
          ./host
          ./home
        ];
      };
      formatter.${system} = pkgs.nixfmt-rfc-style;
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nixd
          self.formatter.${system}
        ];
      };
    };

  nixConfig = {
    # sandbox = false;
    builders-use-substitutes = true;
    keep-going = true;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs2.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
}
