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
      sha256 = "sha256-pN4ojz8UDwlHGh5j4IVWv2Qvtz8N9myrmNEedfils+Q=";
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
