{
  config,
  theme,
  extensions,
  custom_apps,
  extraCommands,
  ...
}:
{
  lib,
  spotify,
  spicetify-cli,
  coreutils-full,
  makeWrapper,
  ...
}:
let
  inherit (builtins) isAttrs isList concatStringsSep;
  inherit (lib.strings) optionalString;

  toINI = lib.generators.toINI {
    # specifies how to format a key/value pair
    mkKeyValue = lib.generators.mkKeyValueDefault {
      # specifies the generated string for a subset of nix values
      mkValueString =
        v:
        if v == true then
          "1"
        else if v == false then
          "0"
        else if isList v then
          builtins.concatStringsSep "|" v
        # else if isString v then ''"${v}"''
        # and delegates all other values to the default generator
        else
          lib.generators.mkValueStringDefault { } v;
    } "=";
  };
  cpListIntoDir =
    dir: list: concatStringsSep "\n" (map (path: "cp -rn ${path} ${dir}/${baseNameOf path}") list);
in
(builtins.trace "spotify version: ${spotify.version}" spotify).overrideAttrs (old: {
  pname = "spicetify";
  buildInputs = (old.buildInputs or [ ]) ++ [
    (builtins.trace "spicetify version: ${spicetify-cli.version}" spicetify-cli)
    coreutils-full
    makeWrapper
  ];
  postInstall =
    (old.postInstall or "")
    + ''
      set -e
      export SPICETIFY_CONFIG=$out/share/spicetify
      mkdir -p $SPICETIFY_CONFIG

      # grab the css map
      cp -rn ${spicetify-cli.src}/css-map.json $SPICETIFY_CONFIG/css-map.json

      pushd $SPICETIFY_CONFIG

      # create config and prefs
      cat <<EOF > config-xpui.ini
      ${toINI config}
      EOF

      chmod a+wr config-xpui.ini
      touch $out/share/spotify/prefs

      substituteInPlace config-xpui.ini \
        --subst-var-by SPOTIFY_PATH $out/share/spotify \
        --subst-var-by PREFS_PATH $out/share/spotify/prefs

      ${optionalString (theme.enable) ''
        mkdir -p Themes
        cp -rn ${theme.path} Themes/${baseNameOf theme.path}
        chmod -R a+wr Themes
      ''}

      mkdir -p Extensions
      ${cpListIntoDir "Extensions" extensions}
      chmod -R a+wr Extensions

      mkdir -p CustomApps
      ${cpListIntoDir "CustomApps" custom_apps}
      chmod -R a+wr CustomApps

      ${optionalString (theme.enable && (isAttrs theme.colorScheme)) ''
        echo -en '\n' >> Themes/${theme.name}/color.ini
        cat <<EOF >> Themes/${theme.name}/color.ini
        [${theme.customColorSchemeName}]
        ${toINI theme.colorScheme}
        EOF
      ''}

      ${extraCommands}

      popd > /dev/null
      spicetify-cli --no-restart backup apply
    '';
})
