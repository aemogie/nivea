{
  description = "aemogie's config: i like pretty things";

  outputs =
    {
      nixpkgs,
      home-manager,
      self,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      hostName = "serena";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.${hostName} = lib.nixosSystem rec {
        specialArgs = lib.foldlAttrs (
          acc: name: value:
          let
            split = lib.splitString "-" name;
            new =
              if (builtins.elemAt split 0) == "fetch" then
                { fetched = lib.setAttrByPath (builtins.tail split) value; }
              else
                { inputs."${name}" = value; };
          in
          lib.recursiveUpdate acc new
        ) { } inputs;
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
      formatter.${system} = pkgs.nixfmt-tree;
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nixd
          self.formatter.${system}
        ];
        MANPATH = "${home-manager.packages.${system}.docs-manpages}/share/man:";
      };
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

    # non-flake fetchers, locked through the flake still
    fetch-catppuccin-ytmusic = {
      url = "github:catppuccin/youtubemusic";
      flake = false;
    };
  };
}
