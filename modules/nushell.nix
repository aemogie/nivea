{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (builtins) baseNameOf;
  inherit (lib)
    mkOption
    concatMapStrings
    optionalString
    hasPrefix
    ;
  inherit (lib.types)
    attrs
    bool
    listOf
    pathInStore
    addCheck
    ;
  cfg = config.programs.nushell;
in
{
  options.programs.nushell = {
    config = mkOption {
      type = attrs;
      description = "Values for `$env.config`.";
      default = { };
    };
    loadSessionVariables = mkOption {
      type = bool;
      description = "Use bash to load `home.sessionVariables` then export them to nu.";
      default = false;
    };
    plugins =
      let
        pluginType = addCheck pathInStore (t: hasPrefix "nu_plugin_" (baseNameOf t));
      in
      mkOption {
        type = listOf pluginType;
        description = "";
        default = [ ];
      };
  };
  config.programs.nushell = {
    # nuon is a superset of json
    extraConfig =
      ''
        $env.config = ${builtins.toJSON cfg.config};
      ''
      + (concatMapStrings (p: ''
        register ${p};
      '') cfg.plugins);
    extraLogin =
      let
        env = "${pkgs.coreutils}/bin/env";
        bash = lib.getExe pkgs.bash;
      in
      # TODO: make this into an IFD, and load it into systemd.user.sessionVariables instead
      optionalString cfg.loadSessionVariables
        #nu
        ''
          # USER is set cause --ignore-environment breaks it
          do {
            ${env} --ignore-environment USER=${config.home.username} ${bash} --login -c ${env}
          }
          | complete | get stdout
          | lines
          | reduce -f {} {|it, acc|
              let kv = ($it | split row = -n 2);
              # _, PWD and SHLVL are bash builtins. idk where TERM=dumb sneaked in, but thats a thing too
              if not ($kv.0 in [TERM _ PWD SHLVL]) {
                $acc | merge {$kv.0: $kv.1}
              } else {$acc}
            }
          | load-env
        '';
  };
}
