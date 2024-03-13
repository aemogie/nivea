{
  lib,
  config,
  options,
  ...
}:
with lib;
with lib.nivea; let
  cfg = config.user;
  opt = options.user;
in {
  options.user = with types; {
    enable = mkBoolOpt true "Whether to enable single-user configuration.";
    name = mkOpt str "aemogie" "The name to use for the user account.";
    initialPassword =
      mkOpt str "password"
      "The initial password to use when the user is first created.";
    extraGroups = mkOpt (listOf str) [] "Extra groups to add the user to.";
  };

  config = mkIf cfg.enable {
    # no idea what half of these do, tbh
    user.extraGroups = ["wheel" "audio" "video" "networkmanager" "input" "tty"];

    users.users.${cfg.name} = {
      isNormalUser = true;
      group = "users";
      name = mkAliasDefinitions opt.name;
      home = mkAliasAndWrapDefinitions (name: "/home/${name}") opt.name;
      initialPassword = mkAliasDefinitions opt.initialPassword;
      extraGroups = mkAliasDefinitions opt.extraGroups;
    };
  };
}
