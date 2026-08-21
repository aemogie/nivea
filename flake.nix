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
        modules =
          let
            libExtender = prev: { config, ... }: {
              options.lib' = prev.mkOption {
                type = prev.types.mkOptionType {
                  name = "overlays for lib";
                  merge =
                    locs: defs:
                    let
                      extensions = prev.composeManyExtensions (
                        map prev.toExtension (prev.options.getValues defs)
                      );
                    in
                    prev.fix (prev.extends extensions (prev.const prev));
                };
                default = { };
              };
              config._module.args.lib' = config.lib';
              config.lib' = final: { extenderModule = libExtender final; };
            };
          in
          [
            (libExtender lib)
            home-manager.nixosModules.home-manager
            ({ lib', ... }: {
              networking.hostName = hostName;
              home-manager = {
                extraSpecialArgs = specialArgs;
                sharedModules = [
                  lib'.extenderModule
                  ({ lib, ... }: { config.lib'.hm = lib.hm; })
                ];
              };
            })
            ./host
            ./home
          ];
      };
      formatter.${system} = pkgs.nixfmt-tree.override {
        settings.formatter.nixfmt.options = [ "--width=80" ];
      };
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
    fetch-catppuccin-grub = {
      url = "github:catppuccin/grub";
      flake = false;
    };
    fetch-catppuccin-plymouth = {
      url = "github:catppuccin/plymouth";
      flake = false;
    };
    fetch-catppuccin-ytmusic = {
      url = "github:catppuccin/youtubemusic";
      flake = false;
    };
  };
}
