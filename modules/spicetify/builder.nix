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
  inherit (builtins)
    isAttrs
    isBool
    isList
    concatStringsSep
    ;
  inherit (lib.strings) optionalString;

  toINI = lib.generators.toINI {
    # specifies how to format a key/value pair
    mkKeyValue = lib.generators.mkKeyValueDefault {
      # specifies the generated string for a subset of nix values
      mkValueString =
        v:
        if isBool v then
          if v then "1" else "0"
        else if isList v then
          concatStringsSep "|" v
        # and delegates all other values to the default generator
        else
          lib.generators.mkValueStringDefault { } v;
    } "=";
  };
  cpListIntoDir =
    dir: list: concatStringsSep "\n" (map (path: "ln -s ${path} ${dir}/${baseNameOf path}") list);
in
spotify.overrideAttrs (old: {
  pname = "spicetify";
  buildInputs = (old.buildInputs or [ ]) ++ [
    coreutils-full
    makeWrapper
  ];
  postInstall =
    (old.postInstall or "")
    + ''
      set -e

      # spicetify-cli looks for css-map.json in the executable directory
      # and since we dont want to recompile spicetify-cli, 
      # just copy it locally then add the css-map 
      cp --no-preserve=mode -r ${spicetify-cli} spicetify-cli
      chmod +x spicetify-cli/bin/spicetify-cli
      cp ${spicetify-cli.src}/css-map.json spicetify-cli/bin
      export PATH="$PWD/spicetify-cli/bin:$PATH"

      # set the config directory to current directory. no need 
      export SPICETIFY_CONFIG=$PWD

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

      spicetify-cli --no-restart backup apply
    '';
})
