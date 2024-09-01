{
  applyPatches,
  fetchurl,
  palette,
  font,
  label ? "discord.nix",
  ...
}:
applyPatches (
  {
    src = fetchurl {
      name = "discord-midnight.css";
      urls = [
        "https://refact0r.github.io/midnight-discord/midnight.css"
        "https://raw.githubusercontent.com/refact0r/midnight-discord/master/midnight.css"
      ];
      sha256 = "sha256-LK6s1F7pJJM1Zd6YlVKpi9P9JBhmZWa5Y3sVjEbxWfk=";
    };
    unpackPhase = ''
      runHook preUnpack
      cp $src ./midnight.css
      runHook postUnpack
    '';
    patches = [ ./midnight-paint.patch ];
    postPatch = ''
      substituteAllInPlace ./midnight.css
    '';
    installPhase = ''
      runHook preInstall
      cp ./midnight.css $out
      runHook postInstall
    '';
    inherit font label;
  }
  // (builtins.mapAttrs (_: toString) palette)
)
