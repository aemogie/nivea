{
  inputs,
  pkgs,
  ...
}: {
  home.packages = let
    ue4pkgs = import inputs.ue4-nixpkgs {
      inherit (pkgs) system;
      config.allowUnfree = true;
    };
  in [
    (ue4pkgs.ue4.overrideAttrs (prev: rec {
      version = "4.27.2";
      sourceRoot = "UnrealEngine-${version}-release";
      src = pkgs.requireFile {
        name = "${sourceRoot}.zip";
        url = "https://github.com/EpicGames/UnrealEngine/releases/tag/${version}-release";
        sha256 = "1vi302nkr7jvkarf3wrqkii1xpdsqvcisghixsqs2czz17knw067";
      };
    }))
  ];
}
