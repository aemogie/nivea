{
  lib,
  config,
  ...
}:
with lib;
with lib.nivea; let
  cfg = config.user;
in {
  options.user = with types; {
    name = mkOpt str "aemogie" "The name to use for the user account.";
    initialPassword =
      mkOpt str "password"
      "The initial password to use when the user is first created.";
  };

  config.users.users.${cfg.name} = {
    isNormalUser = true;
    inherit (cfg) name initialPassword;
    home = "/home/${cfg.name}";
    group = "users";

    # no idea what half of these do, tbh
    extraGroups = ["wheel" "audio" "video" "networkmanager" "input" "tty"];
  };
}
